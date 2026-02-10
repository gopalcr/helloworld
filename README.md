## CI/CD Process
  - Create this repo and add app.py
  - Setup GitHub token at https://github.com/settings/tokens
  - Setup GCP Credentials with access to pushing and pulling from GCR
  - Setup CI pipeline via GitHub Actions to create a docker image
  - Update the credentials to be able to create a GKE cluster (Zonal cluster to reduce cost for this demo)
  - Update GitHub Actions pipeline to deploy the demo docker image to the cluster

## GKE Cluster Creation process
  - Terraform code to create the cluster is in the "terraform" folder
  - Any change to this folder will update the cluster accordingly


## Setup gcloud SDK
  Follow the instructions below to setup Google Cloud SDK
  - Install Gcloud SDK
  ```
  brew install --cask google-cloud-sdk
  ```
  If brew command fails. Use instructions from https://docs.cloud.google.com/sdk/docs/install-sdk to download and install the sdk manually.

  - Initialize Gcloud SDK
  ```
  gcloud init
  gcloud auth application-default login
  ```

# Run Terraform commands to create the infrastructure.
## Create backend terraform bucket and dependent servifes
```
cd helloworld-terraform/terraform/gcs-bootstrap
terraform init
terraform plan
terraform apply
```
## Create GKE infrastructure
```
cd ..
terraform init
terraform plan -vars-file=helloworld.tfvars
terraform apply -vars-file=helloworld.tfvars
```


The "terraform apply" command may fail for not having the billing account configured. But it takes time for the project to be associated with the hippocraticai project. hence run the "terraform apply" after a few minutes and it will succeed.

Run the following command after cluster creation so kubectl commands can be used on the command line:
```gcloud container clusters get-credentials primary-gke-cluster --region us-central1 --project my-unique-project-id```

# Get cluster credentials
```
gcloud components install gke-gcloud-auth-plugin
```
```
gcloud container clusters get-credentials helloworld-cluster --region us-central1 --project hypocraticai
```

# Use the Service account (Terraform) created with required (admin) permissions:
```
  export SA_EMAIL=$(terraform output -raw module.service_account.sa_email)
  export PROJECT_ID=$(terraform output -raw module.project.project_id)   # or use your project id
  ```
  # Create json key file for the service account
  
  ```
  gcloud iam service-accounts keys create ./hippocratic-ai-gopal-c6f67e771e87.json --iam-account="${SA_EMAIL}" --project="${PROJECT_ID}"
  ```

 # Temporary service account credetials for this shell session
 Download the hippocratic-ai-gopal-c6f67e771e87.json file from GCloud console
 ```
export GOOGLE_APPLICATION_CREDENTIALS="$PWD/hippocratic-ai-gopal-c6f67e771e87.json"
```

# To run gcloud commands:
```
gcloud auth activate-service-account --key-file="$PWD/hippocratic-ai-gopal-c6f67e771e87.json"
```

NOTE: The hippocratic-ai-gopal-c6f67e771e87 key was created via console. the command above to create the key has been provided for completion.

# Authorize artifact registry "helloworld-docker-repo"
gcloud auth configure-docker us-central1-docker.pkg.dev


# Docker build
- docker build -t [REGION]-docker.pkg.dev/[PROJECT-ID]/[REPOSITORY]/[IMAGE-NAME]:[TAG] .
- docker push [REGION]-docker.pkg.dev/[PROJECT-ID]/[REPOSITORY]/[IMAGE-NAME]:[TAG]
## Example:
- docker build -t us-central1-docker.pkg.dev/hippocratic-ai-gopal/helloworld-docker-repo/demoapp:latest .
- docker push us-central1-docker.pkg.dev/hippocratic-ai-gopal/helloworld-docker-repo/demoapp:latest

# To pull image
- gcloud auth configure-docker us-central1-docker.pkg.dev
- docker pull us-central1-docker.pkg.dev/hippocratic-ai-gopal/helloworld-docker-repo/demoapp:latest

# Improvements
- Use production grade nodes in node pool
- Add SSO (SAML) authentication to the app
- Add infrastructure firewalls, cloud CDNs
- Add separate service accounts for separation of duties:
  - infra provisioning
  - CICD (app builds and deployments) in each environment (dev, qa, stage, prod)
- Add observability
- Add DNS
- Add Https with managed SSL certificate
- Store terraform plan output and use in terraform apply command
- 