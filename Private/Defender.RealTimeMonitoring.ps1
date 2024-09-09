function Disable-Defender.RealTimeMonitoring {
    <#
.SYNOPSIS
Disable Real Time Monitoring capability in Microsoft Defender
#>


    [CmdletBinding()]
    param (   
    )
    begin {
        $currentState = (Get-MpPreference).DisableRealtimeMonitoring
        if ( $currentState -eq $($True)) {
            Out-Default -InputObject "Real Time Monitoring currently disabled."
            Break
        }
    }
    process {
        Set-MpPreference -DisableRealtimeMonitoring $True -Force 
    }
    end {
        Out-Default -InputObject "Real Time Monitoring now currently disabled."
    }
}

function Enable-Defender.RealTimeMonitoring {
    <#
.SYNOPSIS
Enable Real Time Monitoring capability in Microsoft Defender
#>


    [CmdletBinding()]
    param (   
    )
    begin {
        $currentState = (Get-MpPreference).DisableRealtimeMonitoring
        if ( $currentState -eq $($False)) {
            Out-Default -InputObject "Real Time Monitoring currently enabled."
            Break
        }
    }
    process {
        Set-MpPreference -DisableRealtimeMonitoring $False -Force
    }
    end {
        Out-Default -InputObject "Real Time Monitoring now currently disabled."
    }
}

