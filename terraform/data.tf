data "terraform_remote_state" "cluster" {
  backend   = "remote"
  workspace = terraform.workspace
  config = {
    organization = "Exatron"
    workspaces = {
      prefix = "byocni-"
    }
  }
}
