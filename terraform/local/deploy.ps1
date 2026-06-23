Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "   KHOI TAO HE THONG DEVOPS - ONLINE BOUTIQUE V4" -ForegroundColor Green
Write-Host "==================================================" -ForegroundColor Cyan

# KHOA PHIEN BAN (Version Pinning)
$NGINX_VER = "v1.10.1"
$CERTGEN_VER = "v1.4.1"
$ARGOCD_VER = "v2.11.2"

Write-Host "`n[1/7] Dung cum Kubernetes (Kind) bang Terraform..." -ForegroundColor Yellow
terraform init
terraform apply -auto-approve

Write-Host "`n[2/7] Tai mien dich cac Image nang nhat..." -ForegroundColor Yellow
docker pull registry.k8s.io/ingress-nginx/controller:$NGINX_VER
docker pull registry.k8s.io/ingress-nginx/kube-webhook-certgen:$CERTGEN_VER
docker pull quay.io/argoproj/argocd:$ARGOCD_VER

Write-Host "`n[3/7] Bom truc tiep Image vao cum Local..." -ForegroundColor Yellow
kind load docker-image registry.k8s.io/ingress-nginx/controller:$NGINX_VER --name thesis-local-cluster
kind load docker-image registry.k8s.io/ingress-nginx/kube-webhook-certgen:$CERTGEN_VER --name thesis-local-cluster
kind load docker-image quay.io/argoproj/argocd:$ARGOCD_VER --name thesis-local-cluster

Write-Host "`n[4/7] Cai dat API Gateway (Nginx Ingress - Phien ban $NGINX_VER)..." -ForegroundColor Yellow
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-$NGINX_VER/deploy/static/provider/kind/deploy.yaml

Write-Host "Dang cho Nginx khoi dong..." -ForegroundColor Gray
kubectl wait --namespace ingress-nginx --for=condition=ready pod --selector=app.kubernetes.io/component=controller --timeout=600s

Write-Host "`n[5/7] Cai dat GitOps (ArgoCD - Phien ban $ARGOCD_VER)..." -ForegroundColor Yellow
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/$ARGOCD_VER/manifests/install.yaml --server-side --force-conflicts

Write-Host "Dang cho ArgoCD Server khoi dong..." -ForegroundColor Gray
kubectl wait --namespace argocd --for=condition=ready pod --selector=app.kubernetes.io/name=argocd-server --timeout=600s

Write-Host "`n[6/7] Kich hoat App of Apps & Lay Mat khau..." -ForegroundColor Yellow
kubectl apply -f ..\..\k8s-manifests\argocd\argocd-apps.yaml

Start-Sleep -Seconds 5
$ArgoSecret = kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}"
$ClearTextPassword = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($ArgoSecret))

Write-Host "`n[7/7] Tu dong mo Port-Forwarding..." -ForegroundColor Yellow
Write-Host " - Dang mo cua so ngam cho ArgoCD (Port 8080)..." -ForegroundColor Gray
Start-Process powershell -ArgumentList "-NoExit -Command `"title ArgoCD-PortForward; Write-Host 'Dang mo port ArgoCD (Vui long khong tat cua so nay)...' -ForegroundColor Cyan; kubectl port-forward svc/argocd-server -n argocd 8080:443`""

Write-Host " - Dang mo cua so ngam cho Grafana (Port 3000)..." -ForegroundColor Gray
Start-Process powershell -ArgumentList "-NoExit -Command `"title Grafana-PortForward; Write-Host 'Cho ArgoCD keo Grafana ve cum (Co the mat 2-3 phut)...' -ForegroundColor Yellow; while (!(kubectl get svc -n monitoring kube-prometheus-stack-grafana 2>\$null)) { Start-Sleep -Seconds 5 }; Write-Host 'Da tim thay Grafana, dang mo port (Vui long khong tat cua so nay)...' -ForegroundColor Cyan; kubectl port-forward svc/kube-prometheus-stack-grafana -n monitoring 3000:80`""

Write-Host "`n==================================================" -ForegroundColor Cyan
Write-Host " HOAN TAT! HE THONG DA SAN SANG" -ForegroundColor Green
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "`n[ THONG TIN TRUY CAP ]" -ForegroundColor White
Write-Host "1. Online Boutique: " -ForegroundColor Magenta -NoNewline; Write-Host "http://localhost" 
Write-Host "2. ArgoCD UI:       " -ForegroundColor Magenta -NoNewline; Write-Host "https://localhost:8080"
Write-Host "   => Tai khoan:    " -ForegroundColor DarkGray -NoNewline; Write-Host "admin" -ForegroundColor White
Write-Host "   => Mat khau:     " -ForegroundColor DarkGray -NoNewline; Write-Host "$ClearTextPassword" -ForegroundColor Yellow
Write-Host "3. Grafana UI:      " -ForegroundColor Magenta -NoNewline; Write-Host "http://localhost:3000"
Write-Host "   => Tai khoan:    " -ForegroundColor DarkGray -NoNewline; Write-Host "admin" -ForegroundColor White
Write-Host "   => Mat khau:     " -ForegroundColor DarkGray -NoNewline; Write-Host "prom-operator" -ForegroundColor Yellow
Write-Host ""
