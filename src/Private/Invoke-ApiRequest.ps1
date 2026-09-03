function Invoke-ApiRequest {
    [CmdletBinding()]
    param (
            [string]
        $Server = $Script:ApiServer,
        $Method = 'GET',
            [string]
        $Action,
            [Alias('ID')]
            [string]
        $Token,
            [hashtable]
        $Body
    )

    if (-not $Server) {
        $config = Import-Configuration
        $Server = $config.ApiServer
        if (-not $Server) {
            throw "API server is not configured. Please run 'Connect-PushServer' first."
        }
        $Script:ApiServer = $Server
    }

    Write-Verbose -Message "Using server: $Server"

    $BaseUrl = 'https://{0}/api/v2/' -f $Server

    $ApiUrl = $BaseUrl, $Action, $Token -join '/'

    $RequestSplat = @{
        Uri         = $ApiUrl
        Method      = $Method
        ContentType = 'application/json'
    }
    if ($Body) {
        $RequestSplat.Body = $Body | ConvertTo-Json
    }
    Invoke-RestMethod @RequestSplat
}
