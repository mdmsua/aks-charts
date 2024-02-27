variable "external_dns" {
  type = object({
    version = string
  })
}

variable "cloudflare_api_token" {
  type      = string
  sensitive = true
}
