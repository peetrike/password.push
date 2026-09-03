function Unpublish-Password {
    # .EXTERNALHELP password.push-help.xml
    [Alias('Remove-Password')]
    [CmdletBinding()]
    param (
            [Parameter(Mandatory)]
            [string]
        $Token
    )

    Invoke-ApiRequest -Method Delete -Action "pushes" -Token $Token
}
