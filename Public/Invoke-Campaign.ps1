function Invoke-Campaign {
    <#
.SYNOPSIS
.DESCRIPTION
.NOTES

Created: 2024-09-20
Modified: 2024-09-20

#>


    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $PathToCampaignFolder = $env:HOMEDRIVE + "\test-detect\campaigns\",

        [Parameter()]
        [string[]]
        $CampaignName,

        [Parameter()]
        [ValidateSet('FIFO', 'FILO')]
        $CleanupOrder = 'FILO',

        [Parameter()]
        [string]
        $LogPath = "$env:TEMP\Test-Detect_Campaign_Log.csv",

        [Parameter()]
        [string]
        $LoggingModule
    )
    
    begin {
        $PathToCampaignFolder = (Resolve-Path $PathToCampaignFolder).Path
        if ( Test-Path -Path $PathToCampaignFolder) {
            
        }
        else {
            Write-Error -Message "$($PathToCampaignFolder) not found"
            break
        }
    }
    process {
        
    }
    end {
        
    }
}