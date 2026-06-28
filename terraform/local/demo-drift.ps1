Write-Host "DRIFT & SELF-HEAL" -ForegroundColor Yellow

Write-Host "`n[1/4] Trang thai Frontend hien tai:" -ForegroundColor Cyan
kubectl get pods -l app=frontend -n online-boutique

Write-Host "`n[2/4] Can thiep thu cong: tang so luong Pod lên 5 (Configuration Drift)..." -ForegroundColor Red
kubectl scale deployment frontend --replicas=5 -n online-boutique
Start-Sleep -Seconds 3 # Dừng 3s để K8s kịp tạo Pod

Write-Host "`n[3/4] Trang thai sau khi bi can thiep:" -ForegroundColor Red
kubectl get pods -l app=frontend -n online-boutique

Write-Host "`n Cho ArgoCD phat hien (OutOfSync) va kich hoat Self-heal... (15 giây)" -ForegroundColor Yellow
Start-Sleep -Seconds 15

Write-Host "`n[4/4] Trang thai sau ArgoCD sua chua:" -ForegroundColor Green
kubectl get pods -l app=frontend -n online-boutique
Write-Host "He thong da on dinh" -ForegroundColor Green
