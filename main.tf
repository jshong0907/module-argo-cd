provider "kubernetes" {
  cluster_ca_certificate = base64decode(var.kubernetes_cluster_cert_data)
  host                   = var.kubernetes_cluster_endpoint
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", var.kubernetes_cluster_name]
  }
}

provider "helm" {
  kubernetes {
    cluster_ca_certificate = base64decode(var.kubernetes_cluster_cert_data)
    host                   = var.kubernetes_cluster_endpoint
    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", var.kubernetes_cluster_name]
    }
  }
}

resource "kubernetes_namespace" "argo-ns" {
  metadata {
    name = "argocd"
  }
}

resource "helm_release" "argocd" {
  name       = "argocd"
  chart      = "argo"
  repository = "https://argoproj.github.io/argo-helm"
  namespace  = "argocd"
  version    = "3.32.1"
}
