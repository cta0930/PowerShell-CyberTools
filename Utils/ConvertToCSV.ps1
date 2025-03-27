<#
.SYNOPSIS
    Converts a given log file (plain text) into a structured CSV based on a regex pattern.
    Useful for turning raw logs into filtered, searchable data.
#>

param(
    [Parameter(Mandatory = $true)][string]$InputFile,
    [Parameter(Mandatory = $true)][string]$OutputCSV,
    [Parameter(Mandatory = $true)][string]$RegexPattern
)

try {
    $results = @()
    $lines = Get-Content -Path $InputFile

    foreach ($line in $lines) {
        if ($line -match $RegexPattern) {
            $results += [PSCustomObject]@{
                MatchedText = $Matches[0]
                OriginalLine = $line
            }
        }
    }

    if ($results.Count -gt 0) {
        $results | Export-Csv -Path $OutputCSV -NoTypeInformation
        Write-Host "Exported $($results.Count) matches to $OutputCSV"
    } else {
        Write-Host "No matches found with provided regex."
    }
} catch {
    Write-Error "Error during conversion: $_"
}
