locals {
  cluster_host_port    = split(":", trimprefix(data.terraform_remote_state.cluster.outputs.host, "https://"))
  cluster_host         = local.cluster_host_port[0]
  cluster_port         = local.cluster_host_port[1]
  gateway_api_crd_base = "https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.0.0/config/crd/experimental"
  gateway_api_crd_list = yamldecode(data.http.gateway_api_crd_list.response_body).resources
  gateway_api_crd = {
    for crd in local.gateway_api_crd_list : crd => { for k, v in yamldecode(data.http.gateway_api_crd[crd].response_body) : k => v if k != "status" }
  }
}
