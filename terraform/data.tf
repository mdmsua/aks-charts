data "terraform_remote_state" "cluster" {
  backend   = "remote"
  workspace = "adpvwg"
  config = {
    organization = "Exatron"
    workspaces = {
      prefix = "byocni-"
    }
  }
}
