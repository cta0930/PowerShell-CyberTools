<#
.SYNOPSIS
    Cleans up old log files in a specified directory based on age (in days).
#>

param(
    [Parameter(Mandatory = $true)][string]$FolderPath,
    [int]$OlderThanDays = 30,
    [string]$Extension = "*.log"
)

try {
    $cutoff = (Get-Date).AddDays(-$OlderThanDays)

    $files = Get-ChildItem -Path $FolderPath -Filter $Extension -File |
        Where-Object { $_.LastWriteTime -lt $cutoff }

    if ($files.Count -eq 0) {
        Write-Host "No log files older than $OlderThanDays days were found."
    } else {
        foreach ($file in $files) {
            Remove-Item $file.FullName -Force
            Write-Host "Deleted: $($file.FullName)"
        }
    }
} catch {
    Write-Error "Error during cleanup: $_"
}
