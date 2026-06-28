$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$circuitDir = Join-Path $repoRoot "circuits\payroll_sum"

if (-not (Get-Command nargo -ErrorAction SilentlyContinue)) {
  Write-Error "nargo is not installed or not in PATH. Install Noir with noirup before running this script."
}

if (-not (Get-Command bb -ErrorAction SilentlyContinue)) {
  Write-Error "bb is not installed or not in PATH. Install Barretenberg with bbup before running this script."
}

Push-Location $circuitDir
try {
  nargo execute
  bb prove -b ".\target\payroll_sum.json" -w ".\target\payroll_sum.gz" --write_vk -o target
  bb verify -p ".\target\proof" -k ".\target\vk"
}
finally {
  Pop-Location
}
