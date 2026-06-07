module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

# checkov:skip=CKV_TF_1: Sử dụng version tag cố định đã được nhóm đánh giá là đủ an toàn cho đồ án.	

  cluster_name    = "uit-devops-eks"
  cluster_version = "1.30"

  vpc_id                         = module.vpc.vpc_id
  subnet_ids                     = module.vpc.private_subnets
  cluster_endpoint_public_access = true

  # PHẦN QUAN TRỌNG NHẤT: Tự động cấp quyền cho terraform-bot
  enable_cluster_creator_admin_permissions = true

  eks_managed_node_groups = {
    main_v2 = {
      min_size     = 2
      max_size     = 4
      desired_size = 3

      instance_types = ["t3.small"] # QUAY LẠI T3.SMALL
      capacity_type  = "ON_DEMAND"       # Rẻ hơn 70% và giúp báo cáo tính năng Self-healing
      ami_type = "AL2_x86_64"
      bootstrap_extra_args = "--use-max-pods false --kubelet-extra-args '--max-pods=110'"
      labels = {
        Environment = "dev"
        Project     = "online-boutique"
      }
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}
