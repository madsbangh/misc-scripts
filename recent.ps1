param
(
    [switch] $hash,
    [switch] $time
)
if ($time)
{
    $format = "%aN (%ad): %s"
}
else
{
    $format = "%aN (%ar): %s"
}
if ($hash)
{
    $format += " (%h)"
}
git log --format="%aN" | sort -u | foreach {git log --format="$format" --author=$_ --since="1 day ago" --no-merges; echo ""}