module "artifact_registry" {
  source              = "../../modules/artifact_registry"
  project_id          = var.project_id
  location            = var.region
  repository_id       = var.repository_id
}