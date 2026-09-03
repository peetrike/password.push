#Requires -Modules Pester

BeforeDiscovery {
    [System.Diagnostics.CodeAnalysis.SuppressMessage(
        'PSUseDeclaredVarsMoreThanAssignments',
        '',
        Scope = '*',
        Target = 'SuppressImportModule'
    )]
    $SuppressImportModule = $false
    . $PSScriptRoot\Shared.ps1

    $ModuleInfo = Get-Module $ModuleName

    $ExportedAlias = foreach ($alias in $ModuleInfo.ExportedAliases.Values) {
        @{
            Name = $alias.Name
        }
    }
    if (-not $ExportedAlias) {
        $scriptName = Split-Path -Path $PSScriptRoot -Leaf
        Write-Warning -Message ("{0}: Module {1} ({2}) does not export any aliases." -f $scriptName, $ModuleInfo.Name, $ModuleInfo.Version)
    }
}

Describe "Exported aliases for module $ModuleName" -Tags @('MetaTest') {
    Context 'Alias "<name>"' -Foreach $ExportedAlias -AllowNullOrEmptyForEach {
        BeforeEach {
            $aliasToTest = Get-Alias $name -ErrorAction SilentlyContinue
        }
        It 'Exists' {
            $aliasToTest | Should-HaveType ([Management.Automation.AliasInfo])
        }

        It 'Has exported name' {
            $aliasToTest.Name | Should-Be $name
        }

        It 'Points to existing command' {
            $aliasToTest.ResolvedCommand | Should-NotBeNull
        }
    }
}
