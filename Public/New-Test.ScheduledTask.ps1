function New-Test.ScheduledTask {
    <#
.SYNOPSIS
.DESCRIPTION
.NOTES
#>


    [CmdletBinding()]
    param (
        [ValidateSet('All', 'Sys32', 'SysWow64')]
        $Arch = 'All'
    )
    begin {
        if ($Arch -eq 'All') {
            $sys_dir = @('System32', 'SysWOW64')
        }
        else {
            $sys_dir = @( $($Arch) )
        }

        $dateTime_str = (Get-Date -Format s).Replace(':', '_')
        $task_name = "SecTest_$($dateTime_str)"
        $task_time = New-HourTime
        
        $executables = @(
            "arp.exe"
            "calc.exe"
            "clip.exe"
            "cmd.exe"
            "findstr.exe"
            "mmc.exe"
            "net.exe"
            "notepad.exe"
            "osk.exe"
            "ping.exe"
            "reg.exe"
            "whoami.exe"
        )
        $exe_target = $executables[(Get-Random -Minimum 0 -Maximum ($executables.count - 1))]

        $sys_path = Get-Random -InputObject $sys_dir

        $exe_full = "$($env:windir)\$($sys_path)\$($exe_target)"
    }
    process {
        $command_out = @"
schtasks /Create /SC Once /TN $($task_name) /TR $($exe_full) /ST $($task_time)
Start-Sleep -Seconds 5
schtasks /Delete /TN $($task_name)
"@
    }   
    end {
        $command_out
    }
}