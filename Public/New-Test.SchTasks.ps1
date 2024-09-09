function New-Test.SchTasks {
    <#
.SYNOPSIS
.DESCRIPTION
.NOTES
#>


    [CmdletBinding()]
    param (
        [Parameter()]
        [ValidateSet('All', 'System32', 'SysWow64')]
        $Arch = 'All',

        [Parameter()]
        [ValidateSet('Dash', 'Slash', 'All')]
        $ArgumentInput
    )
    begin {
        if ($Arch -eq 'All') {
            $sys_dir = @('System32', 'SysWOW64')
        }
        else {
            $sys_dir = @( $($Arch) )
        }

        if ( $ArgumentInput -eq 'All') {
            $arg_inp = Get-Random -InputObject @('-', '/')
        }
        elseif ($ArgumentInput -eq 'Dash') {
            $arg_inp = '-'
        }
        else {
            $arg_inp = '/'
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
schtasks $($arg_inp)Create $($arg_inp)SC Once $($arg_inp)TN $($task_name) $($arg_inp)TR $($exe_full) $($arg_inp)ST $($task_time)
Start-Sleep -Seconds 5
schtasks $($arg_inp)Delete $($arg_inp)TN $($task_name)
"@
    }   
    end {
        $command_out
    }
}