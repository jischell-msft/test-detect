function New-HourTime {
    <#
.SYNOPSIS
Generate a new time span as HH:mm string format
.DESCRIPTION
.NOTES
#>
    [CmdletBinding()]
    param (
        [OutputType([string])]
        [Parameter()]
        [ValidateRange(0, 23)]
        $Hour_Min = 0,

        [Parameter()]
        [ValidateRange(0, 23)]
        $Hour_Max = 23,

        [Parameter()]
        [ValidateRange(0, 59)]
        $Minute_Min = 0,

        [Parameter()]
        [ValidateRange(0, 59)]
        $Minute_Max = 59
    )
    begin {
        $hour_force = $false
        $minute_force = $false

        if ( $Hour_Max -le $Hour_Min) {
            $Hour_Max = $Hour_Min + 1
            if ( $Hour_Max -ge 23) {
                $hour_force = 23
            }
        }
        if ( $Minute_Max -le $Minute_Min) {
            $Minute_Max = $Minute_Min + 1
            if ( $Minute_Max -ge 59) {
                $minute_force = 59
            }
        }
    }
    process {
        if ( $hour_force ) {
            $hour = $hour_force
        }
        else {
            $hour = Get-Random -Minimum $Hour_Min -Maximum $Hour_Max
        }
        if ( $minute_force ) {
            $minute = $minute_force
        }
        else {
            $minute = Get-Random -Minimum $Minute_Min -Maximum $Minute_Max
        }       
        $hourTime = New-TimeSpan -Hours $hour -Minutes $minute
    }    
    end {
        $hourTime_str = $hourTime.ToString('hh\:mm')
        $hourTime_str
    }
}