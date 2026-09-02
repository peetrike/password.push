---
name: 'PowerShell Standards'
description: 'Coding conventions for PowerShell files'
applyTo: '**/*.ps1,**/*.psm1'
---

# PowerShell coding standards

This guide provides PowerShell-specific instructions to help GitHub Copilot generate idiomatic,
safe, and maintainable scripts. It aligns with Microsoft’s PowerShell cmdlet development guidelines.

## Naming Conventions

- **Function names:**
  - Use approved PowerShell verbs (Get-Verb)
  - Use singular nouns
  - PascalCase for both verb and noun
  - Avoid special characters and spaces

- **Parameter Names:**
  - Use PascalCase
  - Choose clear, descriptive names
  - Use singular form unless always multiple
  - Follow PowerShell standard names

- **Variable Names:**
  - Use PascalCase for public variables
  - Use camelCase for private variables
  - Avoid abbreviations
  - Use meaningful names

- **Alias Avoidance:**
  - Use full cmdlet names
  - Avoid using aliases in scripts (e.g., use Get-ChildItem instead of gci)
  - Document any custom aliases
  - Use full parameter names

### Example

```powershell
function Get-UserProfile {
    [CmdletBinding()]
    param(
            [Parameter(Mandatory)]
            [string]
        $Username,

            [ValidateSet('Basic', 'Detailed')]
            [string]
        $ProfileType = 'Basic'
    )

    process {
        # Logic here
    }
}
```

## Parameter Design

- **Standard Parameters:**
  - Use common parameter names (`Path`, `Name`, `Force`)
  - Follow built-in cmdlet conventions
  - Use aliases for specialized terms
  - Document parameter purpose

- **Parameter Names:**
  - Use singular form unless always multiple
  - Choose clear, descriptive names
  - Follow PowerShell conventions
  - Use PascalCase formatting

- **Type Selection:**
  - Use common .NET types
  - Implement proper validation
  - Consider ValidateSet for limited options
  - Enable tab completion where possible

- **Switch Parameters:**
  - Use [switch] for boolean flags
  - Avoid $true/$false parameters
  - Default to $false when omitted
  - Use clear action names

### Example

```powershell
function Set-ResourceConfiguration {
    [CmdletBinding()]
    param(
            [Parameter(Mandatory)]
            [string]
        $Name,

            [ValidateSet('Dev', 'Test', 'Prod')]
            [string]
        $Environment = 'Dev',

            [switch]
        $Force,

            [ValidateNotNullOrEmpty()]
            [string[]]
        $Tags
    )

    process {
        # Logic here
    }
}
```

## Pipeline and Output

- **Pipeline Input:**
  - Use `ValueFromPipeline` for direct object input
  - Use `ValueFromPipelineByPropertyName` for property mapping
  - Implement Begin/Process/End blocks for pipeline handling
  - Document pipeline input requirements

- **Output Objects:**
  - Return rich objects, not formatted text
  - Use PSCustomObject for structured data
  - Avoid Write-Host for data output
  - Enable downstream cmdlet processing
  - Add OutputType attribute for public functions

- **Pipeline Streaming:**
  - Output one object at a time
  - Use process block for streaming
  - Avoid collecting large arrays
  - Enable immediate processing

- **PassThru Pattern:**
  - Default to no output for action cmdlets
  - Implement `-PassThru` switch for object return
  - Return modified/created object with `-PassThru`
  - Use verbose/warning for status updates

### Example

```powershell
function Update-ResourceStatus {
    [CmdletBinding()]
    param(
            [Parameter(
                Mandatory,
                ValueFromPipeline,
                ValueFromPipelineByPropertyName
            )]
            [string]
        $Name,

            [Parameter(Mandatory)]
            [ValidateSet(
                'Active',
                'Inactive',
                'Maintenance'
            )]
            [string]
        $Status,

            [switch]
        $PassThru
    )

    begin {
        Write-Verbose 'Starting resource status update process'
        $timestamp = Get-Date
    }

    process {
        # Process each resource individually
        Write-Verbose "Processing resource: $Name"

        $resource = [PSCustomObject]@{
            Name        = $Name
            Status      = $Status
            LastUpdated = $timestamp
            UpdatedBy   = $env:USERNAME
        }

        # Only output if PassThru is specified
        if ($PassThru) {
            $resource
        }
    }

    end {
        Write-Verbose 'Resource status update process completed'
    }
}
```

## Error Handling and Safety

- **ShouldProcess Implementation:**
  - Use `[CmdletBinding(SupportsShouldProcess)]` for state changing functions and scripts
  - Set appropriate `ConfirmImpact` level
  - Call `$PSCmdlet.ShouldProcess()` for system changes
  - Use `ShouldContinue()` for additional confirmations

- **Message Streams:**
  - `Write-Verbose` for operational details with `-Verbose`
  - `Write-Debug` for developer messages with `-Debug`
  - `Write-Information` for informational messages with `-InformationAction`
  - `Write-Progress` for long-running operations
  - `Write-Warning` for warning conditions
  - `Write-Error` for non-terminating errors
  - `throw` for terminating errors
  - Avoid `Write-Host` except for user interface text

