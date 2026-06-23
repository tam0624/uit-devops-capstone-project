Write-Host "==================================================" -ForegroundColor Red
Write-Host "   KICH HOAT QUY TRINH HUY DIET (DEEP NUKE) HE THONG" -ForegroundColor Yellow
Write-Host "==================================================" -ForegroundColor Red

Write-Host "`n[1/3] Dang huy diet cum Kubernetes va tat ca ung dung ben trong..." -ForegroundColor Yellow
terraform destroy -auto-approve

Write-Host "`n[2/3] Xoa bo cac container ranh roi (Neu bi ket)..." -ForegroundColor Yellow
docker rm -f thesis-local-cluster-control-plane thesis-local-cluster-worker thesis-local-cluster-worker2 2>$null

Write-Host "`n[3/3] Don dep sach se file rac cua Terraform..." -ForegroundColor Yellow
$filesToDelete = @(
    "thesis-local-cluster-config",
    "terraform.tfstate",
    "terraform.tfstate.backup",
    ".terraform.lock.hcl"
)

foreach ($file in $filesToDelete) {
    if (Test-Path $file) { 
        Remove-Item $file -Force 
        Write-Host " - Da xoa $file" -ForegroundColor DarkGray
    }
}

Write-Host "`n==================================================" -ForegroundColor Cyan
Write-Host " HOAN TAT! HE THONG DA DUOC DON DEP SACH SE TUNG BYTE." -ForegroundColor Green
Write-Host " Ban co the chay .\deploy.ps1 de bat dau lai tu dau." -ForegroundColor White
Write-Host "==================================================" -ForegroundColor Cyan
