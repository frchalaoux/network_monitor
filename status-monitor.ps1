$pidFile = ".monitor.pid"
if (Test-Path $pidFile) {
    $pid = Get-Content $pidFile
    if ($pid -match '^\d+$') {
        try {
            $proc = Get-Process -Id $pid -ErrorAction Stop
            Write-Host "✅ Monitoring actif (PID $pid)"
        } catch {
            Write-Host "⚠️ PID $pid mort. Supprimez .monitor.pid manuellement si nécessaire."
        }
    } else {
        Write-Host "⚠️ PID invalide trouvé dans .monitor.pid."
    }
} else {
    Write-Host "ℹ️ Aucun fichier .monitor.pid trouvé (monitoring non lancé ?)"
}
