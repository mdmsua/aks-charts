module "cilium" {
  source = "./modules/cilium"
  cilium = var.spec.charts.cilium

  cluster = {
    id        = var.spec.cluster.id
    name      = var.spec.project
    host      = trimprefix(data.terraform_remote_state.cluster.outputs.host, "https://")
    pod_cidrs = var.spec.cluster.pod_cidrs
  }
}

module "external_dns" {
  source               = "./modules/external-dns"
  cloudflare_api_token = var.secrets.cloudflare_api_token
  external_dns         = var.spec.charts.external_dns

  depends_on = [module.cilium]
}

module "cert_manager" {
  source               = "./modules/cert-manager"
  cloudflare_api_token = var.secrets.cloudflare_api_token
  cert_manager         = var.spec.charts.cert_manager

  providers = {
    kubectl = kubectl
  }

  depends_on = [module.cilium]
}

module "cloud_operator" {
  source              = "./modules/cloud-operator"
  terraform_api_token = var.secrets.terraform_api_token
  cloud_operator      = var.spec.charts.cloud_operator

  depends_on = [module.cilium]
}
