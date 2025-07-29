$pidFile = ".monitor.pid"

if (Test-Path $pidFile) {
    $pid = Get-Content $pidFile
    if ($pid -match '^\d+$' -and (Get-Process -Id $pid -ErrorAction SilentlyContinue)) {
        Write-Host "⚠️ Monitoring déjà actif avec PID: $pid"
        exit
    } else {
        Write-Host "⚠️ Fichier PID obsolète, suppression."
        Remove-Item $pidFile
    }
}

Start-Process -NoNewWindow -FilePath ".\\.venv\\Scripts\\python.exe" -ArgumentList "main.py", "monitor"
Start-Sleep -Seconds 1
$proc = Get-Process python | Sort-Object StartTime -Descending | Select-Object -First 1
$proc.Id | Out-File -Encoding ascii $pidFile
Write-Host "✅ Monitoring lancé avec PID: $($proc.Id)"
