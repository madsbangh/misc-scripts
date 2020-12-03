$HubPath = 'C:\Program Files\Unity Hub\Unity Hub.exe'
$HubEditorsPath = 'C:\Program Files\Unity\Hub\Editor'
$EditorsPath = 'C:\Program Files\Unity\'

$UnityPaths = @{}
foreach ($Dir in Get-ChildItem $EditorsPath) { if ($Dir.Name -ne "Hub") {$UnityPaths.Add($Dir.Name, $Dir.FullName + "\Editor\Unity.exe")} }
foreach ($Dir in Get-ChildItem $HubEditorsPath) { $UnityPaths.Add($Dir.Name, $Dir.FullName + "\Editor\Unity.exe") }

function Start-Unity
{
    [CmdletBinding()]
    param (
        $ProjectPath,
        [string] $ArgsString,
        [switch] $ListVersions
    )
    
    DynamicParam
    {
        # Only show Version and Hub params if we are in a project directory
        if (Test-Path '.\Assets')
        {
            $VersionParamAttribute  = New-Object System.Management.Automation.ParameterAttribute
            $VersionParamAttribute.Mandatory  = $false
            $VersionAttributes = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
            $VersionAttributes.Add($VersionParamAttribute)
            $VersionAttributes.Add((New-Object System.Management.Automation.ValidateSetAttribute($UnityPaths.Keys)))
            
            $HubParamAttribute  = New-Object System.Management.Automation.ParameterAttribute
            $HubParamAttribute.Mandatory  = $false
            $HubAttributes = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
            $HubAttributes.Add($HubParamAttribute)

            $VersionRuntimeParam  = New-Object System.Management.Automation.RuntimeDefinedParameter('UnityVersion',  [string], $VersionAttributes)
            $HubRuntimeParam  = New-Object System.Management.Automation.RuntimeDefinedParameter('Hub',  [switch], $HubAttributes)
            
            $RuntimeParamDict  = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
            $RuntimeParamDict.Add('UnityVersion',  $VersionRuntimeParam)
            $RuntimeParamDict.Add('Hub',  $HubRuntimeParam)
            return  $RuntimeParamDict
        }
    }
    Process
    {
        if ($ListVersions)
        {
            return $UnityPaths
        }

        if ($null -eq $ProjectPath)
        {
            $ProjectPath = Get-Location
        }
        else
        {
            $ProjectPath = Resolve-Path $ProjectPath
        }

        # Does user want the Hub or is this not a unity project?
        $AssetsPath = Join-Path $ProjectPath "Assets"
        $ProjectSettingsPath = Join-Path $ProjectPath "ProjectSettings"
        if ($PSBoundParameters.Hub -or !((Test-Path $AssetsPath) -and (Test-Path $ProjectSettingsPath)))
        {
            & $HubPath | Out-Null
        }
        else
        {
            # Set project path to current dir
            $ArgsString = "-projectPath `"$ProjectPath`" " + $ArgsString

            # Default Unity Path
            $UnityPath = $UnityPaths.Values | Sort-Object | Select-Object -First 1

            # Has user defined version?
            if ($PSBoundParameters.UnityVersion)
            {
                $UnityPath = $UnityPaths[$PSBoundParameters.UnityVersion]
            }
            elseif (Test-Path (Join-Path $ProjectSettingsPath "ProjectVersion.txt"))
            {
                # Test project Unity version
                $ProjectVersion = (Get-UnityVersion -ProjectPath $ProjectPath)
                $UnityPath = $UnityPaths[(Get-ClosestUnityVersion $ProjectVersion)]
            }
            # Start unity with args
            Invoke-Expression "& '$UnityPath' $ArgsString" | Out-Null
        }
    }
}

function Get-ClosestUnityVersion
{
	[CmdletBinding()]
	param (
		[Parameter(Position=0, Mandatory=$true)]
		[string] $Version
	)
	
	$HighestVersion = "0.0.0.0"
	$ClosestVersion = "99999.99999.99999.99999"
	$Keys = ($UnityPaths.Keys).Split()
	foreach ($v in $Keys)
	{
		$cv = (Convert-FromUnityVersion $v)
		if ($cv -ge (Convert-FromUnityVersion $Version))
		{
			if ($cv -le (Convert-FromUnityVersion $ClosestVersion))
			{
				$ClosestVersion = $v
			}
		}
		if ($cv -ge (Convert-FromUnityVersion $HighestVersion))
		{
			$HighestVersion = $v
		}
	}

	if ($ClosestVersion -eq "99999.99999.99999.99999")
	{
		return $HighestVersion
	}

	return $ClosestVersion
}

function Convert-FromUnityVersion
{
	[CmdletBinding()]
	param (
		[Parameter(Position=0, Mandatory=$true)]
		[string] $VersionString
	)

	$parseableVersion = $VersionString -Replace "[a-z]","."
	return [Version]$parseableVersion
}

function Get-UnityVersion
{
	[CmdletBinding()]
	param (
        $ProjectPath
    )
    
    if ($null -eq $ProjectPath)
    {
        $ProjectPath = Get-Location
    }
    else
    {
        $ProjectPath = Resolve-Path $ProjectPath
    }

    $ProjectVersionPath = Join-Path $ProjectPath "ProjectSettings\ProjectVersion.txt"

	if (Test-Path $ProjectVersionPath)
    {
        return (Get-Content $ProjectVersionPath | Select-String "^m_EditorVersion: (.+)$").Matches.Groups[1].Value
    }
}