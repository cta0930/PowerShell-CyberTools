<#
.SYNOPSIS
    Detects usage of Sysinternals PSExec by monitoring for Event ID 7045 (new service installed).
    PSExec often leaves a service called PSEXESVC.
#>

$eventId = 7045
$filter = @{LogName='System'; Id=$eventId}
$events = Get-WinEvent -FilterHashtable $filter -ErrorAction SilentlyContinue

foreach ($event in $events) {
    if ($event.Message -like '*PSEXESVC*') {
        [PSCustomObject]@{
            TimeCreated = $event.TimeCreated
            Message     = $event.Message
        } | Format-Table -AutoSize
    }
}
