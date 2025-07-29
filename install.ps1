$ErrorActionPreference = "Stop"
Write-Host "🚀 Installation Network Monitor (Windows)..."
if (-not (Get-Command just -ErrorAction SilentlyContinue)) {
    Write-Host "📦 Installation de just..."
    Invoke-WebRequest -Uri https://just.systems/install.ps1 -UseBasicParsing | Invoke-Expression
    $env:PATH += ";$HOME\.cargo\bin;$HOME\.local\bin"
}
if (-not (Get-Command uv -ErrorAction SilentlyContinue)) {
    Write-Host "📦 Installation de uv..."
    Invoke-WebRequest https://astral.sh/uv/install.ps1 -UseBasicParsing | Invoke-Expression
    $env:PATH += ";$HOME\.local\bin"
}
Write-Host "🐍 Création de l'environnement Python 3.12..."
uv venv --python 3.12
Write-Host "📦 Installation des dépendances Python..."
uv pip install --upgrade pip
uv init --name network_monitor
uv add typer[all] httpx psutil pytest
Write-Host "✅ Installation terminée."
