terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Sử dụng phiên bản AWS provider mới nhất
    }
  }
}

provider "aws" {
  region = "ap-southeast-1" # Vùng Singapore mà bạn đã cấu hình trong aws configure
}
