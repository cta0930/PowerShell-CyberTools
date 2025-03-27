<#
.SYNOPSIS
    Quickly checks for signs of lateral movement using common event IDs:
    - 4624: Successful logon
    - 4648: Logon with explicit credentials
    - 4672: Admin logon
    Filters for network logons (Type 3) and remote credential use.
#>

param(
    [datetime]$StartTime = (Get-Date).AddDays(-1)
)

$eventIDs = @(4624, 4648, 4672)

try {
    $events = Get-WinEvent -FilterHashtable @{
        LogName = 'Security';
        Id = $eventIDs;
        StartTime = $StartTime
    } -ErrorAction Stop

    foreach ($event in $events) {
        $xml = [xml]$event.ToXml()
        $logonType = $xml.Event.EventData.Data | Where-Object { $_.Name -eq 'LogonType' } | Select-Object -ExpandProperty '#text'
        $ip = $xml.Event.EventData.Data | Where-Object { $_.Name -eq 'IpAddress' } | Select-Object -ExpandProperty '#text'

        if ($logonType -eq "3" -and $ip -and $ip -ne "::1" -and $ip -ne "127.0.0.1") {
            [PSCustomObject]@{
                TimeCreated = $event.TimeCreated
                EventID     = $event.Id
                RemoteIP    = $ip
                Message     = $event.Message
            } | Format-Table -AutoSize
        }
    }
} catch {
    Write-Error "Error during lateral movement triage: $_"
}
