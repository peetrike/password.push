#Requires -Modules @{ModuleName = 'Pester'; ModuleVersion = '6.0.0'}

BeforeDiscovery {
    [System.Diagnostics.CodeAnalysis.SuppressMessage(
        'PSUseDeclaredVarsMoreThanAssignments',
        '',
        Scope = '*',
        Target = 'SuppressImportModule'
    )]
    $SuppressImportModule = $true
    . $PSScriptRoot\Shared.ps1

    $ManifestData = Import-PowerShellDataFile -Path $ManifestPath
}

Describe "Module $ModuleName" -Tags @('MetaTest') {
    BeforeAll {
        [System.Diagnostics.CodeAnalysis.SuppressMessage(
            'PSUseDeclaredVarsMoreThanAssignments',
            '',
            Scope = '*',
            Target = 'SuppressImportModule'
        )]
            $SuppressImportModule = $true
        . $PSScriptRoot\Shared.ps1

        $testSplat = @{
            Path          = $ManifestPath
            WarningAction = 'SilentlyContinue'
        }
        $manifest = Test-ModuleManifest @testSplat -ErrorVariable ManifestError
        $manifestContent = Import-PowerShellDataFile -Path $ManifestPath
    }
    Context 'Manifest file' {
        It 'Is a valid manifest' {
            $ManifestError.Count | Should-Be 0
        }

        It 'Has a guid specified' {
            # Test-ModuleManifest tests for a valid GUID, but not for omitted GUID.
            $manifestContent.Guid | Should-NotBeNull -Because 'Omitting a GUID generates [guid]::Empty'
        }

        Context 'Required by Publish-Module' -Tag PSGallery {
            It 'Has a valid author' {
                $manifest.Author | Should-NotBeEmptyString
            }

            It 'Has a valid description' {
                $manifest.Description | Should-NotBeEmptyString
            }
        }

        It 'Has a valid manifest name' {
            $Because = 'The module manifest name should match the module folder name'
            $manifest.Name | Should-BeString $ModuleName -Because $Because
        }

        It 'Has a valid root module' -Skip:($ManifestData.PowerShellVersion -match '2(\.0)?') {
            $manifest.RootModule | Should-BeString "$ModuleName.psm1"
        }

        It 'Has valid root module for PowerShell 2.0' -Skip:($ManifestData.PowerShellVersion.Major -notmatch '2(\.0)?') {
            $manifestContent.ModuleToProcess | Should-NotBeEmptyString
        }

        It 'Has a valid copyright' -Tag PSGallery {
            $manifest.Copyright | Should-NotBeEmptyString -Because 'Every module should have a copyright statement'
        }

        It 'CompatiblePSEditions used with supported PowerShell version' -Skip:(-not $ManifestData.CompatiblePSEditions) {
            $Because = 'CompatiblePSEditions is only supported in PowerShell 5.1 and later'
            $manifest.PowerShellVersion | Should-BeGreaterThan ([version] '5.0') -Because $Because
            $manifest.CompatiblePSEditions | Should-Any { $_ -in @('Core', 'Desktop') }
        }

        Context 'Manifest version' -Tag Version {
            <# It 'Has a valid version in the manifest' {
                $manifestContent.ModuleVersion | Should-NotBeEmptyString
            } #>

            It 'Version follows SemVer guidelines' {
                $manifest.Version.Revision |
                    Should-Be -1 -Because 'SemVer does not support a revision number'
                $manifest.Version.Build |
                    Should-BeGreaterThanOrEqual 0 -Because 'SemVer requires a build/patch number'
            }

            It 'Prerelease tag follows PSGallery requirements' -Tag 'PSGallery' -Skip:(
                $ManifestData.PrivateData.PSData.Keys -notcontains 'Prerelease'
            ) {
                $Because = 'PSGallery supports only SemVer v1.0 prerelease strings'
                $manifest.PrivateData.PSData.Prerelease |
                    Should-MatchString '-?[0-9A-Za-z]+' -Because $Because
            }
        }

        Context 'ChangeLog compared to manifest' -Tag ChangeLog {
            BeforeAll {
                $projectRoot = Split-Path -Path $PSScriptRoot -Parent
                $changeLogPath = Join-Path -Path $projectRoot -ChildPath 'CHANGELOG.md'

                $changeLogVersion = switch -File $changeLogPath -Regex {
                    "^## \[(?<Version>(\d+\.){1,2}\d+)(-\w+)?\] \d{4}(-\d{2}){2}" {
                        $matches.Version
                        break
                    }
                }

                # $isGitFolder = Test-Path -Path (Join-Path -Path $projectRoot -ChildPath '.git')
            }

            It 'Has a valid version in the changelog' {
                $changeLogVersion | Should-NotBeEmptyString
                $changeLogVersion -as [Version] | Should -Not -BeNullOrEmpty
            }

            It 'Changelog and manifest versions are the same' {
                $changeLogVersion -as [Version] | Should -Be $manifest.Version
            }

            <# Context 'Git tag validation' -Tag 'Git' -Skip:(-not $isGitFolder) {
                BeforeAll {
                    $thisCommit = git.exe log --decorate --oneline HEAD~1..HEAD
                    if ($thisCommit -match 'tag:\s*v?(\d+(?:\.\d+)*)') {
                        $tagVersion = $matches[1]
                    }
                }

                It 'is tagged with a valid version' -Skip {
                    $tagVersion | Should-NotBeEmptyString
                    $tagVersion -as [version] | Should-HaveType ([version])
                }

                It 'manifest and tagged version are the same' -Skip {
                    $manifest.Version | Should-Be ( $tagVersion -as [Version] )
                }
            } #>
        }

        Context 'Exported members' {
            BeforeDiscovery {
                $Member = @(
                    @{
                        Name  = 'Aliases'
                        Value = $ManifestData.AliasesToExport
                    }
                    @{
                        Name  = 'Cmdlets'
                        Value = $ManifestData.CmdletsToExport
                    }
                    @{
                        Name  = 'Functions'
                        Value = $ManifestData.FunctionsToExport
                    }
                    @{
                        Name  = 'Variables'
                        Value = $ManifestData.VariablesToExport
                    }
                )
            }

            It 'List of <name> to export is valid' -ForEach $Member {
                $because = 'Using wildcards in exported members is a performance issue'
                $Value -match '\*' | Should-BeFalsy -Because $because
                Should-NotBeNull -Actual $Value -Because 'Omitting exported members is a performance issue'
            }

            It 'Exports DSC resources' -Skip:($ManifestData.Keys -notcontains 'DscResourcesToExport') {
                $manifest.ExportedDscResources.Count | Should-BeGreaterThan 0
            }
        }

        Context 'URLs included' -Tag PSGallery {
            It 'LicenseUri is proper URI' {
                $Because = 'Every module should have a license reference'
                $manifest.LicenseUri.AbsoluteUri | Should-NotBeEmptyString -Because $Because
            }
            It 'ProjectUri is proper URI' -Skip:($ManifestData.PrivateData.PSData.Keys -notcontains 'ProjectUri') {
                $manifest.ProjectUri.AbsoluteUri | Should-NotBeEmptyString
            }
        }

        Context 'Tags' -Tag Tags, PSGallery {
            BeforeDiscovery {
                $taglist = $manifestData.PrivateData.PSData.Tags | ForEach-Object {
                    @{ tag = $_ }
                }
            }

            It '"<tag>" has no spaces in name' -TestCases $tagList -AllowNullOrEmptyForEach {
                $tag -match '\s' | Should-BeFalse -Because 'Tags should not contain whitespaces'
            }

            It 'Has at least one edition tag' {
                $Because = 'PSEdition tags are used to filter modules by edition in the PSGallery'
                $manifest.Tags | Select-Object -Unique | Should-Any { $_ -match '^PSEdition_' } -Because $Because
            }
            It 'Has at least one OS compatibility tag' {
                $Because = 'OS compatibility tags are used to filter modules by OS in the PSGallery'
                $manifest.Tags | Select-Object -Unique | Should-Any { $_ -match '^(Windows|Linux|MacOS)$' } -Because $Because
            }
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
            $FormatList = $manifestData.FormatsToProcess | Get-NameList
            $TypeList = $manifestData.TypesToProcess | Get-NameList
            $AssemblyFile = $manifestData.RequiredAssemblies |
                Where-Object { $_ -like "*.dll" } |
                Get-NameList
            $AssemblyList = $manifestData.RequiredAssemblies |
                Where-Object { $_ -notlike "*.dll" } |
                Get-NameList
            $ScriptList = $manifestData.ScriptsToProcess | Get-NameList
        }

        BeforeAll {
            $moduleRoot = Split-Path $manifestPath -Parent
        }

        It 'The root module file exists' -Skip:(-not ($ManifestData.RootModule -or $ManifestData.ModuleToProcess)) {
            $RootModuleName = $manifest.RootModule
            $RootModulePath = Join-Path -Path $moduleRoot -ChildPath $RootModuleName
            Test-Path -Path $RootModulePath -PathType Leaf | Should-BeTrue
        }

        It 'The format file "<name>" exists' -TestCases $formatList -AllowNullOrEmptyForEach {
            $formatPath = Join-Path -Path $moduleRoot -ChildPath $name
            Test-Path $formatPath -PathType Leaf | Should -BeTrue
        }

        It 'The type file "<name>" exists' -TestCases $typeList -AllowNullOrEmptyForEach {
            $typePath = Join-Path -Path $moduleRoot -ChildPath $name
            Test-Path $typePath -PathType Leaf | Should -BeTrue
        }

        It 'The script file "<name>" exists' -TestCases $ScriptList -AllowNullOrEmptyForEach {
            $scriptPath = Join-Path -Path $moduleRoot -ChildPath $name
            Test-Path $scriptPath -PathType Leaf | Should -BeTrue
        }

        It 'The assembly file "<name>" exists' -TestCases $AssemblyFile -AllowNullOrEmptyForEach {
            $assemblyPath = Join-Path -Path $moduleRoot -ChildPath $name
            Test-Path $assemblyPath -PathType Leaf | Should -BeTrue
        }

        It 'The assembly "<name>" loads from the GAC' -TestCases $assemblyList -AllowNullOrEmptyForEach {
            { Add-Type -AssemblyName $name } | Should -Not -Throw
        }
    }
}
