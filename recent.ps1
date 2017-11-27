param
(
    [switch] $Hash,
    [switch] $NoName,
    [switch] $RelTime,
    [switch] $AbsTime,
    [int] $Days = 1
)

if ($NoName)
{
    $format = ""
}
else
{
    $format = "%aN"
}

if ($AbsTime)
{
    $format += " (%ad)"
}

if ($RelTime)
{
    $format += " (%ar)"
}

if ($format -ne "")
{
    $format += ": "
}

$format += "%s"

if ($Hash)
{
    $format += " (%h)"
}

git log --format="%aN" | sort -u | foreach {git log --format="$format" --author=$_ --since="$days days ago" --no-merges; echo ""}