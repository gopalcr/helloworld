terraform {
  backend "gcs" {
    bucket  = "hippocraticai-terraform-state"
    prefix  = "terraform/tfstate"
  }
}