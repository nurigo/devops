variable "cluster_endpoint" {
    type = string
}
variable "cluster_certificate_authority_data" {
    type = string
}
variable "cluster_name" {
    type = string
}

variable "load_balancer_controller_irsa_role_arn" {
  type = string
}

variable "external_dns_irsa_role_arn" {
  type = string
}