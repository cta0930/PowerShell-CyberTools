<#
.SYNOPSIS
    Filters and highlights potentially suspicious WMI activity from the
    Microsoft-Windows-WMI-Activity/Operational log.
#>

param(
    [string[]]$Keywords = @("Win32_Process", "powershell.exe", "cmd.exe", "psexec", "wmi", "ExecQuery", "ExecNotificationQuery"),
    [switch]$ExportCSV
)

# Check for admin rights
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "You must run this script as Administrator."
    return
}

# Retrieve events from the WMI Activity Operational log
$events = Get-WinEvent -LogName "Microsoft-Windows-WMI-Activity/Operational" -ErrorAction SilentlyContinue

# Filter messages by keyword
$filtered = $events | Where-Object {
    $msg = $_.Message.ToLower()
    $Keywords | Where-Object { $msg -like "*$_*" }
}

if (-not $filtered) {
    Write-Host "No suspicious WMI activity matched the current filters."
    return
}

# Parse and present relevant data
$results = foreach ($event in $filtered) {
    [PSCustomObject]@{
        TimeStamp = $event.TimeCreated
        User      = if ($event.Message -match "User\s+=\s+([^\s;]+)") { $matches[1] } else { "N/A" }
        Operation = if ($event.Message -match "Operation\s+=\s+(.+?);") { $matches[1] } else { "N/A" }
        Message   = $event.Message -replace '\s+', ' '
    }
}

$results | Format-Table -AutoSize

# Export if requested
if ($ExportCSV) {
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $results | Export-Csv -Path ".\WMIActivity_$timestamp.csv" -NoTypeInformation
    Write-Host "Results exported to WMIActivity_$timestamp.csv"
}
