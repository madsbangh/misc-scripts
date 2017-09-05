param
(
    [Parameter(Position=0, Mandatory=$True)]
    [ValidateSet("Unity", IgnoreCase=$False)]
    [String]
    $Template
)
Invoke-WebRequest "https://raw.githubusercontent.com/github/gitignore/master/$Template.gitignore" -OutFile ./.gitignore
