terraform {
  cloud {
    organization = "Exatron"
    workspaces {
      project = "k8s"
      tags    = ["byocni"]
    }
  }
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~>2.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~>2.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "~>3.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~>1.14"
    }
  }
}

provider "kubernetes" {
  host                   = data.terraform_remote_state.cluster.outputs.host
  cluster_ca_certificate = base64decode(data.terraform_remote_state.cluster.outputs.ca_certificate)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "kubelogin"
    args = [
      "get-token",
      "--server-id",
      "6dae42f8-4368-4678-94ff-3960e28e3630",
      "--login",
      "msi"
    ]
  }
}

provider "helm" {
  kubernetes {
    host                   = data.terraform_remote_state.cluster.outputs.host
    cluster_ca_certificate = base64decode(data.terraform_remote_state.cluster.outputs.ca_certificate)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "kubelogin"
      args = [
        "get-token",
        "--server-id",
        "6dae42f8-4368-4678-94ff-3960e28e3630",
        "--login",
        "msi"
      ]
    }
  }
}

provider "kubectl" {
  host                   = data.terraform_remote_state.cluster.outputs.host
  cluster_ca_certificate = base64decode(data.terraform_remote_state.cluster.outputs.ca_certificate)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "kubelogin"
    args = [
      "get-token",
      "--server-id",
      "6dae42f8-4368-4678-94ff-3960e28e3630",
      "--login",
      "msi"
    ]
  }
}
