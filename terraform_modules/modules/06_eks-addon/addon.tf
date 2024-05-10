resource "aws_eks_addon" "aws_ebs_csi_driver" {
  cluster_name             = var.cluster_name
  addon_name               = "aws-ebs-csi-driver"
  service_account_role_arn = var.ebs_csi_sa_role_arn
  addon_version            = var.csi_driver_version
}