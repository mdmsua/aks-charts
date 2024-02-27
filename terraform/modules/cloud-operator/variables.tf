variable "cloud_operator" {
  type = object({
    version = string
  })
}

variable "terraform_api_token" {
  type      = string
  sensitive = true
}
