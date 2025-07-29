# 📡 Network Monitor — Installation rapide

## 📝 Description
`Network Monitor` est un outil Python CLI pour surveiller la connectivité réseau (internet et local)  
et lancer un **daemon** qui enregistre les coupures dans un fichier de log.  

Il inclut deux scripts d’installation rapides :
- **`install.sh`** → pour **Linux**, **macOS** et **Windows avec Git Bash**
- **`install.ps1`** → pour **Windows natif** (PowerShell)

---

## 🚀 Installation rapide

| Système | Script à exécuter |
|---------|------------------|
| **Linux / macOS / Git Bash Windows** | `./install.sh` |
| **Windows natif (PowerShell)** | `.\install.ps1` |

---

## 📜 Détails

### 🔹 **Linux / macOS / Git Bash**
```bash
# Donner les droits d'exécution
chmod +x install.sh

# Lancer l'installation
./install.sh
```
Ce script :
1. Installe **just** si nécessaire.
2. Installe **uv** si nécessaire.
3. Crée un environnement virtuel Python Astral 3.12.
4. Installe les dépendances :
   - `typer[all]`
   - `httpx`
   - `psutil`
   - `pytest`
5. Initialise le projet avec `uv init`.

---

### 🔹 **Windows natif (PowerShell)**
```powershell
# Autoriser temporairement l'exécution de scripts
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

# Lancer l'installation
.\install.ps1
```
Ce script :
1. Installe **just** si nécessaire.
2. Installe **uv** si nécessaire.
3. Crée un environnement virtuel Python Astral 3.12.
4. Installe les dépendances (`typer[all]`, `httpx`, `psutil`, `pytest`).
5. Initialise le projet avec `uv init`.

---

## ✅ Après installation

Vous pouvez utiliser :
- Sous **Linux / macOS / Git Bash** :
```bash
just monitor         # Lance le daemon
just status-monitor  # Vérifie son état
just stop-monitor    # Arrête le daemon
```

- Sous **Windows natif** :
```powershell
.\monitor.ps1
.\status-monitor.ps1
.\stop-monitor.ps1
```
