# Resolve Desktop folder path
$desktopPath = [Environment]::GetFolderPath("Desktop")
if (-not (Test-Path $desktopPath)) {
    $desktopPath = [Environment]::GetFolderPath("MyDocuments")
}

# Create log file path
$logPath = Join-Path $desktopPath "WMI_Hunt_$(Get-Date -Format yyyyMMdd_HHmmss).log"

# Logging function
function Log-Output {
    param ([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "[$timestamp] $Message" | Tee-Object -FilePath $logPath -Append
}

# Start log
"[$(Get-Date)] Starting WMI Threat Hunt..." | Out-File -FilePath $logPath

# 1. Check for WMI Event Filters
Log-Output "Checking for __EventFilter..."
Get-WmiObject -Namespace root\subscription -Class __EventFilter | ForEach-Object {
    Log-Output "EventFilter: Name=$($_.Name), Query=$($_.Query), CreatorSID=$($_.CreatorSID)"
}

# 2. CommandLine Consumers
Log-Output "Checking for CommandLineEventConsumer..."
Get-WmiObject -Namespace root\subscription -Class CommandLineEventConsumer | ForEach-Object {
    Log-Output "CommandLineEventConsumer: Name=$($_.Name), CommandLineTemplate=$($_.CommandLineTemplate)"
}

# 3. Bindings between filters and consumers
Log-Output "Checking for __FilterToConsumerBinding..."
Get-WmiObject -Namespace root\subscription -Class __FilterToConsumerBinding | ForEach-Object {
    Log-Output "Binding: Filter=$($_.Filter), Consumer=$($_.Consumer)"
}

# Complete
Log-Output "WMI hunt completed. Review log at: $logPath"
Start-Process notepad.exe $logPath
