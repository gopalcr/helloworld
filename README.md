## CI/CD Process
  - Create this repo and add app.py
  - Setup GCP Credentials with access to pushing and pulling from GCR
  - Setup CI pipeline via GitHub Actions to create a docker image
  - Update the credentials to be able to create a GKE cluster (Zonal cluster to reduce cost for this demo)
  - Update GitHub Actions pipeline to deploy the demo docker image to the cluster

## GKE Cluster Creation process
  - Terraform code to create the cluster is in the "terraform" folder
  - Any change to this folder will update the cluster accordingly

