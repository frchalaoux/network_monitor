$pidFile = ".monitor.pid"

if (Test-Path $pidFile) {
    $pid = Get-Content $pidFile
    if ($pid -match '^\d+$') {
        if (Get-Process -Id $pid -ErrorAction SilentlyContinue) {
            Write-Host "✅ Monitoring actif (PID $pid)"
        } else {
            Write-Host "⚠️ PID $pid mort. Supprimez .monitor.pid si nécessaire."
        }
    } else {
        Write-Host "⚠️ PID invalide dans .monitor.pid."
    }
} else {
    Write-Host "ℹ️ Aucun monitoring actif."
}
