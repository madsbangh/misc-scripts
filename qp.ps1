$branch = (Get-GitStatus).Branch
git merge "origin/$branch"
