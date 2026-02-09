data "google_service_account" "node_sa" {
  account_id = "terraform-sa"   # the part before @
}

module "network" {
  source              = "../modules/network"
  network_name       = var.network_name
  region             = var.region
  project_id         = var.project_id
}

module "subnetwork" {
  source              = "../modules/subnetwork"
  subnetwork_name     = var.subnetwork_name
  network_id         = module.network.network_id
  region             = var.region
  project_id         = var.project_id
  ip_cidr_range      = var.ip_cidr_range
}

module "gke" {
  source              = "../modules/gke"
  cluster_name       = var.cluster_name
  region             = var.region
  network_id         = module.network.network_id
  subnetwork_id      = module.subnetwork.subnetwork_id
  project_id         = var.project_id
  node_service_account_email = data.google_service_account.node_sa.email
}