# 1. IAM Role cho EKS Cluster (Quyền để AWS quản lý Cluster)
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = "uit-devops-eks"
  cluster_version = "1.27"

  # Cho phép truy cập công cộng để nhóm dễ dàng quản lý bằng kubectl từ máy nhà
  cluster_endpoint_public_access  = true

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets

  # Cấu hình Managed Node Groups (Các máy chủ chạy Microservices)
  eks_managed_node_groups = {
    self_healing_nodes = {
      min_size     = 2  # Luôn duy trì ít nhất 2 node để chịu lỗi
      max_size     = 4
      desired_size = 2

      instance_types = ["t3.medium"] # Cấu hình vừa đủ cho đồ án sinh viên
      capacity_type  = "ON_DEMAND"
    }
  }

  tags = {
    Environment = "dev"
    Project     = "self-healing-system"
  }
}
