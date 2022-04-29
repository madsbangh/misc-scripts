param
(
    [Parameter(Position=0, Mandatory=$True)]
    [ValidateSet("Unity", IgnoreCase=$False)]
    [String]
    $Template
)
Invoke-WebRequest "https://github.com/alexkaratarakis/gitattributes/blob/master/$Template.gitattributes" -OutFile ./.gitattributes
