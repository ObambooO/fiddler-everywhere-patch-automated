# GetLatest-FEVersion.ps1 (GHA output directly)

try {
    Write-Host "🔎 Fetching latest version of Fiddler Everywhere..."
    if ($env:OS_ARCH -eq 'Mac (arm64)') {
        $url = "https://downloads.getfiddler.com/mac-arm64/latest-mac.yml"
        $content = Invoke-RestMethod -Uri $url -Method Get
        $versionPattern = '(?m)^version:\s*(\d+\.\d+\.\d+)\s*$'
    }
    else {
        $url = "https://www.telerik.com/support/whats-new/fiddler-everywhere/release-history"
        $content = Invoke-RestMethod -Uri $url -Method Get
        $versionPattern = 'Fiddler Everywhere v(\d+\.\d+\.\d+)'
    }

    if ($content -match $versionPattern) {
        $version = $matches[1]
        Write-Host "✅ Latest Version Found: $version"

        # --- THIS IS THE NEW PART ---
        # Check if the GITHUB_OUTPUT environment variable exists.
        if ($env:GITHUB_OUTPUT) {
            Write-Host "🚀 Setting GitHub Actions output variable..."
            # Write in the format "key=value" to the file specified by GITHUB_OUTPUT
            echo "scraped_version=$version" | Out-File -Append -FilePath $env:GITHUB_OUTPUT
        }
    }
    else {
        throw "Could not find the version pattern in the page's HTML."
    }
}
catch {
    Write-Error $_.Exception.Message
    exit 1
}
