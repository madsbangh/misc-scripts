$RemoteSha = get-head -Url (get-origin) -Branch (get-branch)
return (get-sha) -eq $RemoteSha