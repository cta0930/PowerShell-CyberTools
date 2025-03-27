<#
.SYNOPSIS
    Identifies autorun persistence mechanisms in the Windows Registry under HKLM Run.
#>

try {
    Get-ItemProperty "HKLM:\\Software\\Microsoft\\Windows\\CurrentVersion\\Run" |
    ForEach-Object {
        [PSCustomObject]@{
            Name  = $_.PSChildName
            Value = $_.""
        }
    } | Format-Table -AutoSize
} catch {
    Write-Error "Access denied or key not found. Run PowerShell as Administrator."
}
