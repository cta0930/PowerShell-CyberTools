<#
.SYNOPSIS
    Extracts DNS query activity from Windows DNS Client logs (Event ID 3008).
    Useful for identifying unusual domain lookups.
#>

$eventID = 3008
$logName = "Microsoft-Windows-DNS-Client/Operational"

try {
    $events = Get-WinEvent -LogName $logName -FilterHashtable @{Id = $eventID} -ErrorAction Stop

    foreach ($event in $events) {
        $xml = [xml]$event.ToXml()
        $queryName = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "QueryName" } | Select-Object -ExpandProperty '#text'

        if ($queryName) {
            [PSCustomObject]@{
                TimeCreated = $event.TimeCreated
                Query       = $queryName
            } | Format-Table -AutoSize
        }
    }
} catch {
    Write-Warning "Failed to retrieve DNS logs. Make sure DNS Client logging is enabled: $_"
}
