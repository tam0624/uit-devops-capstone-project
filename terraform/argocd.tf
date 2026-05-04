resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true
  version          = "6.7.11" # Có thể đổi version mới nhất
  
  # Đảm bảo cài sau khi EKS đã tạo xong Node
  depends_on = [module.eks] 
}
