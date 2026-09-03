function Publish-Password {
    [Alias('Send-Password')]
    [CmdletBinding(
        DefaultParameterSetName = 'Password'
    )]
    param (
            [Parameter(
                Mandatory,
                ParameterSetName = 'Password'
            )]
            [Alias('Password')]
            [string]
        $Payload,
            [Parameter(
                Mandatory,
                ParameterSetName = 'Secure'
            )]
            [securestring]
        $SecurePassword
    )

    if ($PSCmdlet.ParameterSetName -eq 'Secure') {
        $Payload = Get-UnsecureString -SecureString $SecurePassword
    }
    $Body = @{
        push = @{
            payload = $Payload
        }
    }

    # Call the function to publish the password
    Invoke-ApiRequest -Method 'POST' -Action 'pushes' -Body $Body
}
