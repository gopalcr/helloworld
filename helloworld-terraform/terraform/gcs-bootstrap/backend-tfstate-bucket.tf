module "backend_bucket" {
  source      = "../../modules/gcs-bucket"
  bucket_name = var.backend_bucket_name
  project_id  = var.project_id
  location    = var.backend_bucket_location
  force_destroy = var.backend_force_destroy
  depends_on = [ module.google_project.google_project_service ]
}