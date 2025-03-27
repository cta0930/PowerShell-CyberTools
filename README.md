# PowerShell-CyberTools

A curated set of PowerShell scripts built for cybersecurity analysts. These tools are designed to streamline log parsing, alert triage, and threat hunting to improve SOC efficiency and investigative depth.

## 🔧 Features
- Fast parsing of Windows Event Logs
- Detection of suspicious activity (logins, PSExec, persistence)
- Enrichment tools (IP reputation, WHOIS, GeoIP)
- Utility scripts for exporting, monitoring, and cleaning logs

---

## Repo Structure

```
PowerShell-CyberTools/
├── README.md
├── LICENSE
├── CONTRIBUTING.md
├── ThreatHunting/
│   ├── Find-SuspiciousLogon.ps1
│   ├── Detect-PSExecUsage.ps1
│   └── Identify-Persistence.ps1
├── LogParsing/
│   ├── Parse-WindowsEventLogs.ps1
│   ├── Extract-DNSQueries.ps1
│   └── Export-LogsByKeyword.ps1
├── AlertTriage/
│   ├── Analyze-FirewallAlerts.ps1
│   ├── Triage-AVAlerts.ps1
│   └── Quick-LateralMovementCheck.ps1
├── DataEnrichment/
│   ├── Get-IPReputation.ps1
│   ├── Whois-Lookup.ps1
│   └── GeoIP-Resolve.ps1
└── Utils/
    ├── Convert-ToCSV.ps1
    ├── Watch-FolderLogs.ps1
    └── Clean-LogDirectory.ps1
```

---

## Get Started

1. Clone the repository:
   ```bash
   git clone https://github.com/cta0930/PowerShell-CyberTools.git
   ```
2. Navigate to the desired script folder.
3. Run the script in PowerShell with appropriate permissions.

---

## Sample Script: Parse-WindowsEventLogs.ps1

```powershell
param(
    [string]$LogName = "Security",
    [int[]]$EventIDs = @(4624, 4625, 4672),
    [datetime]$StartTime = (Get-Date).AddDays(-1)
)

$logs = Get-WinEvent -LogName $LogName -FilterHashtable @{Id=$EventIDs; StartTime=$StartTime} -ErrorAction SilentlyContinue

foreach ($log in $logs) {
    $entry = [PSCustomObject]@{
        TimeCreated = $log.TimeCreated
        EventID     = $log.Id
        Message     = $log.Message
    }
    $entry | Format-Table -AutoSize
}
```

---

## Contributing
Pull requests are welcome! If you have a script that speeds up detection, log parsing, or enriches SOC visibility, feel free to contribute!

---

## 📄 License
[MIT License](LICENSE)
