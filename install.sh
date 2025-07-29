#!/usr/bin/env bash
set -e

echo "🚀 Installation Network Monitor (Linux / macOS / Git Bash)..."

# --- Vérification et installation de just ---
if ! command -v just &> /dev/null; then
    echo "📦 Installation de just..."
    curl -sSL https://just.systems/install.sh | bash -s -- --to ~/.local/bin
    export PATH="$HOME/.local/bin:$PATH"
else
    echo "✅ just déjà installé."
fi

# --- Vérification et installation de uv ---
if ! command -v uv &> /dev/null; then
    echo "📦 Installation de uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    export PATH="$HOME/.local/bin:$PATH"
else
    echo "✅ uv déjà installé."
fi

# --- Création de l'environnement virtuel Python Astral ---
echo "🐍 Création de l'environnement Python 3.12..."
uv venv --python 3.12

# --- Installation des dépendances ---
echo "📦 Installation des dépendances Python..."
uv pip install --upgrade pip
uv init --name network_monitor
uv add typer[all] httpx psutil pytest

echo "✅ Installation terminée."
echo "ℹ️ Vous pouvez maintenant lancer :"
echo "   - just monitor  (lancer le monitoring en arrière-plan)"
echo "   - just stop-monitor  (arrêter le monitoring)"
echo "   - just status-monitor  (vérifier l'état du monitoring)"
