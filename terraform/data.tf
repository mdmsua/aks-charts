data "terraform_remote_state" "cluster" {
  backend = "remote"
  config = {
    organization = "Exatron"
    workspaces = {
      name = "byocni-mngenv"
    }
  }
}

data "http" "gateway_api_crd_list" {
  url = "${local.gateway_api_crd_base}/kustomization.yaml"
}

data "http" "gateway_api_crd" {
  for_each = toset(local.gateway_api_crd_list)
  url      = "${local.gateway_api_crd_base}/${each.value}"
}
