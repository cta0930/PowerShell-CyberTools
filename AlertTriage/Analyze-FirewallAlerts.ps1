<#
.SYNOPSIS
    Analyzes Windows Filtering Platform firewall events to detect blocked inbound or outbound connections.
    Focuses on Event IDs 5157 (blocked) and 5152 (allowed).
#>

param(
    [datetime]$StartTime = (Get-Date).AddDays(-1),
    [string[]]$EventIDs = @("5157", "5152")
)

try {
    $events = Get-WinEvent -FilterHashtable @{
        LogName = 'Security';
        Id = $EventIDs;
        StartTime = $StartTime
    } -ErrorAction Stop

    foreach ($event in $events) {
        $xml = [xml]$event.ToXml()
        $app = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "Application" } | Select-Object -ExpandProperty '#text'
        $srcAddr = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "SourceAddress" } | Select-Object -ExpandProperty '#text'
        $dstAddr = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "DestinationAddress" } | Select-Object -ExpandProperty '#text'

        [PSCustomObject]@{
            TimeCreated = $event.TimeCreated
            EventID     = $event.Id
            Application = $app
            SourceIP    = $srcAddr
            DestinationIP = $dstAddr
        } | Format-Table -AutoSize
    }
} catch {
    Write-Error "Could not retrieve firewall events: $_"
}
