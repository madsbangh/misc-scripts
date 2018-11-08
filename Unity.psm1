$HubPath = 'C:\Program Files\Unity Hub\Unity Hub.exe'
$HubEditorsPath = 'C:\Program Files\Unity\Hub\Editor'
$EditorsPath = 'C:\Program Files\Unity\'

$UnityPaths = @{}
foreach ($Dir in ls $EditorsPath) { if ($Dir.Name -ne "Hub") {$UnityPaths.Add($Dir.Name, $Dir.FullName + "\Editor\Unity.exe")} }
foreach ($Dir in ls $HubEditorsPath) { $UnityPaths.Add($Dir.Name, $Dir.FullName + "\Editor\Unity.exe") }

function Start-Unity
{
    [CmdletBinding()]
    param (
        [string]$ArgsString,
        [switch]$ListVersions
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

            $VersionRuntimeParam  = New-Object System.Management.Automation.RuntimeDefinedParameter('Version',  [string], $VersionAttributes)
            $HubRuntimeParam  = New-Object System.Management.Automation.RuntimeDefinedParameter('Hub',  [switch], $HubAttributes)
            
            $RuntimeParamDict  = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
            $RuntimeParamDict.Add('Version',  $VersionRuntimeParam)
            $RuntimeParamDict.Add('Hub',  $HubRuntimeParam)
            return  $RuntimeParamDict
        }
    }
    Process
    {
        if ($ListVersions)
        {
            $UnityPaths | Format-Table | Out-Default
            return
        }

        # Does user want the Hub or is this not a unity project?
        if ($PSBoundParameters.Hub -or !(Test-Path '.\Assets'))
        {
            & $HubPath | Out-Null
        }
        else
        {
            # Set project path to current dir
            $ArgsString += '-projectPath (get-location)'

            # Default Unity Path
            $UnityPath = $UnityPaths.Values | sort | select -First 1

            # Has user defined version?
            if ($PSBoundParameters.Version)
            {
                $UnityPath = $UnityPaths[$PSBoundParameters.Version]
            }
            elseif (Test-Path '.\ProjectSettings\ProjectVersion.txt')
            {
                # Test project Unity version
                $ProjectVersion = (Get-Content '.\ProjectSettings\ProjectVersion.txt').Replace('m_EditorVersion: ', '')
                if ($UnityPaths.ContainsKey($ProjectVersion))
                {
                    $UnityPath = $UnityPaths[$ProjectVersion]
                }
            }
            # Start unity with args
            Invoke-Expression "& '$UnityPath' $ArgsString" | Out-Null
        }
    }
}
