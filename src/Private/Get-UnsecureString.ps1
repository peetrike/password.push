function Get-UnsecureString {
    [OutputType([String])]
    [CmdletBinding()]
    param (
            [Parameter(
                Mandatory,
                ValueFromPipeline
            )]
            [securestring]
        $SecureString
    )

    process {
        $BinaryString = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecureString);

        try {
            [Runtime.InteropServices.Marshal]::PtrToStringBSTR($BinaryString)
        } finally {
            [Runtime.InteropServices.Marshal]::FreeBSTR($BinaryString)
        }
    }
}
