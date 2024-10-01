# Trinami Infrastructure

This repo aims to build the hole Trinami Infrastructure with just a single command

0. Init
```bash
#create a secrets.yaml with values:
cloudflare_api_token: "********"
hetzner_api_token: "********"
trinami_org_zone_id: "********"
trinami_zip_zone_id: "********"
github_token: "********"
onion_key: "********"

#install sops and encrypt the secrets
sops -e -p KEYID secrets.yaml > secrets.enc.yaml

#install fluxcd
```

1. Setup
```bash
terraform init
terraform plan
terraform import github_repository.this infrastructure
terraform apply
```

2. Get kubeconfig access
```bash
terraform output --raw kubeconfig > ~/.kube/config
```

## TODO's
- Add Zytadel
- Post-Quantum sops?
- Auto scaling
- 2FA
- gvisor
- ...
