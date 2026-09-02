#Requires -Version 5.0
#Requires -Modules psake, PWBuild

[CmdletBinding(
    DefaultParameterSetName = 'Task'
)]
param (
        [Parameter(
            ParameterSetName = 'Task',
            Position = 0
        )]
        [ArgumentCompleter({
            param ($Command, $Parameter, $WordToComplete, $CommandAst, $FakeBoundParams)

            $psakeFile = "$PSScriptRoot/psakeFile.ps1"
            Get-PSakeScriptTasks -buildFile $psakeFile |
                Where-Object { $_.Description -and $_.Name -match $WordToComplete } |
                ForEach-Object {
                    [Management.Automation.CompletionResult]::new(
                        $_.Name,            # completionText
                        $_.Name,            # listItemText
                        'ParameterValue',   # resultType
                        $_.Description      # toolTip
                    )
                }
        })]
        [string[]]
        # Build task(s) to execute
    $Task = 'default',

        [Parameter(
            ParameterSetName = 'Task'
        )]
        [switch]
        # Bootstrap dependencies
    $Bootstrap,

        [Parameter(
            Mandatory,
            ParameterSetName = 'Help'
        )]
        [switch]
        # List available build tasks
    $Help
)

$ErrorActionPreference = 'Stop'

# Bootstrap dependencies
if ($Bootstrap) {
    $null = Get-PackageProvider -Name Nuget -ForceBootstrap
    if (-not (Get-Module -Name PSDepend -ListAvailable)) {
        Install-Module -Name PSDepend -Repository PSGallery -Force
    }
    Import-Module -Name PSDepend -Verbose:$false
    Invoke-PSDepend -Path "$PSScriptRoot/requirements.psd1" -Install -Import -Force -WarningAction SilentlyContinue
}

# Execute psake task(s)
$psakeFile = Join-Path -Path $PSScriptRoot -ChildPath 'psakeFile.ps1'
if ($Help) {
    Get-PSakeScriptTasks -buildFile $psakeFile |
        Where-Object Description |
        Select-Object -Property Name, Description, Alias
} else {
    Invoke-psake -buildFile $psakeFile -taskList $Task -nologo
    exit ( [int]( -not $psake.build_success ) )
}
