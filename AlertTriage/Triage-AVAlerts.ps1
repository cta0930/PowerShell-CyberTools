<#
.SYNOPSIS
    Parses Microsoft Defender Antivirus events (Event ID 1116) to triage malware detections.
    Shows file name, threat name, and severity.
#>

$logName = "Microsoft-Windows-Windows Defender/Operational"
$eventID = 1116

try {
    $events = Get-WinEvent -FilterHashtable @{LogName = $logName; Id = $eventID} -ErrorAction Stop

    foreach ($event in $events) {
        $xml = [xml]$event.ToXml()
        $threat = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "ThreatName" } | Select-Object -ExpandProperty '#text'
        $path = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "Path" } | Select-Object -ExpandProperty '#text'
        $severity = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "SeverityID" } | Select-Object -ExpandProperty '#text'

        [PSCustomObject]@{
            TimeCreated = $event.TimeCreated
            ThreatName  = $threat
            FilePath    = $path
            Severity    = $severity
        } | Format-Table -AutoSize
    }
} catch {
    Write-Error "Error retrieving AV alerts: $_"
}
