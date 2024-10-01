provider "hcloud" {
  token = data.sops_file.secrets.data["hetzner_api_token"]
}

provider "cloudflare" {
  api_token = data.sops_file.secrets.data["cloudflare_api_token"]
}

provider "flux" {
  kubernetes = {
    load_config_file = false

    host = module.kube-hetzner.kubeconfig.clusters[1].cluster.server
    cluster_ca_certificate = base64decode(module.kube-hetzner.kubeconfig.clusters[1].cluster.certificate-authority-data)

    client_certificate = base64decode(module.kube-hetzner.kubeconfig.users[1].user.client-certificate-data)
    client_key = base64decode(module.kube-hetzner.kubeconfig.users[1].user.client-key-data)
  }
  git = {
    url = "https://github.com/${var.github_org}/${var.github_repository}.git"
    http = {
      username = "trinami"
      password = data.sops_file.secrets.data["github_token"]
    }
  }
}

provider "github" {
  owner = var.github_org
  token = data.sops_file.secrets.data["github_token"]
}
