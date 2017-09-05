param
(
    [Parameter(Mandatory=$true)]
    [String]$Url,
    [Parameter(Mandatory=$true)]
    [string]$Branch
)

git ls-remote $Url refs/heads/$Branch | cut -f 1
