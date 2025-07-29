# 📡 Network Monitor — Installation & Utilisation

## 📝 Description
`Network Monitor` est un outil Python en ligne de commande permettant :
- De vérifier la connectivité Internet et locale.
- De surveiller en continu l'état du réseau.
- De lancer un **daemon** (processus en arrière-plan) qui journalise les coupures.
- De gérer facilement ce daemon avec `just` sous **Linux / macOS / Git Bash** ou avec **PowerShell** sous Windows natif.

---

## 1️⃣ Installation

### **Prérequis**
- **Python Astral** (géré via [`uv`](https://astral.sh/uv/))
- [`just`](https://just.systems) — gestionnaire de commandes
- `pip` géré par `uv`
- Accès à Internet

---

### **Linux / macOS**
```bash
# Installer just si absent
curl -sSL https://just.systems/install.sh | bash -s -- --to ~/.local/bin
export PATH="$HOME/.local/bin:$PATH"

# Installer uv si absent
curl -LsSf https://astral.sh/uv/install.sh | sh
export PATH="$HOME/.local/bin:$PATH"

# Créer environnement virtuel Python Astral 3.12
uv venv --python 3.12

# Installer dépendances du projet
uv pip install --upgrade pip
uv init --name network_monitor
uv add typer[all] httpx pytest psutil
```

---

### **Windows — méthode recommandée : Git Bash**
1. Installer **[Git pour Windows](https://git-scm.com/download/win)**.
2. Ouvrir **Git Bash**.
3. Suivre la procédure **Linux / macOS** ci-dessus dans Git Bash.

---

### **Windows — méthode native PowerShell**
1. Installer [`uv`](https://astral.sh/uv/) :
```powershell
irm https://astral.sh/uv/install.ps1 | iex
```
2. Installer Python Astral :
```powershell
uv venv --python 3.12
```
3. Installer dépendances :
```powershell
uv pip install --upgrade pip
uv init --name network_monitor
uv add typer[all] httpx pytest psutil
```
4. Utiliser **monitor.ps1**, **stop-monitor.ps1** et **status-monitor.ps1** pour gérer le daemon.

---

## 2️⃣ Utilisation — Linux / macOS / Git Bash

| Commande `just` | Description |
|-----------------|-------------|
| `just run internet` | Vérifie la connectivité Internet et affiche l’IP publique. |
| `just run local` | Vérifie la connexion au réseau du voisin (passerelle auto-détectée). |
| `just monitor` | Lance le daemon en arrière-plan qui journalise l’état réseau. |
| `just stop-monitor` | Arrête le daemon et supprime `.monitor.pid`. |
| `just status-monitor` | Affiche l’état actuel du daemon (actif / inactif). |

📌 **Exemples** :
```bash
just run internet
just monitor
just status-monitor
just stop-monitor
```

---

## 3️⃣ Utilisation — Windows natif (PowerShell)

| Script | Description |
|--------|-------------|
| `monitor.ps1` | Lance le monitoring réseau en arrière-plan. |
| `stop-monitor.ps1` | Arrête le monitoring réseau. |
| `status-monitor.ps1` | Vérifie l’état du monitoring. |

📌 **Exemples** :
```powershell
.\monitor.ps1
.\status-monitor.ps1
.\stop-monitor.ps1
```

---

## 4️⃣ Fichiers importants

- **`Justfile`** → Gestion des commandes sous Linux / macOS / Git Bash.
- **`monitor.ps1`** → Lance le daemon sous Windows natif.
- **`stop-monitor.ps1`** → Arrête le daemon sous Windows natif.
- **`status-monitor.ps1`** → Vérifie l’état du daemon sous Windows natif.
- **`install.ps1`** → Installation du projet sous Windows natif.
- **`main.py`** → CLI Python avec commandes `internet`, `local`, `monitor`.
- **`.monitor.pid`** → Contient le PID du daemon actif.
- **`network_monitor.log`** → Journal des événements réseau.

---

## 5️⃣ Notes
- Le monitoring écrit dans `network_monitor.log`.
- `just monitor` crée `.monitor.pid` pour savoir quel processus arrêter.
- **Ne pas** utiliser `just run monitor` si vous voulez lancer le daemon.
- Sous Windows, Git Bash est recommandé pour bénéficier de toutes les commandes `just`.
