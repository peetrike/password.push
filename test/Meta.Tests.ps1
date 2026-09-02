#Requires -Modules Pester

Describe 'Text files formatting' -Tags @('MetaTest') {
    BeforeAll {
        [System.Diagnostics.CodeAnalysis.SuppressMessage(
            'PSUseDeclaredVarsMoreThanAssignments',
            '',
            Scope = '*',
            Target = 'SuppressImportModule'
        )]
        $SuppressImportModule = $true
        . $PSScriptRoot\Shared.ps1

        # Make sure MetaFixers.psm1 is loaded - it contains Get-TextFilesList
        Import-Module -Name (Join-Path -Path $PSScriptRoot -ChildPath 'MetaFixers.psm1') -Verbose:$false -Force

        $allTextFiles = Get-TextFilesList $OutPath |
            Where-Object Directory -notlike '*Templates'
    }

    Context 'Files encoding' {
        It "Doesn't use Unicode encoding" {
            $unicodeFilesCount = 0
            $allTextFiles | Foreach-Object {
                if (Test-FileUnicode $_) {
                    Write-Warning "File $($_.FullName) contains 0x00 bytes. It's probably uses Unicode and need to be converted to UTF-8. Use Fixer 'Get-UnicodeFilesList `$pwd | ConvertTo-UTF8'."
                    $unicodeFilesCount++
                }
            }
            $unicodeFilesCount | Should -Be 0
        }
    }

    Context 'Indentations' {
        It 'Uses spaces for indentation, not tabs' {
            $totalTabsCount = 0
            $allTextFiles | Foreach-Object {
                $fileName = $_.FullName
                (Get-Content $_.FullName -Raw) | Select-String "`t" | Foreach-Object {
                    Write-Warning "There are tab in $fileName. Use Fixer 'Get-TextFilesList `$pwd | ConvertTo-SpaceIndentation'."
                    $totalTabsCount++
                }
            }
            $totalTabsCount | Should -Be 0
        }
    }

    AfterAll {
        Remove-Module -Name MetaFixers -Verbose:$false
    }
}
