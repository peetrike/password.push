function Read-Password {
    [Alias('Receive-Password')]
    [CmdletBinding()]
    param (
            [Parameter(Mandatory)]
            [string]
        $Token
    )

    Invoke-ApiRequest -Action "pushes" -Token $Token
}
