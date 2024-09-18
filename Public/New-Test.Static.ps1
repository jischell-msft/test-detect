function New-Test.Static {
    <#
.SYNOPSIS
.NOTES

#>


    [OutputType([string])]
    [CmdletBinding()]
    param (
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]
        $TestName,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]
        $TestDescription,
    
        [Parameter()]
        [ValidateSet('powershell', 'command_prompt')]
        $Executor = 'powershell',

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]
        $Command, 

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]
        $CleanupCommand
    )
    begin {
        $guid_gen = (New-Guid).Guid
    }
    process {
        $test_obj = New-Object -TypeName PsObject -Property ([ordered]@{
                'Tests.Static' = @(@{
                        name           = $TestName
                        guid           = $guid_gen
                        description    = $TestDescription
                        executor       = @{
                            name            = $Executor
                            command         = $Command
                            cleanup_command = $CleanupCommand
                        }
                        input_argument = @(
                            @{
                                name        = "Name"
                                description = "Description"
                                value       = "Value"
                            }
                        )
                    })
            })
        $test_obj_json = ConvertTo-Json -InputObject $test_obj -Depth 40
    }
    end {
        $test_obj_json
    }
}