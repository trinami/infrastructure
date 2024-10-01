data "sops_file" "secrets" {
  source_file = "secrets.enc.yaml"
}

data "external" "env" {
  program = ["${path.module}/env.sh"]
}

data "kubernetes_namespace" "cert_manager" {
  metadata {
    name = "cert-manager"
  }
}

data "kubernetes_namespace" "nginx" {
  metadata {
    name = "nginx"
  }
}
