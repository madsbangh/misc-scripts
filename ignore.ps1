param
(
    [Parameter(Position=0, Mandatory=$True)]
    [String]
    $Language
)
Invoke-WebRequest "https://raw.githubusercontent.com/github/gitignore/main/$Language.gitignore" -OutFile ./.gitignore
