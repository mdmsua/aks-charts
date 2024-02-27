resource "kubernetes_manifest" "gateway_api_crd" {
  for_each        = local.gateway_api_crd
  manifest        = each.value
  computed_fields = ["metadata.creationTimestamp"]
}

resource "helm_release" "main" {
  name             = "cilium"
  repository       = "https://helm.cilium.io"
  chart            = "cilium"
  namespace        = "kube-system"
  create_namespace = false
  atomic           = true
  cleanup_on_fail  = true
  reuse_values     = true
  wait             = true
  version          = var.cilium.version

  set {
    name  = "aksbyocni.enabled"
    value = "true"
  }

  set {
    name  = "nodeinit.enabled"
    value = "true"
  }

  set {
    name  = "envoy.enabled"
    value = "true"
  }

  set {
    name  = "gatewayAPI.enabled"
    value = "true"
  }

  set {
    name  = "encryption.enabled"
    value = "true"
  }

  set {
    name  = "encryption.type"
    value = "wireguard"
  }

  set {
    name  = "encryption.nodeEncryption"
    value = "true"
  }

  set {
    name  = "kubeProxyReplacement"
    value = "true"
  }

  set {
    name  = "ipv6.enabled"
    value = "true"
  }

  set {
    name  = "cluster.id"
    value = tostring(var.cluster.id)
  }

  set {
    name  = "cluster.name"
    value = var.cluster.name
  }

  set {
    name  = "hubble.relay.enabled"
    value = "true"
  }

  set {
    name  = "hubble.ui.enabled"
    value = "true"
  }

  set {
    name  = "hubble.ui.standalone.enabled"
    value = "true"
  }

  set {
    name  = "ipam.operator.clusterPoolIPv4MaskSize"
    value = 24
  }

  set_list {
    name  = "ipam.operator.clusterPoolIPv4PodCIDRList"
    value = [var.cluster.pod_cidrs.0]
  }

  set {
    name  = "ipam.operator.clusterPoolIPv6MaskSize"
    value = 64
  }

  set_list {
    name  = "ipam.operator.clusterPoolIPv6PodCIDRList"
    value = [var.cluster.pod_cidrs.1]
  }

  set {
    name  = "k8sServiceHost"
    value = local.cluster_host
  }

  set {
    name  = "k8sServicePort"
    value = local.cluster_port
  }

  depends_on = [kubernetes_manifest.gateway_api_crd]
}
