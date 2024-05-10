resource "helm_release" "alb" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  namespace = "kube-system"
  chart      = "aws-load-balancer-controller"
  version = "1.7.2"

  set {
    name  = "serviceAccount.create"
    value = "true"
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = var.load_balancer_controller_irsa_role_arn
  }

  set {
    name  = "clusterName"
    value = var.cluster_name
  }
}