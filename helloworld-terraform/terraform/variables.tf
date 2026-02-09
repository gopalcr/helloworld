variable "network_name" {
  description = "The name of the network to be created."
  type        = string
}

variable "subnetwork_name" {
  description = "The name of the subnetwork to be created."
  type        = string
}

variable "cluster_name" {
  description = "The name of the GKE cluster to be created."
  type        = string
}

variable "region" {
  description = "The region where the resources will be created."
  type        = string
}

variable "project_id" {
  description = "The ID of the GCP project."
  type        = string
}

variable "billing_account_id" {
  description = "The billing account ID for the GCP project."
  type        = string
}

variable "backend_bucket_name" {
  description = "value for the name of the GCS bucket to be used as the Terraform backend."
  type        = string
}

variable "backend_bucket_location" {
  description = "The location of the GCS bucket to be used as the Terraform backend."
  type        = string
}

variable "backend_force_destroy" {
  description = "Whether to force destroy the GCS bucket used as the Terraform backend."
  type        = bool
  default     = false
}

variable "ip_cidr_range" {
  description = "The CIDR range for the subnetwork."
  type        = string
  default     = "10.0.0.0/24"
}

variable node_service_account_email {
  description = "The email of the service account to be used for GKE nodes."
  type        = string
}