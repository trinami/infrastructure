

resource "cloudflare_record" "org_root_a" {
  depends_on = [module.kube-hetzner]
  zone_id = data.sops_file.secrets.data["trinami_org_zone_id"]
  name    = "@"
  value   = module.kube-hetzner.ingress_public_ipv4
  type    = "A"
  proxied = false
  allow_overwrite = true
}

resource "cloudflare_record" "org_root_aaaa" {
  depends_on = [module.kube-hetzner]
  zone_id = data.sops_file.secrets.data["trinami_org_zone_id"]
  name    = "@"
  value   = module.kube-hetzner.ingress_public_ipv6
  type    = "AAAA"
  proxied = false
  allow_overwrite = true
}

resource "cloudflare_record" "org_wildcard_a" {
  depends_on = [module.kube-hetzner]
  zone_id = data.sops_file.secrets.data["trinami_org_zone_id"]
  name    = "*"
  value   = module.kube-hetzner.ingress_public_ipv4
  type    = "A"
  proxied = false
  allow_overwrite = true
}

resource "cloudflare_record" "org_wildcard_aaaa" {
  depends_on = [module.kube-hetzner]
  zone_id = data.sops_file.secrets.data["trinami_org_zone_id"]
  name    = "*"
  value   = module.kube-hetzner.ingress_public_ipv6
  type    = "AAAA"
  proxied = false
  allow_overwrite = true
}

resource "local_file" "output_file" {
  depends_on = [module.kube-hetzner]

  filename = "${path.home}/.kube/config"
  content  = output.kubeconfig.value
}

resource "github_repository" "trinami" {
  name        = var.github_repository
  description = var.github_repository
  visibility  = "public"
  auto_init   = true
}

resource "flux_bootstrap_git" "trinami" {
  depends_on = [github_repository.trinami]

  embedded_manifests = true
  path               = "clusters/base"
}
