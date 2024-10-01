data "sops_file" "secrets" {
  source_file = "secrets.enc.yaml"
}

data "sops_file" "onion" {
  source_file = "trinamiggfqxmyuyipkol3svqfzecuriywhiqlzcawknhtgivj3wkxad.onion/hs_ed25519_private_key_base64.enc.json"
}

data "external" "env" {
  program = ["${path.module}/env.sh"]
}
