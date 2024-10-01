data "sops_file" "secrets" {
  source_file = "secrets.enc.yaml"
}

data "external" "env" {
  program = ["${path.module}/env.sh"]
}
