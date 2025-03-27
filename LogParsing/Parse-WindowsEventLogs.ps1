<#
.SYNOPSIS
    Parses specified Windows Event Logs for given Event IDs within a time range.
#>

param(
    [string]$LogName = "Security",
    [int[]]$EventIDs = @(4624, 4625, 4672),
    [datetime]$StartTime = (Get-Date).AddDays(-1)
)

try {
    $logs = Get-WinEvent -LogName $LogName -FilterHashtable @{Id=$EventIDs; StartTime=$StartTime} -ErrorAction Stop
    foreach ($log in $logs) {
        [PSCustomObject]@{
            TimeCreated = $log.TimeCreated
            EventID     = $log.Id
            Message     = $log.Message
        } | Format-Table -AutoSize
    }
} catch {
    Write-Error "Error retrieving logs: $_"
}
