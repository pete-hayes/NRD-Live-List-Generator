# Suppress warnings
$PSDefaultParameterValues['Invoke-WebRequest:WarningAction'] = 'SilentlyContinue'

# Output file in the same directory as the script
$outputFile = Join-Path $PSScriptRoot 'NewlyRegisteredDomains.html'

# Timestamp
$timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'

# Fetch domain list, split into lines, trim, limit to 50
try {
    $raw = Invoke-RestMethod -Uri 'https://shreshtait.com/newly-registered-domains/nrd-1w' -ErrorAction Stop

    $domains = ($raw -split "\r?\n") |
               ForEach-Object { $_.Trim() } |
               Where-Object { $_ } |
               Select-Object -First 50
}
catch {
    Write-Error "Failed to fetch domain list: $_"
    exit 1
}

# Initialize HTML builder
$sb = [System.Text.StringBuilder]::new()
$null = $sb.AppendLine('<!DOCTYPE html>')
$null = $sb.AppendLine('<html>')
$null = $sb.AppendLine('<head>')
$null = $sb.AppendLine('<meta charset="UTF-8">')
$null = $sb.AppendLine('<title>Newly Registered Domains</title>')
$null = $sb.AppendLine('</head>')
$null = $sb.AppendLine('<body>')
$null = $sb.AppendLine('<h2>Newly Registered Domains</h2>')
$null = $sb.AppendLine("<p><b>Last updated:</b> $timestamp</p>")
$null = $sb.AppendLine('<ul>')

# HTTPS-only reachability test
function Test-Domain {
    param(
        [Parameter(Mandatory)]
        [string]$Domain
    )

    $url = "https://$Domain"

    try {
        $response = Invoke-WebRequest `
    -Uri $url `
    -Method Get `
    -TimeoutSec 5 `
    -MaximumRedirection 5 `
    -UseBasicParsing `
    -ErrorAction Stop


        $status = [int]$response.StatusCode

        if ($status -ge 200 -and $status -lt 400) {
            return $url
        }
    }
    catch {
        return $null
    }

    return $null
}

# Process domains
$total = $domains.Count
$index = 0

foreach ($domain in $domains) {
    $index++
    Write-Host -NoNewline "[$index/$total] $domain... "

    $url = Test-Domain -Domain $domain
    if ($url) {
        Write-Host 'Valid (will be added)' -ForegroundColor Green
        $null = $sb.AppendLine("<li><a href='$url' target='_blank' rel='noopener noreferrer'>$domain</a></li>")
    }
    else {
        Write-Host 'Unreachable or invalid (skipped)' -ForegroundColor Red
    }
}

# Close HTML and write file
$null = $sb.AppendLine('</ul>')
$null = $sb.AppendLine('</body>')
$null = $sb.AppendLine('</html>')

$sb.ToString() | Out-File -FilePath $outputFile -Encoding UTF8

Write-Host "`nHTML file created: $outputFile"
Start-Process $outputFile
