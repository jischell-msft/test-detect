function New-Test.SchTasks {
    <#
.SYNOPSIS
Generate a new scheduled task. Designed to test detections.
.DESCRIPTION
.NOTES
Name:       New-Test.SchTasks
Created:    2024-09-05
Modified:   2024-09-16
Author:     JiSchell
Version:    0.1.8

#>


    [CmdletBinding()]
    param (
        [Parameter()]
        [ValidateSet('All', 'System32', 'SysWow64')]
        $Arch = 'All',

        [Parameter()]
        [ValidateSet('Dash', 'Slash', 'All')]
        $ArgumentDelimiter = 'All',

        [Parameter()]
        [string]
        $Payload = "Default",

        [Parameter()]
        [ValidateSet('Upper', 'Lower', 'TitleCase', 'Mix')]
        $Casing = 'Mix'
    )
    begin {
        if ($Arch -eq 'All') {
            $sys_dir = @('System32', 'SysWOW64')
        }
        else {
            $sys_dir = @( $($Arch) )
        }

        switch ($ArgumentDelimiter) {
            "Dash" { $arg_inp = '-' }
            "Slash" { $arg_inp = '/' }
            Default { $arg_inp = Get-Random -InputObject @('-', '/') }
        }


        $dateTime_str = (Get-Date -Format s).Replace(':', '_')
        $task_name = "SecTest_$($dateTime_str)"
        $task_time = New-HourTime
        
        if ( $Payload -eq "Default") {
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
        else {
            $exe_full = $Payload
        }

        $schTask = Get-Random -InputObject @('schtasks', 'schtasks.exe')
    }
    process {
        $command_out = @"
$($schTask) $($arg_inp)Create $($arg_inp)SC Once $($arg_inp)TN $($task_name) $($arg_inp)ST $($task_time) $($arg_inp)TR `'$($exe_full)`';
Start-Sleep -Seconds 5;
$($schTask) $($arg_inp)Delete $($arg_inp)TN $($task_name) $($arg_inp)F;
"@
        $command_out = Set-Casing -string $command_out -Casing $Casing
    }   
    end {
        $command_out
    }
}