adb devices | select -Skip 1 | select -SkipLast 1 | % { $_ -replace 'device','' } | % { $_.Trim() }
