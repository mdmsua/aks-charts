variable "spec" {
  type = object({
    project = string
    cluster = object({
      id            = number
      pod_cidrs     = list(string)
      service_cidrs = list(string)
    })
    charts = object({
      cilium = object({
        version = string
      })
      external_dns = object({
        version = string
      })
      cert_manager = object({
        version = string
      })
    })
  })
}

variable "secrets" {
  type = object({
    cloudflare_api_token = string
    terraform_api_token  = string
  })
  sensitive = true
}
