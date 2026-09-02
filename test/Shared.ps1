# Dot source this script in any Pester test script that requires the module to be imported.

$projectRoot = Split-Path -Path $PSScriptRoot -Parent
$OutPath = Join-Path -Path $projectRoot -ChildPath 'Release'
$moduleName = Split-Path -Path $projectRoot -Leaf
    [Diagnostics.CodeAnalysis.SuppressMessage(
        'PSUseDeclaredVarsMoreThanAssignments',
        '',
        Scope = '*',
        Target = 'SuppressImportModule'
    )]
$manifestPath = ('{0}\{1}\{1}.psd1' -f $OutPath, $moduleName)

if (-not $SuppressImportModule) {
    # Remove all versions of the module from the session. Pester can't handle multiple versions.
    Get-Module $moduleName | Remove-Module -Force

    # -Scope Global is needed when running tests from inside of psake, otherwise
    # the module's functions cannot be found in the module namespace
    Import-Module $ManifestPath -Scope Global -Force -Verbose:$false -ErrorAction Stop
}
