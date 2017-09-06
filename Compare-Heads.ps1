$RemoteSha = Get-RemoteHead -Url (get-origin) -Branch (get-branch)
return (get-sha) -eq $RemoteSha
