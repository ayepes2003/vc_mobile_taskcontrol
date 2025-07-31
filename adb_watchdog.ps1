# Reemplaza esta IP con la IP real de tu tablet
$deviceIP = "192.168.1.44"
$adbPort = "38711"
$interval = 10  # Segundos entre chequeos

Write-Host "Iniciando monitor ADB para $deviceIP : $adbPort"

while ($true) {
    $output = adb devices | Select-String "$deviceIP"

    if (-not $output) {
        Write-Host "$(Get-Date): Dispositivo no conectado. Intentando reconectar..."
        adb connect "$deviceIP`:$adbPort"
    } else {
        Write-Host "$(Get-Date): Dispositivo conectado."
    }

    Start-Sleep -Seconds $interval
}
