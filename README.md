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
  - brew install --cask google-cloud-sdk
  Brew command fails. Use instructions from https://docs.cloud.google.com/sdk/docs/install-sdk to download and install the sdk manually.
  - gcloud init
  - gcloud auth application-default login

terraform init

terraform plan -vars-file=helloworld.tfvars

terraform apply -vars-file=helloworld.tfvars

The "terraform apply" command may fail for not having the billing account configured. But it takes time for the project to be associated with the hippocraticai project. hence run the "terraform apply" after a few minutes and it will succeed.

Run the following command after cluster creation so kubectl commands can be used on the command line:
```gcloud container clusters get-credentials primary-gke-cluster --region us-central1 --project my-unique-project-id```

# Get cluster credentials
gcloud components install gke-gcloud-auth-plugin
gcloud container clusters get-credentials helloworld-cluster --region us-central1 --project hypocraticai

# Create service account and grant permissions to avoid using a user with full admin access to be used in automation scripts.
Create Service account (Terraform) with required (admin) permissions. See serviceaccount module for details. Then:
    SA_EMAIL=$(terraform output -raw module.service_account.sa_email)
    PROJECT_ID=$(terraform output -raw module.project.project_id)   # or use your project id
    # Create json key file for the service account
    gcloud iam service-accounts keys create ./hippocratic-ai-gopal-c6f67e771e87.json \
    --iam-account="${SA_EMAIL}" --project="${PROJECT_ID}"

 # Temporary for this shell session
export GOOGLE_APPLICATION_CREDENTIALS="$PWD/hippocratic-ai-gopal-c6f67e771e87.json"

# For gcloud commands:
gcloud auth activate-service-account --key-file="$PWD/hippocratic-ai-gopal-c6f67e771e87.json"

NOTE: The hippocratic-ai-gopal-c6f67e771e87 key was created via console. the command above to create the key has been provided for completion.

# Authorize artifact registry "helloworld-docker-repo"
gcloud auth configure-docker \
    us-central1-docker.pkg.dev


# Docker build
- docker build -t [REGION]-docker.pkg.dev/[PROJECT-ID]/[REPOSITORY]/[IMAGE-NAME]:[TAG] .
- docker push [REGION]-docker.pkg.dev/[PROJECT-ID]/[REPOSITORY]/[IMAGE-NAME]:[TAG]
Example:
- docker build -t us-central1-docker.pkg.dev/hippocratic-ai-gopal/helloworld-docker-repo/demoapp:latest .
- docker push us-central1-docker.pkg.dev/hippocratic-ai-gopal/helloworld-docker-repo/demoapp:latest

# To pull image
- gcloud auth configure-docker us-central1-docker.pkg.dev
- docker pull \
    us-central1-docker.pkg.dev/hippocratic-ai-gopal/helloworld-docker-repo/demoapp:latest

# Improvements
- Use production grade nodes in node pool
- Add SSO (SAML) authentication to the app
- Add infrastructure firewalls, cloud CDNs
- Add separate service accounts for separation of duties:
  - infra provisioning
  - CICD (app builds and deployments) in each environment (dev, qa, stage, prod)
- Add observability
-