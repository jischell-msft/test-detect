function Set-Casing {
    <#
.SYNOPSIS
.DESCRIPTION
.NOTES
#>
    

    [OutputType([string])]
    [CmdletBinding()]
    param (
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]
        $StringInput,
        
        [Parameter()]
        [ValidateSet('Upper', 'Lower', 'TitleCase', 'Mix')]
        $Casing = 'Mix'
    )
    begin {
        $textInfo = (Get-Culture).TextInfo 
        function Set-CaseRandom {
            [CmdletBinding()]
            param (
                [Parameter()]
                [string]
                $Character
            )
            process {
                $case_num = Get-Random -InputObject (0, 1)
                if ( $case_num -eq 0) {
                    $charOut = $Character.ToLower()
                }
                else {
                    $charOut = $Character.ToUpper()
                }
            }
            end {
                $charOut
            }
        }
    }  
    process {
        if ($Casing -ne 'Mix') {
            switch ($Casing) {
                'Upper' { $stringOutput = $StringInput.ToUpper() }
                'Lower' { $stringOutput = $StringInput.ToLower() }
                'TitleCase' { $stringOutput = $textInfo.ToTitleCase($StringInput.ToLower()) }
            }
        }
        else {
            $string_out_arr = @()
            $string_arr = $StringInput -split "(.)"
            foreach ( $char in $string_arr ) {
                $char_mix = Set-CaseRandom -Character $char
                $string_out_arr += @($char_mix)
            }
            $stringOutput = $string_out_arr -join ""
        }
    }
    end {
        $stringOutput
    }
}