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
        $Executor = 'powershell',

        [Parameter()]
        [ValidateRange(1, 1800)]
        [int]
        $TimeoutSeconds = 120,

        [Parameter()]
        [switch]
        $NoProfile
    )
    
    begin {
        $FinalCommand = $FinalCommand.trim()
        switch ($Executor) {
            "command_prompt" { 
                $exec_exe = "cmd.exe";
                $exec_prefix = "/c";
                $exec_command = $FinalCommand -replace ("([\n])", " & ")
                $exec_arguments = $exec_prefix, "$exec_command"
            }
            "powershell" { 
                $exec_exe = "powershell.exe"
                if ( $NoProfile ) {
                    $exec_prefix = "-noprofile -command"
                }
                else {
                    $exec_prefix = "-command"
                }
                $exec_command = ($FinalCommand -replace ("`"", "`\`"`"") -replace ("([\n])", " ; "))
                $exec_arguments = "$($exec_prefix) `"$($exec_command)`""
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
        $res = Invoke-Process -FileName $exec_exe -Arguments $exec_arguments
    }
    end {
        $res 
    }
}