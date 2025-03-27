<#
.SYNOPSIS
    Detects the use of '-EncodedCommand' in PowerShell event logs (Event ID 4104),
    which is often used by attackers to obfuscate commands.
#>

$logs = Get-WinEvent -LogName "Windows PowerShell" -FilterXPath "*[System[(EventID=4104)]]" -ErrorAction SilentlyContinue

foreach ($log in $logs) {
    if ($log.Message -match "-EncodedCommand") {
        [PSCustomObject]@{
            TimeCreated = $log.TimeCreated
            Message     = $log.Message
        } | Format-Table -AutoSize
    }
}
