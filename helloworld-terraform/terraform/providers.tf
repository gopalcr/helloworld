terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.0.0"
    }
  }
}

provider "google" {
  #credentials = file("hippocratic-ai-gopal-c6f67e771e87.json")
  project     = var.project_id
  region      = var.region
}

provider "google-beta" {
  #credentials = file("hippocratic-ai-gopal-c6f67e771e87.json")
  project     = var.project_id
  region      = var.region
}
