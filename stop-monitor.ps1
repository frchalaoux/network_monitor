$pidFile = ".monitor.pid"
if (Test-Path $pidFile) {
    $pid = Get-Content $pidFile
    if ($pid -match '^\d+$') {
        try {
            Stop-Process -Id $pid -Force
            Remove-Item $pidFile
            Write-Host "🛑 Monitoring arrêté."
        } catch {
            Write-Host "⚠️ Impossible d'arrêter le processus $pid."
            Remove-Item $pidFile
        }
    } else {
        Write-Host "⚠️ PID invalide trouvé dans .monitor.pid. Suppression forcée."
        Remove-Item $pidFile
    }
} else {
    Write-Host "⚠️ Aucun monitoring actif."
}
