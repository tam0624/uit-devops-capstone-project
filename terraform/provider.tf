terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Sử dụng phiên bản AWS provider mới nhất
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.12"
    }
  }
  backend "s3" {
    bucket         = "uit-devops-terraform-state-unique" # Tên bucket bạn vừa tạo
    key            = "global/s3/terraform.tfstate"       # Đường dẫn file trong bucket
    region         = "ap-southeast-1"
    use_lockfile   = true                                # Use DynamoDB for state locking
    encrypt        = true                                # Mã hóa file để bảo mật
  }
  
}

provider "aws" {
  region = "ap-southeast-1" # Vùng Singapore 
}
provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
      command     = "aws"
    }
  }
}
