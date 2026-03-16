module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name = "uit-devops-vpc"
  cidr = "10.0.0.0/16"

  # Sử dụng 2 vùng sẵn sàng (Availability Zones) để đảm bảo tính chịu lỗi
  azs             = ["ap-southeast-1a", "ap-southeast-1b"]
  
  # Subnet cho các dịch vụ công cộng (Load Balancer)
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  
  # Subnet cho các Worker Nodes (Microservices chạy ở đây cho bảo mật)
  private_subnets = ["10.0.10.0/24", "10.0.11.0/24"]

  enable_nat_gateway = true # Cho phép các máy trong mạng riêng tải được dữ liệu từ Internet
  single_nat_gateway = true # Dùng 1 cái để tiết kiệm chi phí cho đồ án

  tags = {
    Project     = "Self-healing-Microservices"
    Environment = "Dev"
  }
}
