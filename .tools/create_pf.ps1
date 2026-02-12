# Create a new portfolio contract (PowerShell)
# Usage: .\create_pf.ps1 <NETWORK> <NAME> <COURSE> <SCHOOL> <ABOUT> <LINKEDIN_URL> <GITHUB_URL> <SKILLS>

$ErrorActionPreference = "Stop"

$SUI_CONTRACT_PATH = Join-Path $PWD "portfolio_contract"

$WALLET_ADDRESS = (sui client active-address 2>$null)
if (-not $WALLET_ADDRESS) {
    Write-Error "Failed to get active address. Ensure 'sui client active-address' works."
    exit 1
}

if ($args.Count -ne 8) {
    Write-Error "Number of arguments should be 8"
    exit 1
}

$NETWORK      = $args[0]
$NAME         = $args[1]
$COURSE       = $args[2]
$SCHOOL       = $args[3]
$ABOUT        = $args[4]
$LINKEDIN_URL = $args[5]
$GITHUB_URL   = $args[6]
$SKILLS       = $args[7]

$required = @(
    @{ N = "Network"; V = $NETWORK; H = "testnet or mainnet" },
    @{ N = "Name"; V = $NAME },
    @{ N = "Course"; V = $COURSE },
    @{ N = "School"; V = $SCHOOL },
    @{ N = "About"; V = $ABOUT },
    @{ N = "LinkedIn URL"; V = $LINKEDIN_URL },
    @{ N = "Github URL"; V = $GITHUB_URL },
    @{ N = "Skills"; V = $SKILLS }
)
foreach ($r in $required) {
    if ([string]::IsNullOrWhiteSpace($r.V)) {
        $msg = "$($r.N) is required"; if ($r.H) { $msg += " ($($r.H))" }
        Write-Error $msg
        exit 1
    }
}

$publishedToml = Join-Path $SUI_CONTRACT_PATH "Published.toml"
if (-not (Test-Path $publishedToml)) {
    Write-Error "Published.toml does not exist"
    exit 1
}

$section = if ($NETWORK -eq "mainnet") { "published.mainnet" } else { "published.testnet" }
$inSection = $false
$SUI_CONTRACT_PACKAGE_ID = $null
foreach ($line in (Get-Content $publishedToml)) {
    if ($line -match "^\s*\[$([regex]::Escape($section))\]") { $inSection = $true; continue }
    if ($inSection -and $line -match "^\s*\[") { break }
    if ($inSection -and $line -match 'published-at\s*=\s*"([^"]+)"') {
        $SUI_CONTRACT_PACKAGE_ID = $Matches[1].Trim('"')
        break
    }
}
if (-not $SUI_CONTRACT_PACKAGE_ID) {
    Write-Error "Could not find published-at in [$section] in Published.toml"
    exit 1
}

Write-Host "SUI_CONTRACT_PACKAGE_ID: $SUI_CONTRACT_PACKAGE_ID"

$DATE_TODAY_W_TIMESTAMP = Get-Date -Format "yyyyMMddHHmmss"
$txDir = Join-Path $SUI_CONTRACT_PATH "tx_portfolios"
if (-not (Test-Path $txDir)) { New-Item -ItemType Directory -Path $txDir -Force | Out-Null }
$SUI_CONTRACT_TX_PORTFOLIOS_PATH = Join-Path $txDir "$NETWORK-$DATE_TODAY_W_TIMESTAMP.json"

& sui client call --package $SUI_CONTRACT_PACKAGE_ID --module portfolio --function create_portfolio --args $WALLET_ADDRESS $NAME $COURSE $SCHOOL $ABOUT $LINKEDIN_URL $GITHUB_URL $SKILLS --gas-budget 10000000 | Set-Content -Path $SUI_CONTRACT_TX_PORTFOLIOS_PATH -Encoding UTF8

if (-not (Test-Path $SUI_CONTRACT_TX_PORTFOLIOS_PATH)) {
    Write-Error "Transaction data not found"
    exit 1
}
$txContent = Get-Content $SUI_CONTRACT_TX_PORTFOLIOS_PATH -Raw
if ($txContent -notmatch "ProgrammableTransaction") {
    Write-Error "Transaction failed"
    Write-Host "Transaction data: $SUI_CONTRACT_TX_PORTFOLIOS_PATH"
    exit 1
}

Write-Host "Portfolio created successfully"
Write-Host "Transaction data saved to: $SUI_CONTRACT_TX_PORTFOLIOS_PATH"

$SUI_PACKAGE_MOD_FN = "${SUI_CONTRACT_PACKAGE_ID}::portfolio::Portfolio"
$PORTFOLIO_FRONTEND_PATH = Join-Path $PWD "portfolio_frontend"

$json = Get-Content $SUI_CONTRACT_TX_PORTFOLIOS_PATH -Raw
$PORTFOLIO_OBJECT_ID = $null
$lines = Get-Content $SUI_CONTRACT_TX_PORTFOLIOS_PATH
for ($i = 0; $i -lt $lines.Count; $i++) {
    if ($lines[$i] -match $SUI_PACKAGE_MOD_FN) {
        for ($j = $i - 1; $j -ge 0; $j--) {
            if ($lines[$j] -match '"objectId"\s*:\s*"([^"]+)"') {
                $PORTFOLIO_OBJECT_ID = $Matches[1]
                break
            }
        }
        break
    }
}
if (-not $PORTFOLIO_OBJECT_ID -and $json -match '"objectId"\s*:\s*"([a-f0-9x]+)"') {
    $PORTFOLIO_OBJECT_ID = $Matches[1]
}

Write-Host "Portfolio object ID: $PORTFOLIO_OBJECT_ID"

$envPath = Join-Path $PORTFOLIO_FRONTEND_PATH ".env"
$envDir = Split-Path $envPath
if (-not (Test-Path $envDir)) { New-Item -ItemType Directory -Path $envDir -Force | Out-Null }
"VITE_PORTFOLIO_OBJECT_ID=$PORTFOLIO_OBJECT_ID" | Set-Content -Path $envPath -Encoding UTF8 -NoNewline
Write-Host "Wrote $envPath"
