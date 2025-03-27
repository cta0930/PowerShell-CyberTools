<#
.SYNOPSIS
    Detects potential user enumeration by counting failed login attempts (Event ID 4625)
    and listing usernames with the highest failure counts.
#>

$events = Get-WinEvent -LogName Security -FilterXPath "*[System[(EventID=4625)]]" -ErrorAction SilentlyContinue

$users = @{}
foreach ($event in $events) {
    $xml = [xml]$event.ToXml()
    $username = $xml.Event.EventData.Data | Where-Object { $_.Name -eq 'TargetUserName' } | Select-Object -ExpandProperty '#text'
    if ($username) {
        if ($users.ContainsKey($username)) {
            $users[$username]++
        } else {
            $users[$username] = 1
        }
    }
}

$users.GetEnumerator() | Sort-Object Value -Descending | Format-Table Key, Value -AutoSize
