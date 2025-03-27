<#
.SYNOPSIS
    Performs a basic WHOIS lookup for a domain using an online WHOIS service.
#>

param(
    [Parameter(Mandatory = $true)][string]$Domain
)

$whoisServer = "whois.verisign-grs.com"
$query = "$Domain`r`n"

try {
    $tcpClient = New-Object System.Net.Sockets.TcpClient($whoisServer, 43)
    $stream = $tcpClient.GetStream()
    $writer = New-Object System.IO.StreamWriter($stream)
    $writer.Write($query)
    $writer.Flush()

    $reader = New-Object System.IO.StreamReader($stream)
    $response = $reader.ReadToEnd()

    $writer.Close()
    $reader.Close()
    $tcpClient.Close()

    Write-Output $response
} catch {
    Write-Error "WHOIS lookup failed: $_"
}
