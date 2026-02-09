variable "project_id" {
    description = "The ID of the GCP project"
    type        = string
}

variable "account_id" {
    description = "The ID of the service account"
    type        = string
}

variable "display_name" {
    description = "The display name of the service account"
    type        = string
}

variable "region" {
    description = "The region where resources will be created"
    type        = string
    default     = "us-central1"
}

variable "backend_bucket_name" {
  description = "The name of the GCS bucket to be used as the Terraform backend."
  type        = string
}

variable "backend_bucket_location" {
  description = "The location of the GCS bucket to be used as the Terraform backend."
  type        = string
  default     = "US"
}

variable "backend_force_destroy" {
  description = "Whether to force destroy the GCS bucket used as the Terraform backend."
  type        = bool
  default     = false
}

variable "billing_account_id" {
  description = "The billing account ID for the GCP project"
  type        = string
  
}

variable "roles" {
  description = "The list of roles to be assigned to the service account"
  type        = list(string)
  default     = [
    "roles/storage.admin",
    "roles/container.admin",
  ]
}

variable "repository_id" {
  description = "The ID of the Artifact Registry repository"
  type        = string
  default     = "hippocraticai-terraform-repo"
}