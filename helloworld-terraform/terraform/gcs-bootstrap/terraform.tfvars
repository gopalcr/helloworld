
project_id = "hippocratic-ai-gopal"
region = "us-central1"
backend_bucket_name = "hippocraticai-terraform-state"
backend_bucket_location = "us-central1"
backend_force_destroy = false
billing_account_id = "013EB7-09442E-23F697"
account_id = "terraform-sa"
display_name = "Terraform Service Account"
roles = [
  "roles/storage.admin",
  "roles/container.admin",
  "roles/resourcemanager.projectIamAdmin",
  "roles/artifactregistry.admin",
  "roles/storage.objectAdmin",
  "roles/serviceusage.serviceUsageAdmin",
  "roles/compute.admin",
  "roles/compute.networkAdmin",
]
repository_id = "hippocraticai-terraform-repo"


