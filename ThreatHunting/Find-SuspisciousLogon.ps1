<#
.SYNOPSIS
    Finds failed logon attempts (Event ID 4625) with IP address details.
#>

param(
    [datetime]$StartTime = (Get-Date).AddDays(-1)
)

$eventId = 4625  # Failed logon
$logonEvents = Get-WinEvent -FilterHashtable @{LogName='Security'; Id=$eventId; StartTime=$StartTime}

foreach ($event in $logonEvents) {
    $xml = [xml]$event.ToXml()
    $ip = $xml.Event.EventData.Data | Where-Object { $_.Name -eq 'IpAddress' } | Select-Object -ExpandProperty '#text'
    if ($ip -and $ip -ne '::1' -and $ip -ne '127.0.0.1') {
        [PSCustomObject]@{
            TimeCreated = $event.TimeCreated
            IPAddress   = $ip
            Message     = $event.Message
        } | Format-Table -AutoSize
    }
}
