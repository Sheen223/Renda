$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$circuitDir = Join-Path $repoRoot "circuits\payroll_sum"

if (-not (Get-Command nargo -ErrorAction SilentlyContinue)) {
  Write-Error "nargo is not installed or not in PATH. Install Noir with noirup before running this script."
}

Push-Location $circuitDir
try {
  nargo check
}
finally {
  Pop-Location
}
