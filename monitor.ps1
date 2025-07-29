$pidFile = ".monitor.pid"
if (Test-Path $pidFile) {
    $pid = Get-Content $pidFile
    Write-Host "⚠️ Monitoring déjà actif avec PID: $pid"
} else {
    Start-Process -NoNewWindow -FilePath ".\.venv\Scripts\python.exe" -ArgumentList "main.py", "monitor"
    Start-Sleep -Seconds 1
    $proc = Get-Process python | Sort-Object StartTime -Descending | Select-Object -First 1
    $proc.Id | Out-File -Encoding ascii $pidFile
    Write-Host "✅ Monitoring lancé avec PID: $($proc.Id)"
}
