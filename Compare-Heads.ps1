$RemoteSha = Get-RemoteHead -Url (get-origin) -Branch (get-branch)
return (Get-Head) -eq $RemoteSha
