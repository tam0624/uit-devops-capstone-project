Write-Host "Traffic Generator..." -ForegroundColor Cyan

# Tạo một pod chạy ngầm, bắn request liên tục vào 2 service nội bộ
kubectl run traffic-generator --image=busybox --restart=Never -n online-boutique -- /bin/sh -c "while true; do wget -qO- http://discount-service:8000; wget -qO- http://loyalty-service:8080; sleep 1; done"

Write-Host "`n Traffic Generated!" -ForegroundColor Green
Write-Host "1. kubectl logs -f deployment/discount-service -n online-boutique" -ForegroundColor Yellow
Write-Host "2. kubectl logs -f deployment/loyalty-service -n online-boutique" -ForegroundColor Yellow

Write-Host "`n(Khi demo xong, chạy lệnh này để tắt tải: kubectl delete pod traffic-generator -n online-boutique)" -ForegroundColor DarkGray
