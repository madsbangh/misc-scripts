${Unity_2017.3} = 'C:\Program Files\Unity_2017.3\Editor\Unity.exe'
${Unity_5.6.3p1} = 'C:\Program Files\Unity_5.6.3p1\Editor\Unity.exe'

# Default Unity Path
$UnityPath = ${Unity_2017.3}

# Is this a unity project?
if (Test-Path ./Assets)
{
    # Set project path to current dir
    $args += '-projectPath (get-location)'

    # Test Unity version
    if ((Get-Content "$(Get-Location)\ProjectSettings\ProjectVersion.txt") -like '*5.6.3p1')
    {
        echo "Project is using Unity 5.6.3p1"
        $UnityPath = ${Unity_5.6.3p1}
    }
}

# Start unity with args
Invoke-Expression "& '$UnityPath' $args" > $null
