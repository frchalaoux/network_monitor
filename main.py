# main.py

import typer
import subprocess
import httpx
import socket
from typing import Optional, Tuple
import psutil
import ipaddress
import time, datetime

app = typer.Typer(help="Outils de diagnostic réseau")


def ping_host(host: str, count: int = 1, timeout: int = 1) -> bool:
    """Teste la connectivité réseau avec un hôte via ping"""
    try:
        result = subprocess.run(
            ["ping", "-c", str(count), "-W", str(timeout), host],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )
        return result.returncode == 0
    except Exception:
        return False


def get_public_ip(timeout: float = 3.0) -> Optional[str]:
    """Tente de récupérer l'adresse IP publique"""
    try:
        response = httpx.get("https://api.ipify.org", timeout=timeout)
        response.raise_for_status()
        return response.text.strip()
    except httpx.HTTPError:
        return None


def get_local_ip() -> Optional[str]:
    """Récupère l'adresse IP locale de la machine"""
    try:
        hostname = socket.gethostname()
        local_ip = socket.gethostbyname(hostname)
        return local_ip
    except Exception:
        return None


@app.command()
def internet() -> None:
    """Vérifie la connectivité internet et affiche l'IP publique"""
    typer.echo("🔍 Test de connectivité internet...")

    if ping_host("1.1.1.1"):
        typer.secho("✅ Connectivité internet : OK", fg=typer.colors.GREEN)
    else:
        typer.secho("❌ Connectivité internet : ÉCHEC", fg=typer.colors.RED)

    public_ip = get_public_ip()
    if public_ip:
        typer.echo(f"🌐 Adresse IP publique : {public_ip}")
    else:
        typer.echo("🌐 Impossible de récupérer l'IP publique.")


@app.command()
def local() -> None:
    """
    Vérifie la connexion au réseau local du voisin.
    Détecte automatiquement la passerelle, l’IP locale et le réseau.
    """
    result = detect_gateway_info()
    if result is None:
        typer.secho("❌ Impossible de détecter le réseau local actif.", fg=typer.colors.RED)
        return

    gateway, network, local_ip = result

    typer.echo(f"📡 Réseau détecté : {network}")
    typer.echo(f"🏠 Passerelle probable : {gateway}")

    if ping_host(gateway):
        typer.secho("✅ Connecté au réseau local du voisin", fg=typer.colors.GREEN)
    else:
        typer.secho("❌ Impossible d’atteindre la passerelle détectée", fg=typer.colors.RED)

    typer.echo(f"💻 Adresse IP locale : {local_ip}")



def detect_gateway_info() -> Optional[Tuple[str, str, str]]:
    """
    Retourne (passerelle probable, réseau local CIDR, IP locale)
    """
    for interface, stats in psutil.net_if_stats().items():
        if not stats.isup or interface.lower().startswith("lo"):
            continue

        addrs = psutil.net_if_addrs().get(interface, [])
        for addr in addrs:
            if addr.family.name == "AF_INET":
                try:
                    ip_iface = ipaddress.IPv4Interface(f"{addr.address}/{addr.netmask}")
                    gateway = str(ip_iface.network.network_address + 1)
                    return gateway, str(ip_iface.network), addr.address
                except Exception:
                    continue
    return None

@app.command()
def monitor(interval: int = 15) -> None:
    """
    Lance un monitoring réseau en continu (log fichier)
    """
    log_file = "network_monitor.log"

    def log(msg: str) -> None:
        timestamp = datetime.datetime.now().isoformat()
        with open(log_file, "a") as f:
            f.write(f"[{timestamp}] {msg}\n")

    typer.echo(f"📡 Monitoring démarré (intervalle {interval}s)... Appuyez sur Ctrl+C pour arrêter.")
    try:
        while True:
            ok_local = ping_host("192.168.1.1")
            ok_internet = ping_host("1.1.1.1")

            if not ok_local:
                log("❌ Réseau local (voisin) INDISPONIBLE")
            if not ok_internet:
                log("❌ Internet INDISPONIBLE")

            if ok_local and ok_internet:
                log("✅ Réseau OK")

            time.sleep(interval)
    except KeyboardInterrupt:
        log("🛑 Monitoring interrompu manuellement")
        typer.echo("🛑 Surveillance arrêtée.")


if __name__ == "__main__":
    app()
