function Read-Password {
    # .EXTERNALHELP password.push-help.xml
    [Alias('Receive-Password')]
    [CmdletBinding()]
    param (
            [Parameter(Mandatory)]
            [string]
        $Token
    )

    Invoke-ApiRequest -Action "pushes" -Token $Token
}
