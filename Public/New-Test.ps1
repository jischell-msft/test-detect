function New-Test {
    <#
.SYNOPSIS
.NOTES
Created: 2024-09-05
Modified: 2024-09-20

Consolidated 'Static' and 'Dynamic' test types into single type 'Tests'
#>


    [OutputType([TestObject])]
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
        $CleanupCommand,

        [Parameter()]
        [InputArgument[]]
        $InputArgument,

        [Parameter()]
        [switch]
        $OutputJSON
    )
    begin {
        $guid_gen = (New-Guid).Guid
        $process_step = Get-Random -Minimum 1000 -Maximum 32768
    }
    process {
        $testExecutor = [testExecutor]::new()
        $testExecutor.name = $Executor
        $testExecutor.command = $Command
        $testExecutor.cleanup_command = $CleanupCommand

        $testObject = [TestObject]::new()

        $testObject.name = $TestName
        $testObject.guid = $guid_gen
        $testObject.description = $TestDescription
        $testObject.process_order = $process_step
        $testObject.executor = $testExecutor

        $input_argument_arr = @()
        if ( $InputArgument.Count ) {
            $name_count = $InputArgument.name | Group-Object 
            if ( $name_count | Where-Object { $_.Count -gt 1 } ) {
                Write-Error -Message "Names for InputArgument must be unique"
                break
            }
            
            foreach ( $arg in $InputArgument) {
                $new_arg = [InputArgument]::new()
                $new_arg.name = $arg.name
                $new_arg.description = $arg.description
                $new_arg.value = $arg.value

                if ( ($arg.name -notlike "multi.*") -and 
                    ($arg.name -notlike "powershell.*") -and 
                    ($arg.name -notlike "static.*")) {
                    Write-Warning -Message "`"$($arg.name)`" does not start with `"multi`", `"powershell`" or `"static`""
                }
                $input_argument_arr += @($new_arg)
            }
        }

        $testObject.input_argument = $input_argument_arr
        
        if ( $OutputJSON ) {
            $testObject_out = ConvertTo-Json -InputObject $testObject -Depth 40
        }
        else {
            $testObject_out = $testObject
        }
    }
    end {
        $testObject_out
    }
}

function New-TestInputArgument {
    <#
.NOTES
Created 2024-09-20
#>


    [CmdletBinding()]
    [OutputType([InputArgument])]
    param (
        [Parameter()]
        [ValidateScript({ ($_ -like "multi.*") -or ($_ -like "powershell.*") -or ($_ -like "static.*") })]
        [string]
        $Name,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]
        $Description,
        
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $Value
    )
    begin {
        $inputArg = [InputArgument]::new()
    }
    process {
        $inputArg.name = $Name 
        $inputArg.description = $Description
        $inputArg.value = $Value
    }
    end {
        $inputArg
    }
}

function New-Campaign {
    <#
.SYNOPSIS
.DESCRIPTION
.NOTES
Created 2024-09-20
#>


    [CmdletBinding()]
    [OutputType([CampaignObject])]
    param (
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]
        $Description,

        [Parameter()]
        [ValidateSet('FIFO', 'FILO')]
        $CleanupOrder = 'FILO',

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [TestObject[]]
        $Tests,

        [Parameter()]
        [switch]
        $OutputJSON
    )
    
    begin {
        $campaign = [CampaignObject]::new()
    }    
    process {
        $campaign.name = $Name
        $campaign.description = $Description
        $campaign.cleanup_order = $CleanupOrder
        $campaign.tests = $Tests

        if ( $OutputJSON ) {
            $campaign_out = $campaign | ConvertTo-Json -Depth 40
        }
        else {
            $campaign_out = $campaign
        }
    }
    
    end {
        $campaign_out
    }
}
