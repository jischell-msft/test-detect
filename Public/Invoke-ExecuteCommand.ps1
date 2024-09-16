function Invoke-ExecuteCommand {
    <#
.SYNOPSIS 
Heavily inspired by Atomic Red Team Invoke-ExecuteCommand
.NOTES

#>


    [CmdletBinding()]
    param (
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]
        $FinalCommand,
        
        [Parameter()]
        [ValidateSet('command_prompt', 'powershell')]
        [string]
        $Executor
    )
    
    begin {
        $FinalCommand = $FinalCommand.trim()
        $exec_command = $FinalCommand -replace ("(?<!;)\n", "; ")
        switch ($Executor) {
            "command_prompt" { 
                $exec_exe = "cmd.exe";
                $exec_prefix = "/c";
                $exec_command = $FinalCommand -replace ("`n", " & ")
                $exec_arguments = $exec_prefix, "$exec_command"
            }
            Default { 
                $exec_exe = "powershell.exe"
                $exec_prefix = "-command"
                $exec_command = $exec_command
                $exec_arguments = "$($exec_prefix) $($exec_command)"
            }
        }
    }
    process {
        @"
Exec exe: $($exec_exe)
Prefix:   $($exec_prefix)
Command:  $($exec_command)
Argument: $($exec_arguments)
"@
    }
    end {
        
    }
}