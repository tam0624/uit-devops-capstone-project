Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "   KHOI TAO HE THONG DEVOPS - ONLINE BOUTIQUE" -ForegroundColor Green
Write-Host "==================================================" -ForegroundColor Cyan

Write-Host "`n[1/4] Dung cum Kubernetes (Kind) bang Terraform..." -ForegroundColor Yellow
terraform init
terraform apply -auto-approve

Write-Host "`n[2/4] Cai dat API Gateway (Nginx Ingress)..." -ForegroundColor Yellow
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
Write-Host "Dang cho Nginx khoi dong..." 
Start-Sleep -Seconds 15

Write-Host "`n[3/4] Cai dat Trai tim GitOps (ArgoCD)..." -ForegroundColor Yellow
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml --server-side
Write-Host "Dang cho ArgoCD khoi dong..."
Start-Sleep -Seconds 15

Write-Host "`n[4/4] Kich hoat App of Apps (Trien khai toan bo Microservices)..." -ForegroundColor Yellow
kubectl apply -f ..\..\k8s-manifests\argocd\argocd-apps.yaml

Write-Host "`n==================================================" -ForegroundColor Cyan
Write-Host " HOAN TAT BANG 1 CLICK! HE THONG DANG DUOC DUNG LEN" -ForegroundColor Green
Write-Host "==================================================" -ForegroundColor Cyan