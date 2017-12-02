param
(
    [switch] $Hash,
    [switch] $Name,
    [switch] $RelTime,
    [switch] $AbsTime,
    [switch] $Titles,
    [int] $Days = 1
)

$format = ""

if ($Titles)
{
    $format += "    "
}

if ($Name)
{
    $format += "%aN"
}

if ($AbsTime)
{
    $format += " (%ad)"
}

if ($RelTime)
{
    $format += " (%ar)"
}

if ($format -ne "" -and $format -ne "    ")
{
    $format += ": "
}

$format += "%s"

if ($Hash)
{
    $format += " (%h)"
}

git log --format="%aN" | sort -u | foreach {if($Titles){echo "$_"} git log --format="$format" --author=$_ --since="$days days ago" --no-merges; echo ""}