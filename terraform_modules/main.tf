
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.26.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.24.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.12.1"
    }
  }
  backend "s3" {}
}

provider "aws" {}

module "nurigo_testbed_vpc" {
  source   = "./modules/01_eks-vpc"
  vpc_name = "testbed-cluster/VPC"
  vpc_cidr = "10.0.0.0/16"
}

module "nurigo_testbed_eks" {
  depend_on = module.nurigo_testbed_vpc.vpc_id
  source          = "./modules/02_eks-clsuter"
  cluster_name    = "apple-testbed-eksCluster"
  cluster_version = "1.29"
  vpc_id          = module.nurigo_testbed_vpc.vpc_id
  private_subnets = module.nurigo_testbed_vpc.private_subnets
}

module "nurigo_testbed_eks_irsa" {
  source                = "./modules/03_eks-irsa"
  oidc_provider_arn     = module.nurigo_testbed_eks.oidc_provider_arn
  cluster_name          = module.nurigo_testbed_eks.cluster_name
  secret_hosted_zone_id = var.secret_hosted_zone_id
}

module "nurigo_testbed_eks_network" {
  source                                 = "./modules/04_eks-network"
  cluster_endpoint                       = module.nurigo_testbed_eks.cluster_endpoint
  cluster_certificate_authority_data     = module.nurigo_testbed_eks.cluster_certificate_authority_data
  cluster_name                           = module.nurigo_testbed_eks.cluster_name
  load_balancer_controller_irsa_role_arn = module.nurigo_testbed_eks_irsa.load_balancer_controller_irsa_role_arn
  external_dns_irsa_role_arn             = module.nurigo_testbed_eks_irsa.external_dns_irsa_role_arn
}

module "nurigo_testbed_eks_csi_driver" {
  source = "./modules/06_eks-addon"
  ebs_csi_sa_role_arn = module.nurigo_testbed_eks_irsa.ebs_csi_irsa_role_arn
  csi_driver_version = "v1.29.1-eksbuild.1"
  cluster_name = module.nurigo_testbed_eks.cluster_name
}

module "nurigo_testbed_eks_argocd" {
  source                             = "./modules/05_eks_argocd"
  cluster_endpoint                   = module.nurigo_testbed_eks.cluster_endpoint
  cluster_certificate_authority_data = module.nurigo_testbed_eks.cluster_certificate_authority_data
  cluster_name                       = module.nurigo_testbed_eks.cluster_name
  acm_certificate_arn                = var.acm_certificate_arn
  global_host_name                   = "argocd.solapi.net"
}

module "nurigo_testbed_eks_ecr" {
  source = "./modules/07_eks_ecr"
  ecr_repo_name = "nurigo-testbed-container-registry"
}


