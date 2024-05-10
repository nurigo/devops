module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.21.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  cluster_encryption_config = {}
  create_cloudwatch_log_group = false

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnets

  manage_aws_auth_configmap = true

  eks_managed_node_groups = {
    demo = {
      name            = "nurigo-testbed-node"
      use_name_prefix = true

      subnet_ids = var.private_subnets

      min_size     = 1
      max_size     = 2
      desired_size = 2

      ami_id                     = data.aws_ami.demo_eks_ami.id
      enable_bootstrap_user_data = true

      # capacity_type  = "ON_DEMAND"
      capacity_type  = "SPOT"
      instance_types = ["t3.medium"]

      create_iam_role          = true
      iam_role_name            = "nurigo-testbed-ng-role"
      iam_role_use_name_prefix = true
      iam_role_additional_policies = {
        AmazonEBSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
        AmazonEC2ContainerRegistryFullAccess = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
      }
    }
  }
}