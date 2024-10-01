provider "hcloud" {
  token = data.sops_file.secrets.data["hetzner_api_token"]
}

provider "cloudflare" {
  api_token = data.sops_file.secrets.data["cloudflare_api_token"]
}

provider "flux" {
  kubernetes = {
    config_path = "/home/${data.external.env.result}/.kube/config"
  }
  git = {
    url = "https://github.com/${var.github_org}/${var.github_repository}.git"
    http = {
      username = "fluxcd"
      password = data.sops_file.secrets.data["github_token"]
    }
  }
}

provider "github" {
  owner = var.github_org
  token = data.sops_file.secrets.data["github_token"]
}
