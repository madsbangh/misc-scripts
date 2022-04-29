param
(
    [Parameter(Position=0, Mandatory=$True)]
    [ValidateSet("Unity", IgnoreCase=$False)]
    [String]
    $Template
)
Invoke-WebRequest "https://raw.githubusercontent.com/alexkaratarakis/gitattributes/master/$Template.gitattributes" -OutFile ./.gitattributes
