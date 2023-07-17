function Get-CheatSheetRegEx {
<#
.SYNOPSIS
Get RegEx Cheat Sheet

.DESCRIPTION
Get RegEx Cheat Sheet will return helpful RegEx related information

.EXAMPLE
Get-CheatSheetRegEx
#>
    [CmdletBinding()]
    Param()

    $cheat = @'
    ^      Start of string
    $      End of string
    *      Zero or more of prior
    +      One or more of prior
    ?      One or zero or prior
    .      Just one right here

    {2}    Exactly two of prior
    {4,}   Four or more
    {1,7}  One to seven

    [xy]   Match alternatives
    [^xy]  Negative match
    [a-z]  Range
    [^a-z] Negative range

    (x|y)  x or y in submatch

    \      Literal escape
    \t     Tab
    \n     New line
    \r     Carriage return
    \f     Form feed
    \w     Word = [A-Za-z0-9_]
    \W     Non-word = [^A-Za-z0-9_]
    \s     White space = [ \f\n\r\t\v]
    \S     Non-white space = [^ \f\n\r\t\v]
    \d     Digit = [0-9]
    \D     Non-digit = [^0-9]
'@
    # return string
    "`n $cheat `n"
}
New-Alias cheat-regex Get-CheatSheetRegEx
