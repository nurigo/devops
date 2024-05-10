output "load_balancer_controller_irsa_role_arn" {
  value = module.load_balancer_controller_irsa_role.iam_role_arn
}

output "external_dns_irsa_role_arn" {
  value = module.external_dns_irsa_role.iam_role_arn
}

output "ebs_csi_irsa_role_arn" {
  value = module.ebs_csi_irsa_role.iam_role_arn
}