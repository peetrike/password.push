function Unpublish-Password {
    [Alias('Remove-Password')]
    param (
            [Parameter(Mandatory)]
            [string]
        $Token
    )

    Invoke-ApiRequest -Method Delete -Action "pushes" -Token $Token
}
