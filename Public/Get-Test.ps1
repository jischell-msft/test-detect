function Get-Test {
    <#
.SYNOPSIS
.NOTES

Created: 2024-09-16
Modified: 2024-09-20

Consolidated 'Static' and 'Dynamic' test types into single type 'Tests'
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
                    switch -Wildcard ( "$($arg.name)") {
                        "multi.*" { 
                            $value_out = $arg.value[(Get-Random -Minimum 0 -Maximum ($arg.value.Count - 1))]
                        }
                        "powershell.*" {
                            $value_out = Invoke-Expression -Command $($arg.value)
                        }
                        "static.*" {
                            $value_out = $arg_value
                        }
                        Default {
                            $value_out = $arg_value
                        }
                    }                    
                    $test_out.executor.command = $test_out.executor.command -replace ("#{$($arg.name)}", "$($value_out)")
                    $test_out.executor.cleanup_command = $test_out.executor.cleanup_command -replace ("#{$($arg.name)}", "$($value_out)")
                }
            }
            end {
                $test_out
            }
        }
    }
    process {

        $test_content = $null

        $test_content = ConvertFrom-Json -InputObject $json_content

        if ( $test_content) {
            if ( $test_content.'Tests'.Count -ge 2) {
                $test_format = @()
                foreach ( $test_sub in $test_content.'Tests') {
                    $test_format_sub = ConvertTo-Test -TestInput $test_sub
                    $test_format += @($test_format_sub)
                }
            }
            else {
                $test_format = @(ConvertTo-Test -TestInput $test_content.'Tests')
            }
        }
    }
    end {
        $test_format
    }
}