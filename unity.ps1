param
(
    [switch] $ForceNewest = $false,
    [switch] $Launcher = $false
)

$UnityPaths = @{
'm_EditorVersion: 2018.1.0b10' = 'C:\Program Files\Unity_2018.1\Editor\Unity.exe';
'm_EditorVersion: 2017.3.1f1' = 'C:\Program Files\Unity_2017.3\Editor\Unity.exe';
'm_EditorVersion: 5.6.3p1' = 'C:\Program Files\Unity_5.6.3p1\Editor\Unity.exe'
}

# Default Unity Path
$UnityPath = $UnityPaths.Values | select -First 1

# Is this a unity project?
if ((-not $Launcher) -and (Test-Path '.\Assets'))
{
    # Set project path to current dir
    $args += '-projectPath (get-location)'

    # Test Unity version
    if ((-not $ForceNewest) -and (Test-Path '.\ProjectSettings\ProjectVersion.txt'))
    {
        $ProjectVersion = Get-Content '.\ProjectSettings\ProjectVersion.txt'
        if ($UnityPaths.ContainsKey($ProjectVersion))
        {
            $UnityPath = $UnityPaths[$ProjectVersion]
        }
    }
}

# Start unity with args
Invoke-Expression "& '$UnityPath' $args" > $null
