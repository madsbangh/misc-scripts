adb devices | select -Skip 1 | % { $_ -replace '\tdevice','' }
