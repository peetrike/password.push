function Get-PasswordUrl {
    # .EXTERNALHELP password.push-help.xml
    [OutputType([uri])]
    [CmdletBinding()]
    param (
            [Parameter(Mandatory)]
            [string]
        $Token
    )

    $result = Invoke-ApiRequest -Action "pushes" -Token "$Token/preview"
    [uri] $result.url
}
