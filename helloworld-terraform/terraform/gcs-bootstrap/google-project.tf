module "google_project" {
  source     = "../../modules/gcp-project"
  project_name = var.project_id
  project_id = var.project_id
  #org_id     = var.org_id
  billing_account_id = var.billing_account_id
}
