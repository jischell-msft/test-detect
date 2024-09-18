function New-Test.Dynamic {
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
                'Tests.Dynamic' = @(@{
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
                                name        = "multi." + "[name_here]"
                                description = "Select from one of the values, random choice"
                                value       = @(
                                    "value1"
                                    "value2"
                                    "value3"
                                )
                            }
                            @{
                                name        = "powershell." + "[name_here]"
                                description = "Use result from powershell command as value"
                                value       = "(Get-Random -Minimum 1 -Maximum 2)"
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