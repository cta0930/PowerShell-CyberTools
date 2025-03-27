<#
.SYNOPSIS
    Filters Windows Event Logs by keyword and exports matching entries to a CSV.
#>

param(
    [string]$LogName = "Security",
    [string]$Keyword = "failed",
    [datetime]$StartTime = (Get-Date).AddDays(-1),
    [string]$OutputPath = "$env:USERPROFILE\\Desktop\\FilteredLogs.csv"
)

try {
    $events = Get-WinEvent -LogName $LogName -FilterHashtable @{StartTime = $StartTime} -ErrorAction Stop
    $filtered = @()

    foreach ($event in $events) {
        if ($event.Message -match $Keyword) {
            $filtered += [PSCustomObject]@{
                TimeCreated = $event.TimeCreated
                EventID     = $event.Id
                Message     = $event.Message
            }
        }
    }

    if ($filtered.Count -gt 0) {
        $filtered | Export-Csv -Path $OutputPath -NoTypeInformation
        Write-Host "Exported $($filtered.Count) matching events to: $OutputPath"
    } else {
        Write-Host "No events matched the keyword '$Keyword'."
    }
} catch {
    Write-Error "Failed to export logs: $_"
}
