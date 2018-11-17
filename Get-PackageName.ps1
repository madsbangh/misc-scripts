cat .\ProjectSettings\ProjectSettings.asset | sls Android: | select -First 1 | foreach { $_ -split ' ' } | select -Last 1
