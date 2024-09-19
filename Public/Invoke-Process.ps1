function Invoke-Process {
    <#
.SYNOPSIS
.DESCRIPTION
.NOTES
# The Invoke-Process function is loosely based on code from https://github.com/guitarrapc/PowerShellUtil/blob/master/Invoke-Process/Invoke-Process.ps1
# Also based on https://github.com/redcanaryco/invoke-atomicredteam/blob/master/Private/Invoke-Process.ps1
#>


    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param
    (
        [Parameter()]
        [string]
        $FileName = "PowerShell.exe",

        [Parameter()]
        [string]
        $Arguments = "",

        [Parameter()]
        [ValidateRange(1, 1800)]
        [int]
        $TimeoutSeconds = 120
    )

    end {
        $WorkingDirectory = $env:TEMP
        try {
            # new Process
            $process = NewProcess -FileName $FileName -Arguments $Arguments -WorkingDirectory $WorkingDirectory
            
            # Event Handler for Output
            $stdSb = New-Object -TypeName System.Text.StringBuilder
            $errorSb = New-Object -TypeName System.Text.StringBuilder
            $scriptBlock = 
            {
                $x = $Event.SourceEventArgs.Data
                if (-not [String]::IsNullOrEmpty($x)) {
                    $Event.MessageData.AppendLine($x)
                }
            }
            $stdEvent = Register-ObjectEvent -InputObject $process -EventName OutputDataReceived -Action $scriptBlock -MessageData $stdSb
            $errorEvent = Register-ObjectEvent -InputObject $process -EventName ErrorDataReceived -Action $scriptBlock -MessageData $errorSb

            # execution
            $process.Start() > $null
            $process.BeginOutputReadLine()
            $process.BeginErrorReadLine()
            
            # wait for complete
            $Timeout = [System.TimeSpan]::FromSeconds(($TimeoutSeconds))
            $isTimeout = $false
            if (-not $Process.WaitForExit($Timeout.TotalMilliseconds)) {
                $isTimeout = $true
                Write-Error -Message "Timeout detected for $($Timeout.TotalMilliseconds)ms. Kill process immediately"
                $Process.Kill()
            }
            $Process.WaitForExit()
            $Process.CancelOutputRead()
            $Process.CancelErrorRead()

            $stdOutString = $stdSb.ToString().Trim()
            if ($stdOutString.Length -gt 0) {
                Write-Host $stdOutString
            }

            $stdErrString = $errorSb.ToString().Trim()
            if ($stdErrString.Length -gt 0) {
                Write-Host $stdErrString
            }

            # Unregister Event to recieve Asynchronous Event output (You should call before process.Dispose())
            Unregister-Event -SourceIdentifier $stdEvent.Name
            Unregister-Event -SourceIdentifier $errorEvent.Name


            # Get Process result
            return GetCommandResult -Process $process -StandardStringBuilder $stdSb -ErrorStringBuilder $errorSb -IsTimeOut $isTimeout
        }
        finally {
            if ($null -ne $process) { $process.Dispose() }
            if ($null -ne $stdEvent) { $stdEvent.StopJob(); $stdEvent.Dispose() }
            if ($null -ne $errorEvent) { $errorEvent.StopJob(); $errorEvent.Dispose() }
        }
    }

    begin {
        function NewProcess {
            [OutputType([System.Diagnostics.Process])]
            [CmdletBinding()]
            param
            (
                [parameter(Mandatory = $true)]
                [string]$FileName,
                
                [parameter(Mandatory = $false)]
                [string]$Arguments,
                
                [parameter(Mandatory = $false)]
                [string]$WorkingDirectory
            )

            # ProcessStartInfo
            $psi = New-object System.Diagnostics.ProcessStartInfo 
            $psi.CreateNoWindow = $true
            $psi.LoadUserProfile = $true
            $psi.UseShellExecute = $false
            $psi.RedirectStandardOutput = $true
            $psi.RedirectStandardError = $true
            $psi.FileName = $FileName
            $psi.Arguments += $Arguments
            $psi.WorkingDirectory = $WorkingDirectory

            # Set Process
            $process = New-Object System.Diagnostics.Process 
            $process.StartInfo = $psi
            $process.EnableRaisingEvents = $true
            return $process
        }

        function GetCommandResult {
            [OutputType([PSCustomObject])]
            [CmdletBinding()]
            param
            (
                [parameter(Mandatory = $true)]
                [System.Diagnostics.Process]$Process,

                [parameter(Mandatory = $true)]
                [System.Text.StringBuilder]$StandardStringBuilder,

                [parameter(Mandatory = $true)]
                [System.Text.StringBuilder]$ErrorStringBuilder,

                [parameter(Mandatory = $true)]
                [Bool]$IsTimeout
            )

            return [PSCustomObject]@{
                StandardOutput = $StandardStringBuilder.ToString().Trim()
                ErrorOutput    = $ErrorStringBuilder.ToString().Trim()
                ExitCode       = $Process.ExitCode
                ProcessId      = $Process.Id
                IsTimeOut      = $IsTimeout
            }
        }
    }
}