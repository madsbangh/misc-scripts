﻿git log --format="%aN" | sort -u | foreach {git log --format="%aN (%ar): %s" --author=$_ --since="1 day ago"; echo ""}