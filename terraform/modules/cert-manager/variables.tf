variable "cert_manager" {
  type = object({
    version    = string
    email      = string
    production = bool
  })
}

variable "cloudflare_api_token" {
  type      = string
  sensitive = true
}
