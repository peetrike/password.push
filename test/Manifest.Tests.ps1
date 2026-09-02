#Requires -Modules Pester

BeforeDiscovery {
    [System.Diagnostics.CodeAnalysis.SuppressMessage(
        'PSUseDeclaredVarsMoreThanAssignments',
        '',
        Scope = '*',
        Target = 'SuppressImportModule'
    )]
    $SuppressImportModule = $true
    . $PSScriptRoot\Shared.ps1

    $manifestData = Import-PowerShellDataFile -Path $manifestPath
}

Describe "Module $moduleName" -Tags @('MetaTest') {
    BeforeAll {
        [System.Diagnostics.CodeAnalysis.SuppressMessage(
            'PSUseDeclaredVarsMoreThanAssignments',
            '',
            Scope = '*',
            Target = 'SuppressImportModule'
        )]
            $SuppressImportModule = $true
        . $PSScriptRoot\Shared.ps1

        $manifest = Test-ModuleManifest -Path $manifestPath -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
        $manifestContent = Import-PowerShellDataFile -Path $manifestPath
    }
    Context 'Manifest file' {
        It 'Is a valid manifest' {
            {
                $null = Test-ModuleManifest -Path $manifestPath -Verbose:$false -ErrorAction Stop -WarningAction SilentlyContinue
            } | Should -Not -Throw
        }

        Context 'Required by Publish-Module' {
            It 'has a valid author' {
                $manifest.Author | Should -Not -BeNullOrEmpty
            }
            It 'has a valid description' {
                $manifest.Description | Should -Not -BeNullOrEmpty
            }
        }
        It 'Has a valid name in the manifest' {
            $manifest.Name | Should -Be $moduleName
        }

        It 'Has a valid root module' {
            $manifest.RootModule | Should -Be ('{0}.psm1' -f $moduleName)
        }

        It 'Has valid root module for PowerShell 2.0' -Skip:(([version]$manifestData.PowerShellVersion).Major -ne 2) {
            $manifestContent.ModuleToProcess | Should -Not -BeNullOrEmpty
        }

        It 'Has a valid guid' {
            {
                [guid]::Parse($manifest.Guid)
            } | Should -Not -Throw
        }

        It 'Has a valid copyright' {
            $manifest.CopyRight | Should -Not -BeNullOrEmpty
        }

        # Only for DSC modules
        <# It 'exports DSC resources' {
            $dscResources = $Manifest.ExportedDscResources
            @($dscResources).Count | Should -Not -Be 0
        } #>

        Context 'Manifest version' -Tag Version {
            It 'Has a valid version in the manifest' {
                $manifest.Version <# -as [Version] #> | Should -Not -BeNullOrEmpty
            }
            It 'Version follows SemVer guidelines' {
                $manifest.Version.Revision |
                    Should -Be -1 -Because 'module should follow SemVer guidelines'
            }
            It 'Prerelease tag follows PSGallery requirements' -Skip:(
                $manifestData.PrivateData.PSData.Keys -notcontains 'Prerelease'
            ) {
                $manifestContent.PrivateData.PSData.Prerelease -match '-?[0-9A-Za-z]+' |
                    Should -Be $true -Because 'PSGallery supports only SemVer v1.0 prerelease strings'
            }
        }

        Context 'URLs included' {
            It 'LicenseUri is proper URI' -Skip:($manifestData.PrivateData.PSData.Keys -notcontains 'LicenseUri') {
                $uri = $manifest.LicenseUri
                $uri | Should -Not -BeNullOrEmpty
            }
            It 'ProjectUri is proper URI' -Skip:($manifestData.PrivateData.PSData.Keys -notcontains 'ProjectUri') {
                $uri = $manifest.ProjectUri
                $uri | Should -Not -BeNullOrEmpty
            }
        }
        Context 'Tags' -Tag Tags {
            BeforeDiscovery {
                $taglist = $manifestData.PrivateData.PSData.Tags | ForEach-Object {
                    @{ tag = $_ }
                }
            }

            It '"<tag>" should have no spaces in name' -TestCases $tagList {
                param ($tag)
                $tag -match ' ' | Should -Be $false
            }

            It 'Have at least one edition tag' {
                ($manifest.Tags | Select-Object -Unique) -match '^PSEdition_' |
                    Should -Not -BeNullOrEmpty
            }
            It 'Have at least one OS compatibility tag' {
                ($manifest.Tags | Select-Object -Unique) -match '^(Windows|Linux|MacOS)$' |
                    Should -Not -BeNullOrEmpty -Because 'Every module should be compatible with at least one OS'
            }
        }

        Context 'ChangeLog compared to manifest' -Tag ChangeLog {
            BeforeAll {
                $projectRoot = Split-Path -Path $PSScriptRoot -Parent
                $changelogPath = Join-Path -Path $projectRoot -ChildPath 'CHANGELOG.md'

                $changelogVersion = $null
                foreach ($line in (Get-Content $changelogPath)) {
                    if ($line -match "^## \[(?<Version>(\d+\.){1,2}\d+)(-\w+)?\] \d{4}(-\d{2}){2}") {
                        $changelogVersion = $matches.Version
                        break
                    }
                }
            }
            It 'Has a valid version in the changelog' {
                $changelogVersion               | Should -Not -BeNullOrEmpty
                $changelogVersion -as [Version] | Should -Not -BeNullOrEmpty
            }
            It 'Changelog and manifest versions are the same' {
                $changelogVersion -as [Version] | Should -Be $manifest.Version
            }

            <# if (Get-Command git.exe -ErrorAction SilentlyContinue) {
                $script:tagVersion = $null
                It 'is tagged with a valid version' -Skip {
                    $thisCommit = git.exe log --decorate --oneline HEAD~1..HEAD

                    if ($thisCommit -match 'tag:\s*v?(\d+(?:\.\d+)*)') {
                        $tagVersion = $matches[1]
                    }

                    $tagVersion               | Should -Not -BeNullOrEmpty
                    $tagVersion -as [Version] | Should -Not -BeNullOrEmpty
                }

                It 'manifest and tagged version are the same' -Skip {
                    $script:manifest.Version -as [Version] | Should -Be ( $script:tagVersion -as [Version] )
                }
            } #>
        }
    }

    Context 'Individual file validation' {
        BeforeDiscovery {
            function Get-NameList {
                param (
                        [Parameter(ValueFromPipeline)]
                        [string]
                    $Name
                )
                process {
                    if ($Name) {
                        @{
                            name = $Name
                        }
                    }
                }
            }
            $formatList = $manifestData.FormatsToProcess | Get-NameList
            $typeList = $manifestData.TypesToProcess | Get-NameList
            $AssemblyFile = $manifestData.RequiredAssemblies |
                Where-Object { $_ -like "*.dll" } |
                Get-NameList
            $AssemblyList = $manifestData.RequiredAssemblies |
                Where-Object { $_ -notlike "*.dll" } |
                Get-NameList
        }
        BeforeAll {
            $moduleRoot = Split-Path $manifestPath -Parent
        }
        It 'The root module file exists' {
            $RootModulePath = Join-Path -Path $moduleRoot -ChildPath $manifest.RootModule
            Test-Path -Path $RootModulePath -PathType Leaf | Should -Be $true
        }

        It 'The format file "<name>" exists' -TestCases $formatList {
            $formatPath = Join-Path -Path $moduleRoot -ChildPath $name
            Test-Path $formatPath -PathType Leaf | Should -BeTrue
        }

        It 'The type file "<name>" exists' -TestCases $typeList {
            $typePath = Join-Path -Path $moduleRoot -ChildPath $name
            Test-Path $typePath -PathType Leaf | Should -BeTrue
        }

        It 'The assembly file "<name>" exists' -TestCases $AssemblyFile {
            $assemblyPath = Join-Path -Path $moduleRoot -ChildPath $name
            Test-Path $assemblyPath -PathType Leaf | Should -BeTrue
        }
        It 'The assembly "<name>" loads from the GAC' -TestCases $assemblyList {
            { Add-Type -AssemblyName $name } | Should -Not -Throw
        }
    }
}
