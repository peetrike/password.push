@{
    RootModule        = 'password.push.psm1'
    ModuleVersion     = '0.0.1'

    GUID              = '4b8c4b27-3f17-422d-a2d6-e9819b618557'

    Author            = 'Peter Wawa'
    CompanyName       = 'Telia Eesti'
    Copyright         = 'Copyright (c) 2026 Telia Eesti'

    Description       = 'Password Pusher API wrapper module'

    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion = '3.0'

    <# CompatiblePSEditions = @(
        'Core'
        'Desktop'
    ) #>

    # Modules that must be imported into the global environment prior to importing this module
    RequiredModules = @(
        'Configuration'
    )

    # Assemblies that must be loaded prior to importing this module
    # RequiredAssemblies = @('bin\password.push.dll')

    # Script files (.ps1) that are run in the caller's environment prior to importing this module.
    # ScriptsToProcess = @()

    # Type files (.ps1xml) to be loaded when importing this module
    # Expensive for import time, no more than one should be used.
    # TypesToProcess = @('password.push.Types.ps1xml')

    # Format files (.ps1xml) to be loaded when importing this module.
    # Expensive for import time, no more than one should be used.
    # FormatsToProcess = @('password.push.Format.ps1xml')

    # Functions to export from this module
    FunctionsToExport = @()

    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()

    # DSC resources to export from this module
    # DscResourcesToExport = @()

    # List of all files packaged with this module
    # FileList          = @()

    PrivateData       = @{
        PSData = @{
            Tags         = @(
                'Windows'
                'PSedition_Core'
                'PSedition_Desktop'
            )

            LicenseUri   = 'https://github.com/peetrike/password.push/blob/main/LICENSE'
            ProjectUri   = 'https://github.com/peetrike/password.push'
            # IconUri      = ''

            ReleaseNotes = 'https://github.com/peetrike/password.push/blob/main/CHANGELOG.md'

            # Prerelease string of this module
            # Prerelease   = ''

            # Flag to indicate whether the module requires explicit user acceptance for install/update/save
            # RequireLicenseAcceptance = $false

            # External dependent modules of this module
            # ExternalModuleDependencies = @()
        }
    }
}
