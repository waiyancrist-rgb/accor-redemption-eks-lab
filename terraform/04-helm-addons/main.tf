# 1. Create a dedicated namespace for custom addons
resource "kubernetes_namespace" "ingress_ns" {
  metadata {
    name = "ingress-routing"
  }
}

# 2. Deploy Metrics Server (Allows 'kubectl top' commands and scaling metrics)
resource "helm_release" "metrics_server" {
  name       = "metrics-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  version    = "3.12.1"
  namespace  = "kube-system"

  set {
    name  = "metrics.enabled"
    value = "true"
  }
}


# 3. Deploy NGINX Ingress Controller (Creates your public cloud entrypoint)
resource "helm_release" "nginx_ingress" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.10.1"
  namespace  = kubernetes_namespace.ingress_ns.metadata[0].name
  timeout    = 900  # Keep 15-minute timeout to give AWS plenty of time to build the NLB

  # Change service type back to LoadBalancer
  set {
    name  = "controller.service.type"
    value = "LoadBalancer"
  }

  # Direct Kubernetes to provision an AWS Network Load Balancer (NLB)
  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-type"
    value = "nlb"
  }
}
