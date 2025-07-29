#!/bin/bash
set -e

echo "🔧 Vérification de just..."
if ! command -v just &> /dev/null; then
    echo "📦 Installation de just..."
    curl -LsSf https://just.systems/install.sh | bash -s -- --to ~/.local/bin
    export PATH="$HOME/.local/bin:$PATH"
fi

echo "🧰 Vérification de uv..."
if ! command -v uv &> /dev/null; then
    echo "📦 Installation de uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    export PATH="$HOME/.local/bin:$PATH"
fi

echo "🐍 Création de l'environnement virtuel avec Python 3.12 d'Astral..."
uv venv --python 3.12

echo "🚀 Lancement de l'installation via just..."
just install
