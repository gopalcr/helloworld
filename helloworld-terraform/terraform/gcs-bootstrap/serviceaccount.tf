module service_account {
  source = "../../modules/serviceaccount"
  project_id = "hippocratic-ai-gopal"
  account_id = "terraform-sa"
  display_name = "Terraform Service Account"
  roles = var.roles
}