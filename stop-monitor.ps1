$pidFile = ".monitor.pid"

if (Test-Path $pidFile) {
    $pid = Get-Content $pidFile
    if ($pid -match '^\d+$') {
        if (Get-Process -Id $pid -ErrorAction SilentlyContinue) {
            Stop-Process -Id $pid -Force
            Write-Host "🛑 Monitoring arrêté."
        } else {
            Write-Host "⚠️ PID $pid introuvable (probablement déjà arrêté)."
        }
        Remove-Item $pidFile
    } else {
        Write-Host "⚠️ PID invalide dans .monitor.pid. Suppression forcée."
        Remove-Item $pidFile
    }
} else {
    Write-Host "⚠️ Aucun monitoring actif."
}
