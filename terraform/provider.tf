terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Sử dụng phiên bản AWS provider mới nhất
    }
  }
  backend "s3" {
    bucket         = "uit-devops-terraform-state-unique" # Tên bucket bạn vừa tạo
    key            = "global/s3/terraform.tfstate"       # Đường dẫn file trong bucket
    region         = "ap-southeast-1"
    dynamodb_table = "terraform-state-locking"           # Tên table DynamoDB vừa tạo
    encrypt        = true                                # Mã hóa file để bảo mật
  }

}

provider "aws" {
  region = "ap-southeast-1" # Vùng Singapore mà bạn đã cấu hình trong aws configure
}
