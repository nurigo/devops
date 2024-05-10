resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  namespace        = "argocd"
  chart            = "argo-cd"
  version          = "6.7.18"
  create_namespace = true

  values = [ "${templatefile("./argocd_config/helm/values.yaml", {
    LOADBALANCER_NAME = "argocd-loadbalancer"
    GLOBAL_HOST_NAME = var.global_host_name
    INGRESS_ENABLED = true
    INGRESS_CONTROLLER = "aws"
    INGRESS_CLASS_NAME = "alb"
    ACM_CERTIFICATE_ARN = var.acm_certificate_arn
  })}" ]
  
}
