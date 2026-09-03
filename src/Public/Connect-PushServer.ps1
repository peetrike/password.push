function Connect-PushServer {
    [CmdletBinding()]
    param (
            [Parameter(Mandatory)]
            [string]
        $Server,
            [ValidateSet(
                'Enterprise',
                'Machine',
                'User'
            )]
        $Scope = 'User',
            [switch]
        $Save
    )


    $Script:ApiServer = $Server

    if ($Save) {
        $config = Import-Configuration
        $config.ApiServer = $Server
        $currentModule = Get-Module $MyInvocation.MyCommand.ModuleName
        $ExportProps = @{
            Scope       = $Scope
            CompanyName = $currentModule.CompanyName
            Name        = $currentModule.Name
        }

        Export-Configuration -InputObject $config @ExportProps
    }

    Invoke-ApiRequest -Action 'version'
}
