resource "cloudflare_record" "org_root_a" {
  depends_on = [module.kube-hetzner]
  zone_id = data.sops_file.secrets.data["trinami_org_zone_id"]
  name    = "@"
  content   = module.kube-hetzner.ingress_public_ipv4
  type    = "A"
  proxied = false
  allow_overwrite = true
}

resource "cloudflare_record" "org_root_aaaa" {
  depends_on = [module.kube-hetzner]
  zone_id = data.sops_file.secrets.data["trinami_org_zone_id"]
  name    = "@"
  content   = module.kube-hetzner.ingress_public_ipv6
  type    = "AAAA"
  proxied = false
  allow_overwrite = true
}

resource "cloudflare_record" "org_wildcard_a" {
  depends_on = [module.kube-hetzner]
  zone_id = data.sops_file.secrets.data["trinami_org_zone_id"]
  name    = "*"
  content   = module.kube-hetzner.ingress_public_ipv4
  type    = "A"
  proxied = false
  allow_overwrite = true
}

resource "cloudflare_record" "org_wildcard_aaaa" {
  depends_on = [module.kube-hetzner]
  zone_id = data.sops_file.secrets.data["trinami_org_zone_id"]
  name    = "*"
  content   = module.kube-hetzner.ingress_public_ipv6
  type    = "AAAA"
  proxied = false
  allow_overwrite = true
}

resource "github_repository" "this" {
  depends_on = [module.kube-hetzner.kubeconfig]

  name        = var.github_repository
  description = var.github_repository
  visibility  = "public"
  auto_init   = true
}

resource "flux_bootstrap_git" "this" {
  depends_on = [github_repository.this]

  embedded_manifests = true
  path               = "flux/clusters"
}

resource "kubernetes_namespace" "cert_manager" {
  depends_on = [flux_bootstrap_git.this]
  count = length(try(data.kubernetes_namespace.cert_manager.metadata[0], [])) > 0 ? 0 : 1

  metadata {
    name = "cert-manager"
  }
}

resource "kubernetes_namespace" "nginx" {
  depends_on = [flux_bootstrap_git.this]
  count = length(try(data.kubernetes_namespace.nginx.metadata[0], [])) > 0 ? 0 : 1

  metadata {
    name = "nginx"
  }
}

resource "kubernetes_secret" "cloudflare_dns" {
  depends_on = [kubernetes_namespace.cert_manager]
  metadata {
    name      = "cloudflare-dns"
    namespace = "cert-manager"
  }

  data = {
    cloudflare-apikey = data.sops_file.secrets.data["cloudflare_api_token_inner_cluster"]
  }

  type = "Opaque"
}

resource "kubernetes_secret" "onion_secret" {
  depends_on = [kubernetes_namespace.nginx]
  metadata {
    name      = "onion-secret"
    namespace = "nginx"
  }

  data = {
    onionAddress   = file("trinamiggfqxmyuyipkol3svqfzecuriywhiqlzcawknhtgivj3wkxad.onion/hostname")
  }

  binary_data = {
    publicKeyFile  = filebase64("trinamiggfqxmyuyipkol3svqfzecuriywhiqlzcawknhtgivj3wkxad.onion/hs_ed25519_public_key")
    privateKeyFile = data.sops_file.secrets.data["onion_key"]
  }     

  type = "Opaque"
}
