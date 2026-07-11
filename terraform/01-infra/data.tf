data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket  = var.tf_state_bucket
    key     = "accor-redemption/prod/00-network.tfstate"
    region  = var.region
    encrypt = true
  }
}