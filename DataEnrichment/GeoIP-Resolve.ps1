<#
.SYNOPSIS
    Resolves the geographic location of an IP address using the free ip-api.com service.
#>

param(
    [Parameter(Mandatory = $true)]
    [string]$IPAddress
)

# Construct the URL safely
$uri = "http://ip-api.com/json/$IPAddress"

try {
    $response = Invoke-RestMethod -Uri $uri -Method Get

    if ($response.status -eq "success") {
        [PSCustomObject]@{
            IPAddress = $response.query
            Country   = $response.country
            Region    = $response.regionName
            City      = $response.city
            ZIP       = $response.zip
            ISP       = $response.isp
            Org       = $response.org
            Lat       = $response.lat
            Lon       = $response.lon
            Timezone  = $response.timezone
        } | Format-List
    } else {
        Write-Warning "Lookup failed for ${IPAddress}: $($response.message)"
    }
} catch {
    Write-Error "GeoIP lookup failed: $_"
}
