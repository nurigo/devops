variable "cluster_endpoint" {
    type = string
}
variable "cluster_certificate_authority_data" {
    type = string
}
variable "cluster_name" {
    type = string
}

variable "acm_certificate_arn" {
  type = string
}

variable "global_host_name" {
  type = string
}