<#
.SYNOPSIS
    Checks the reputation of an IP address using AbuseIPDB's free API.
    Requires a free API key from https://www.abuseipdb.com/
#>

param(
    [Parameter(Mandatory = $true)][string]$IPAddress,
    [Parameter(Mandatory = $true)][string]$ApiKey
)

$uri = "https://api.abuseipdb.com/api/v2/check?ipAddress=$IPAddress"

$headers = @{
    Key        = $ApiKey
    Accept     = "application/json"
}

try {
    $response = Invoke-RestMethod -Uri $uri -Headers $headers -Method Get

    [PSCustomObject]@{
        IPAddress         = $response.data.ipAddress
        IsWhitelisted     = $response.data.isWhitelisted
        AbuseConfidence   = $response.data.abuseConfidenceScore
        TotalReports      = $response.data.totalReports
        LastReportedAt    = $response.data.lastReportedAt
        Country           = $response.data.countryCode
        ISP               = $response.data.isp
        Domain            = $response.data.domain
    } | Format-List
} catch {
    Write-Error "Error retrieving IP reputation: $_"
}