- **Error Handling Pattern:**
  - Use try/catch blocks for error management
  - Set appropriate ErrorAction preferences
  - Return meaningful error messages
  - Use ErrorVariable when needed
  - Include proper terminating vs non-terminating error handling
  - In advanced functions with `[CmdletBinding()]`, prefer `$PSCmdlet.WriteError()` over `Write-Error`
  - In advanced functions with `[CmdletBinding()]`, prefer `$PSCmdlet.ThrowTerminatingError()` over `throw`
  - Construct proper ErrorRecord objects with category, target, and exception details

- **Non-Interactive Design:**
  - Accept input via parameters
  - Avoid `Read-Host` in scripts
  - Support automation scenarios
  - Document all required inputs

### Example

```powershell
function Remove-UserAccount {
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = 'High'
    )]
    param (
            [Parameter(
                Mandatory,
                ValueFromPipeline
            )]
            [ValidateNotNullOrEmpty()]
            [string]
        $Username,

            [switch]
        $Force
    )

    begin {
        Write-Verbose 'Starting user account removal process'
        $ErrorActionPreference = 'Stop'
    }

    process {
        try {
            # Validation
            if (-not (Test-UserExists -Username $Username)) {
                $errorRecord = [System.Management.Automation.ErrorRecord]::new(
                    [System.Exception]::new("User account '$Username' not found"),
                    'UserNotFound',
                    [System.Management.Automation.ErrorCategory]::ObjectNotFound,
                    $Username
                )
                $PSCmdlet.WriteError($errorRecord)
                return
            }

            # Confirmation
            $shouldProcessMessage = "Remove user account '$Username'"
            if ($Force -or $PSCmdlet.ShouldProcess($Username, $shouldProcessMessage)) {
                Write-Verbose "Removing user account: $Username"

                    # Main operation
                Remove-ADUser -Identity $Username -ErrorAction Stop
                Write-Warning "User account '$Username' has been removed"
            }
        } catch [Microsoft.ActiveDirectory.Management.ADException] {
            $errorRecord = [System.Management.Automation.ErrorRecord]::new(
                $_.Exception,
                'ActiveDirectoryError',
                [System.Management.Automation.ErrorCategory]::NotSpecified,
                $Username
            )
            $PSCmdlet.ThrowTerminatingError($errorRecord)
        } catch {
            $errorRecord = [System.Management.Automation.ErrorRecord]::new(
                $_.Exception,
                'UnexpectedError',
                [System.Management.Automation.ErrorCategory]::NotSpecified,
                $Username
            )
            $PSCmdlet.ThrowTerminatingError($errorRecord)
        }
    }

    end {
        Write-Verbose 'User account removal process completed'
    }
}
```

## Documentation and Style

- **Comment-Based Help:** Include comment-based help for any public-facing function or cmdlet.
  Inside the function, add a `<# ... #>` help comment with at least:
  - `.SYNOPSIS` Brief description
  - `.DESCRIPTION` Detailed explanation
  - `.EXAMPLE` sections with practical usage
  - `.OUTPUTS` Type of output returned
  - `.NOTES` Additional information
  - add parameter descriptions using comments near the parameter declaration
  - use `.PARAMETER` for common parameters, if needed

- **Consistent Formatting:**
  - Follow consistent PowerShell style
  - Use proper indentation (4 spaces recommended)
  - Opening braces on same line as statement
  - Closing braces on new line
  - Use line breaks after pipeline operators
  - PascalCase for function and parameter names
  - Avoid unnecessary whitespace

## Full Example: End-to-End Cmdlet Pattern

```powershell
function New-Resource {
    <#
        .SYNOPSIS
            Creates a new resource with specified parameters.
        .DESCRIPTION
            This function creates a new resource based on the provided name and environment.
            It supports confirmation prompts and error handling.
        .EXAMPLE
            New-Resource -Name "MyResource" -Environment "Production"

            Creates a new resource named "MyResource" in the Production environment.
        .INPUTS
            System.String
            The name of the resource to create.
        .OUTPUTS
            PSCustomObject
            The created resource object.
        .NOTES
            Additional information about the function.
    #>
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = 'Medium'
    )]
    param (
            [Parameter(
                Mandatory,
                ValueFromPipeline,
                ValueFromPipelineByPropertyName
            )]
            [ValidateNotNullOrEmpty()]
            [string]
            # Specify the name of the resource to create
        $Name,

            [Parameter()]
            [ValidateSet('Development', 'Production')]
            [string]
            # Environment for the resource, default is 'Development'
        $Environment = 'Development'
    )

    begin {
        Write-Verbose 'Starting resource creation process'
    }

    process {
        try {
            if ($PSCmdlet.ShouldProcess($Name, 'Create new resource')) {
                    # Resource creation logic here
                [PSCustomObject] @{
                        Name        = $Name
                        Environment = $Environment
                        Created     = Get-Date
                }
            }
        } catch {
            $errorRecord = [System.Management.Automation.ErrorRecord]::new(
                $_.Exception,
                'ResourceCreationFailed',
                [System.Management.Automation.ErrorCategory]::NotSpecified,
                $Name
            )
            $PSCmdlet.ThrowTerminatingError($errorRecord)
        }
    }

    end {
        Write-Verbose 'Completed resource creation process'
    }
}
```
