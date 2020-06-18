Param (
    [Parameter(Mandatory=$true)]$File
)

function Get-OIDs($File) {
    if ((git diff -- "$File") -as [string] -match '-oid sha256:([0-9a-f]+).+?\+oid sha256:([0-9a-f]+)') {
        return @{
            "Old" = $Matches[1]
            "New" = $Matches[2]
        }
    }
    else {
        throw "Could not find OIDs for file $File"
    }
}

function Get-LFSObjectPath($OID) {
    return ".\.git\lfs\objects\$($OID.Substring(0,2))\$($OID.Substring(2,2))\$OID"
}


$OIDs = Get-OIDs $File
git diff --no-index -- (Get-LFSObjectPath($OIDs.Old)) (Get-LFSObjectPath($OIDs.New))
