function Get-Hamlet {
    <#
.SYNOPSIS
Returns a portion of text from Hamlet
.NOTES
Name:       Get-Hamlet
Created:    2024-09-11
Modified:   2024-09-16
Author:     JiSchell
Version:    0.1.2
#>

    [CmdletBinding()]
    [OutputType([string])]
    param (
        [Parameter()]
        [string]
        $HamletSource = 'https://raw.githubusercontent.com/philcldn/CVM/main/hamlet.txt',

        [Parameter()]
        [string]
        $HamletPath = "$($env:temp)\hamlet.txt",

        [Parameter()]
        [ValidateRange(100, 20000)]
        [int]
        $CharactersReturned = 200,

        [Parameter()]
        [switch]
        $CompleteText,
        
        [Parameter()]
        [switch]
        $OnlineOnly
    )
    
    begin {
        function Import-Hamlet {
            [CmdletBinding()]
            [OutputType([string])]
            param (
                [Parameter()]
                [string]
                $HamletSource = 'https://raw.githubusercontent.com/philcldn/CVM/main/hamlet.txt'
            )
            process {
                $hamlet_raw = Invoke-RestMethod -Uri $HamletSource -ErrorAction Stop
                $hamlet_clean = ($hamlet_raw -replace ("[^\w\s]", "")) -replace ("[\s]{2,}", " ")
            }
            end {
                $hamlet_clean
            }
        }

        if ( $OnlineOnly ) {
            $hamlet_clean = Import-Hamlet
        }
        else {
            if ( Test-Path $HamletPath ) {
                if ( (Get-Content -Path $HamletPath -Raw).Length -ge 5000) {
                    $hamlet_clean = Get-Content -Path $HamletPath -Raw
                }
                else {
                    Set-Content -Value Import-Hamlet -Path $HamletPath
                    $hamlet_clean = Get-Content -Path $HamletPath -Raw
                }
            }
            else {
                Set-Content -Value Import-Hamlet -Path $HamletPath
                $hamlet_clean = Get-Content -Path $HamletPath -Raw
            }
        }
        
        $hamlet_len = $hamlet_clean.Length

        if ( $CharactersReturned -ge 2000) {
            $step_back = $CharactersReturned
        }
        else {
            $step_back = 2000
        }

        if ( !($Complete) ) {
            $start_position = Get-Random -Minimum 1000 -Maximum ($hamlet_len - $step_back)
        }
    }
    process {
        if ( !($Complete)) {
            $hamlet_out = $hamlet_clean[$start_position..($start_position + $CharactersReturned)] -join ""
        }
        else {
            $hamlet_out = $hamlet_clean -join ""
        }
    }
    end {
        $hamlet_out
    }
}