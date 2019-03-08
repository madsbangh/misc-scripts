$pacname = $args[0]
if ($pacname -eq $null)
{
    $pacname = (Get-PackageName)
}
adb shell monkey -p $pacname -c android.intent.category.LAUNCHER 1
# adb shell am start -n "$pacname/com.unity3d.player.UnityPlayerActivity"
