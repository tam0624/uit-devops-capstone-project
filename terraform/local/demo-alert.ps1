Write-Host "KICH HOAT ALERT TELEGRAM KHAN CAP..." -ForegroundColor Red

# Khoi du lieu JSON gia lap viec CPU bi qua tai (Dung tieng Viet khong dau de tranh loi Encoding)
$jsonPayload = '[{"labels":{"alertname":"HighCPUUsage_Demo","instance":"Node-Local-Demo","severity":"critical"},"annotations":{"summary":"[DEMO REAL-TIME] CPU cua may chu Node-Local-Demo da cham nguong 99%!"}}]'

# Tao mot pod chay curl de ban API thang vao Alertmanager
kubectl run trigger-alert --image=curlimages/curl --restart=Never -n monitoring --rm -i -- curl -s -X POST -H "Content-Type: application/json" -d $jsonPayload http://prometheus-monitoring-stac-alertmanager.monitoring.svc:9093/api/v1/alerts

Write-Host "`n Da gui tin hieu den Alertmanager! Kiem tra dien thoai ngay." -ForegroundColor Green
