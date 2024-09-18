function Get-Test.Static {
    <#
.SYNOPSIS
.NOTES
#>


    [CmdletBinding(DefaultParameterSetName = 'FilePath')]
    param (
        [Parameter(ParameterSetName = 'FilePath')]
        [string]
        [ValidateScript({ Test-Path -Path $_ -Include '*.json' })]
        $Path,

        [Parameter(ParameterSetName = 'JSON')]
        [ValidateNotNullOrEmpty()]
        [string]
        $JSON
    )
    begin {
        switch ($PSCmdlet.ParameterSetName) {
            'FilePath' {  
                $pathToFile = Resolve-Path -Path $Path
                $json_content = Get-Content -Path $pathToFile -Raw
            }
            'JSON' {
                $json_content = $JSON
            }
        }
    }
    process {
        function ConvertTo-Test {
            <#
        
        #>

            [CmdletBinding()]
            param (
                [Parameter()]
                [psobject]
                $TestInput
            )
            process {
                $test_out = New-Object -TypeName PsObject -Property ([ordered]@{
                        name           = "$($TestInput.name)"
                        guid           = "$($TestInput.guid)"
                        description    = "$($TestInput.description)"
                        executor       = @{
                            name            = "$($TestInput.executor.name)"
                            command         = "$($TestInput.executor.command)"
                            cleanup_command = "$($TestInput.executor.cleanup_command)"
                        }
                        input_argument = $null
                    })
                if ( $TestInput.input_argument ) {
                    Add-Member -InputObject $test_out -Name 'input_argument' -Value $($TestInput.input_argument) -MemberType NoteProperty -Force
                }
                foreach ( $arg in $test_out.input_argument ) {
                    $test_out.executor.command = $test_out.executor.command -replace ("#{$($arg.name)}", "$($arg.value)")
                    $test_out.executor.cleanup_command = $test_out.executor.cleanup_command -replace ("#{$($arg.name)}", "$($arg.value)")
                }
            }
            end {
                $test_out
            }
        }

        $test_content = $null

        $test_content = ConvertFrom-Json -InputObject $json_content

        if ( $test_content) {
            if ( $test_content.'Tests.Static'.Count -ge 2) {
                $test_format = @()
                foreach ( $test_sub in $test_content.'Tests.Static') {
                    $test_format_sub = ConvertTo-Test -TestInput $test_sub
                    $test_format += @($test_format_sub)
                }
            }
            else {
                $test_format = ConvertTo-Test -TestInput $test_content.'Tests.Static'
            }
        }
    }
    end {
        $test_format
    }
}