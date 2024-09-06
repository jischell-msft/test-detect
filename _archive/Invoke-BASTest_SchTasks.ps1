function Invoke-BASTest_SchTasks {
    <#
.NOTES
Name:       Invoke-BASTest_SchTasks
Created:    2024-09-05
Modified:   2024-09-05
Author:     JiSchell
Version:    0.1.0
#>

    [CmdletBinding()]
    param (
        [string]$Name_Prefix = "SecTest_",
        [string]$Target_Path = "$($env:windir)\system32",
        [string[]]$Target_Exe = @(
            'notepad.exe', 
            'calc.exe', 
            'whoami.exe', 
            'clip.exe',
            'cmd.exe',
            'findstr.exe',
            'mmc.exe',
            'net.exe',
            'osk.exe',
            'ping.exe',
            'reg.exe'
        )
    )

    begin {
        $dateTime_curr = (Get-Date -Format s).Replace(':', '_')
        
        $task_hour_rand = Get-Random -Minimum 0 -Maximum 23
        $task_min_rand = Get-Random -Minimum 0 -Maximum 59
        $task_time = "$($task_hour_rand):$($task_min_rand)"
        $task_name = "$($Name_Prefix)$($dateTime_curr)"
    }
    process {
        $exe_run = $Target_Exe[(Get-Random -Minimum 0 -Maximum ($Target_Exe.Count - 1))]
        schtasks /Create /SC Once /TN $task_name /TR $exe_run /ST $task_time
        Start-Sleep -Seconds 5
    }
    end {
        schtasks /Delete /TN $task_name /F
    }
}