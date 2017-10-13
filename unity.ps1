$UnityPath = 'C:\Program Files\Unity_2017.2\Editor\Unity.exe'

# Is this a unity project?
if (Test-Path ./Assets)
{
    # Set project path to current dir
    $args += '-projectPath (get-location)'
}

# Start unity with args
Invoke-Expression "& '$UnityPath' $args" > $null
