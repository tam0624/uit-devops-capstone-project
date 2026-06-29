# ============================================================
#                   DEMO GUI ALERT TELEGRAM
#   powershell -ExecutionPolicy Bypass -File .\demo-alert.ps1
# ============================================================

$Namespace = "monitoring"
$AlertmanagerSvc = "prometheus-monitoring-stac-alertmanager"
$AlertmanagerUrl = "http://$AlertmanagerSvc.$Namespace.svc:9093/api/v2/alerts"

Write-Host "BUOC 1: Chuan bi payload (dung API v2, API v1 da bi go bo tu Alertmanager 0.27+)" -ForegroundColor Cyan

$startsAt = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ss.fffZ")

# API v2 yeu cau dung schema: labels, annotations, startsAt
$jsonPayload = @"
[{"labels":{"alertname":"HighCPUUsage_Demo","instance":"Node-Local-Demo","severity":"critical"},"annotations":{"summary":"[DEMO REAL-TIME] CPU cua may chu Node-Local-Demo da cham nguong 99%!"},"startsAt":"$startsAt"}]
"@

Write-Host "BUOC 2: Gui alert toi Alertmanager qua pod tam ($AlertmanagerUrl)" -ForegroundColor Cyan


$curlOutput = $jsonPayload | kubectl run trigger-alert --image=curlimages/curl --restart=Never -n $Namespace --rm -i -- `
  curl -s -w "`nHTTP_STATUS:%{http_code}" -X POST -H "Content-Type: application/json" -d "@-" $AlertmanagerUrl

if ($LASTEXITCODE -ne 0) {
    Write-Host "LOI: kubectl run / pod curl chay khong thanh cong (exit code $LASTEXITCODE)." -ForegroundColor Red
    Write-Host "Kiem tra: pod co keo duoc image curlimages/curl khong, namespace '$Namespace' co ton tai khong." -ForegroundColor Yellow
    exit 1
}

Write-Host "Output tu curl:" -ForegroundColor DarkGray
Write-Host $curlOutput

$curlOutputStr = $curlOutput | Out-String
if ($curlOutputStr -match "HTTP_STATUS:(\d+)") {
    $statusCode = $matches[1]
    if ($statusCode -eq "200") {
        Write-Host "BUOC 2 OK: Alertmanager tra ve HTTP 200 - alert da duoc nhan." -ForegroundColor Green
    } elseif ($statusCode -eq "410") {
        Write-Host "LOI 410 Gone: dang goi nham API v1. Kiem tra lai URL co dung /api/v2/alerts khong." -ForegroundColor Red
        exit 1
    } else {
        Write-Host "LOI: HTTP status $statusCode - Alertmanager tu choi request. Xem body o tren de biet ly do." -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "LOI: khong doc duoc HTTP status tu output (co the pod bi loi truoc khi curl chay)." -ForegroundColor Red
    exit 1
}

Write-Host "BUOC 3: Verify lai bang cach query API xem alert da duoc Alertmanager ghi nhan chua" -ForegroundColor Cyan

$verifyOutput = kubectl run verify-alert --image=curlimages/curl --restart=Never -n $Namespace --rm -i -- `
  curl -s "$AlertmanagerUrl"

if ($verifyOutput -match "HighCPUUsage_Demo") {
    Write-Host "BUOC 3 OK: Alert 'HighCPUUsage_Demo' dang active trong Alertmanager." -ForegroundColor Green
} else {
    Write-Host "CHU Y: khong thay alert trong danh sach active alerts. Co the da duoc xu ly/group roi, hoac route khong khop." -ForegroundColor Yellow
    Write-Host $verifyOutput
}

Write-Host "`nDa gui xong. Neu dien thoai van KHONG nhan duoc Telegram, kiem tra tiep:" -ForegroundColor Magenta
Write-Host "  kubectl logs -n $Namespace -l app.kubernetes.io/name=alertmanager --tail=50  (xem co loi gui telegram_configs khong)" -ForegroundColor White
