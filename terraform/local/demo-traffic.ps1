Write-Host "Traffic Generator..." -ForegroundColor Cyan


kubectl run traffic-generator --image=busybox --restart=Never -n default -- /bin/sh -c "while true; do wget -qO- http://discount-service:8000; wget -qO- http://loyalty-service:8080; sleep 1; done"

Write-Host "`n Traffic Generated!" -ForegroundColor Green

Write-Host "Dung 2 lenh sau de xem log cua cac service:" -ForegroundColor Yellow

Write-Host "1. kubectl logs -f deployment/discount-service -n default" -ForegroundColor Yellow
Write-Host "2. kubectl logs -f deployment/loyalty-service -n default" -ForegroundColor Yellow

Write-Host "`n(Khi demo xong, chay lenh nay de tat generator: kubectl delete pod traffic-generator -n default)" -ForegroundColor DarkGray
