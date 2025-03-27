<#
.SYNOPSIS
    Monitors a specified folder for changes (new or modified log files)
    and prints updates in real time to the console.
#>

param(
    [Parameter(Mandatory = $true)][string]$FolderPath,
    [string]$Filter = "*.log"
)

try {
    $watcher = New-Object System.IO.FileSystemWatcher
    $watcher.Path = $FolderPath
    $watcher.Filter = $Filter
    $watcher.IncludeSubdirectories = $false
    $watcher.EnableRaisingEvents = $true

    Register-ObjectEvent $watcher "Changed" -Action {
        Write-Host "[$(Get-Date)] File changed: $($Event.SourceEventArgs.FullPath)"
    }

    Register-ObjectEvent $watcher "Created" -Action {
        Write-Host "[$(Get-Date)] New file created: $($Event.SourceEventArgs.FullPath)"
    }

    Write-Host "Monitoring $FolderPath for changes. Press Ctrl+C to stop..."
    while ($true) {
        Start-Sleep -Seconds 1
    }
} catch {
    Write-Error "Failed to monitor folder: $_"
}
