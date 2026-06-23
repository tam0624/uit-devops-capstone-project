terraform {
  required_providers {
    kind = {
      source  = "tehcyx/kind"
      version = "~> 0.4.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.12.0"
    }
  }
}

provider "kind" {}

# 1. Dựng cụm Kubernetes Local
resource "kind_cluster" "local_k8s" {
  name           = "thesis-local-cluster"
  wait_for_ready = true

  kind_config {
    kind        = "Cluster"
    apiVersion  = "kind.x-k8s.io/v1alpha4"

    node {
      role = "control-plane"
      # Cấu hình Port-mapping cho Nginx Ingress trên Kind
      kubeadm_config_patches = [
        "kind: InitConfiguration\nnodeRegistration:\n  kubeletExtraArgs:\n    node-labels: \"ingress-ready=true\"\n"
      ]
      extra_port_mappings {
        container_port = 80
        host_port      = 80
        protocol       = "TCP"
      }
      extra_port_mappings {
        container_port = 443
        host_port      = 443
        protocol       = "TCP"
      }
    }
    node {
      role = "worker"
    }
    node {
      role = "worker"
    }
  }
}

# Provider kết nối Helm vào cụm Kind vừa tạo
provider "helm" {
  kubernetes {
    config_path = kind_cluster.local_k8s.kubeconfig_path
  }
}

# 2. Tự động cài đặt Nginx Ingress Controller
resource "helm_release" "nginx_ingress" {
  depends_on       = [kind_cluster.local_k8s]
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "ingress-nginx"
  create_namespace = true
  
  set {
    name  = "controller.hostNetwork"
    value = "true"
  }
}

# 3. Tự động cài đặt ArgoCD lõi
resource "helm_release" "argocd" {
  depends_on       = [kind_cluster.local_k8s]
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true
}