resource "helm_release" "cilium" {
  name             = "cilium"
  repository       = "https://helm.cilium.io"
  chart            = "cilium"
  namespace        = "kube-system"
  create_namespace = false
  atomic           = true
  cleanup_on_fail  = true
  reuse_values     = true
  wait             = true
  version          = var.spec.charts.cilium.version

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
    value = "false"
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
    value = tostring(var.spec.cluster.id)
  }

  set {
    name  = "cluster.name"
    value = var.spec.project
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
    value = [var.spec.cluster.pod_cidrs.0]
  }

  set {
    name  = "ipam.operator.clusterPoolIPv6MaskSize"
    value = 64
  }

  set_list {
    name  = "ipam.operator.clusterPoolIPv6PodCIDRList"
    value = [var.spec.cluster.pod_cidrs.1]
  }
}
