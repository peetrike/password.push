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
}

# Taken with love from @juneb_get_help (https://github.com/juneb/PesterTDD/blob/master/Module.Help.Tests.ps1)

Describe "Help for module $moduleName" {
    ## When testing help, remember that help is cached at the beginning of each session.
    ## To test, restart session.

    BeforeDiscovery {
            # Workflow not supported on PS7
        $CommandList = foreach ($command in Get-Command -Module $moduleName -CommandType Cmdlet, Function) {
            @{
                CommandName = $command.Name
            }
        }
    }

    Describe '<CommandName>' -ForEach $CommandList -Tags @('MetaTest') {
        BeforeDiscovery {
            $help = Get-Help -Name $CommandName -ErrorAction SilentlyContinue
        }

        # The module-qualified command fails on Microsoft.PowerShell.Archive cmdlets

        It 'should not be auto-generated' -TestCases @{ Synopsis = $help.Synopsis } {
            # If help is not found, synopsis in auto-generated help is the syntax diagram
            $Synopsis.TrimStart() |
                Should -Not -BeLike "$CommandName *" -Because 'command should have synopsis'
        }

        It 'has description' -TestCases @{ help = $help } {
            $help.Description |
                Should -Not -BeNullOrEmpty -Because 'Command should have a description'
        }

        Context 'Examples' {
            BeforeDiscovery {
                $Examples = foreach ($example in $help.Examples.example) {
                    @{
                        code    = $example.code
                        remarks = $example.remarks
                        title   = $example.title
                    }
                }
            }
            It "$CommandName has at least one example" -TestCases @{ help = $help } {
                $help.Examples.example.code |
                    Should -Not -BeNullOrEmpty -Because 'Every command should have an example'
            }

            Context '<title>' -ForEach $Examples {
                It 'has code' {
                    $code | Should -Not -BeNullOrEmpty
                }
                It 'has description' {
                    $remarks<# .text #> |
                        Should -Not -BeNullOrEmpty -Because 'every example should be described'
                }
            }
        }

        Context 'Parameters' {
            BeforeDiscovery {
                $common = @(
                    [Management.Automation.PSCmdlet]::CommonParameters
                    [Management.Automation.PSCmdlet]::OptionalCommonParameters
                )

                # Without the filter, WhatIf and Confirm parameters are still flagged in "finds help parameter in code" test
                $helpParameters = $help.parameters.parameter |
                    Where-Object Name -NotIn $common |
                    Sort-Object -Property Name -Unique
                $parameters = (Get-Command $commandName).ParameterSets.Parameters |
                    Where-Object Name -NotIn $common |
                    Sort-Object -Property Name -Unique

                $ParameterList = foreach ($parameter in $parameters) {
                    @{
                        parameterName = $parameter.Name
                        parameter     = $parameter
                        parameterHelp = $helpParameters | Where-Object Name -EQ $parameter.Name
                    }
                }
            }

            It 'all parameters have help topic' -TestCases @{
                helpParameters = $helpParameters
                parameters     = $parameters
            } {
                $Because = 'The number of parameters in the help should match the number in the command'
                @($helpParameters).Count |
                    Should -Be @($parameters).Count -Because $Because
            }

            Context 'Parameter <parameterName>' -ForEach $ParameterList {
                It 'has help description' {
                    $parameterHelp.Description.Text |
                        Should -Not -BeNullOrEmpty -Because 'Every parameter should have a description'
                }

                # Required value in Help should match IsMandatory property of parameter
                It 'has correct Mandatory value' {
                    $codeMandatory = $parameter.IsMandatory.toString()
                    $parameterHelp.Required | Should -Be $codeMandatory
                }

                # Parameter type in Help should match code
                It 'has correct parameter type' {
                    $codeType = $parameter.ParameterType.Name
                    $helpType = if ($parameterHelp.parameterValue) { $parameterHelp.parameterValue.Trim() }

                        # To avoid calling Trim method on a null object.
                    $helpType | Should -Be $codeType
                }
            }
        }

        Context 'Help Links' {
            BeforeDiscovery {
                $links = $help.relatedLinks.navigationLink |
                    Where-Object uri |
                    ForEach-Object {
                        @{
                            linkText = $_.linkText
                            uri      = $_.uri
                        }
                    }
            }
            It 'Link is available online - <linkText>' -TestCases $links {
                $Result = Invoke-WebRequest -Uri $uri -UseBasicParsing
                $Result.StatusCode |
                    Should -Be '200' -Because 'URL should respond'
            }
        }
    }
}
