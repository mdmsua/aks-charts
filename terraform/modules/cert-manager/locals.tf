locals {
  letsencrypt = {
    staging    = "https://acme-staging-v02.api.letsencrypt.org/directory"
    production = "https://acme-v02.api.letsencrypt.org/directory"
  }
  api_token_key = "api-token"
}
