data "terraform_remote_state" "cluster" {
  backend = "remote"
  config = {
    organization = "Exatron"
    workspaces = {
      name = "byocni-${var.name}"
    }
  }
}