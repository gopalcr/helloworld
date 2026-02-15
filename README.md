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

# To run gcloud commands via owner account (gopalcr@gmail.com):
```
gcloud auth login
gcloud config set account gopalcr@gmail.com
```

# To run gcloud commands via service account:
```
gcloud auth activate-service-account --key-file="$PWD/hippocratic-ai-gopal-c6f67e771e87.json"
```

NOTE: The hippocratic-ai-gopal-c6f67e771e87 key was created via console. the command above to create the key has been provided for completion.

# Authorize artifact registry "helloworld-docker-repo"
```
gcloud auth configure-docker us-central1-docker.pkg.dev
```

# Docker build
```
  docker build -t [REGION]-docker.pkg.dev/[PROJECT-ID]/[REPOSITORY]/[IMAGE-NAME]:[TAG] .
  docker push [REGION]-docker.pkg.dev/[PROJECT-ID]/[REPOSITORY]/[IMAGE-NAME]:[TAG]
```
### Since I built on Mac, I need to do the following to make the image run on Linux:
```
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t us-central1-docker.pkg.dev/hippocratic-ai-gopal/helloworld-docker-repo/helloworld:latest \
  --push .
```
## Example:
```
  docker build -t us-central1-docker.pkg.dev/hippocratic-ai-gopal/helloworld-docker-repo/demoapp:latest .
  docker push us-central1-docker.pkg.dev/hippocratic-ai-gopal/helloworld-docker-repo/demoapp:latest
```

# To pull image
```
 gcloud auth configure-docker us-central1-docker.pkg.dev
 docker pull us-central1-docker.pkg.dev/hippocratic-ai-gopal/helloworld-docker-repo/demoapp:latest
```

# Setup kubectl
```
gcloud components install kubectl
export PATH=/Users/gopalramalingam/Downloads/HippocraticAI/Assignment/google-cloud-sdk/bin:$PATH
```

# Connect to GKE cluster
```
gcloud container clusters get-credentials helloworld-cluster --region us-central1
gcloud config list
# To get Cluster's IP Address
kubectl config view --minify | egrep 'server:|name:'
```

# Authenticate Helm to use artifact registry repo

```
base64 FILE-NAME > NEW-FILE-NAME
cat KEY-FILE | helm registry login -u KEY-TYPE --password-stdin \
https://LOCATION-docker.pkg.dev
```

# Deploy the newly uploaded image
```
helm upgrade --install helloworld ./helloworld \      
  --namespace helloworld \
  --create-namespace

kubectl rollout restart deployment/helloworld -n helloworld
```
# Features
- Bootstrap Terraform to deploy terraform backend GCS bucket, service account, project,  enable apis and artifact registry
- Terraform to deploy VPC, network, subnet, GKE cluster and public IP
- use the GCS bucket provisioned above.
- Helm chart to deploy helloworld with static IP provisioned above. Use an already provisioned public IP via terraform and not use service type LoadBalancer which will create different public IPs every time the helloworld chart is deleted and redeployed messing up DNS creation and SSL setup.
- Only specific CIDRs can connect to the API endpoint of the cluster.
- 
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
- Enable privte settings for cluster so the API endpoint is accessible only from within the VPC or via VPN.
- Enable Container Security API for Security insights into Google Kubernetes Engine clusters.
- 



# Command reference
## Setup
- gcloud auth activate-service-account --key-file="$PWD/hippocratic-ai-gopal-c6f67e771e87.json"
- gcloud compute addresses list --regions=us-central1 | grep helloworld-static-external-ip

## Build
- docker buildx build \                                      
  --platform linux/amd64,linux/arm64 \
  -t us-central1-docker.pkg.dev/hippocratic-ai-gopal/helloworld-docker-repo/helloworld:latest \
  --push .
## Deploy
-  helm --debug upgrade --install helloworld ./helloworld \   
  --namespace helloworld \
  --create-namespace -f values.yaml
-  kubectl rollout restart deployment/helloworld -n helloworld

## Status check
- kubectl get endpoints -n helloworld helloworld -o wide    
- kubectl get svc -n helloworld -o yaml
- helm template helloworld helloworld -f values.yaml 
- gcloud compute addresses describe helloworld-static-external-ip \
  --region=us-central1 \
  --format="get(address)"
- 

# Local testing
- docker pull us-central1-docker.pkg.dev/hippocratic-ai-gopal/helloworld-docker-repo/demoapp:latest 
- docker run -p 8000:8000 us-central1-docker.pkg.dev/hippocratic-ai-gopal/helloworld-docker-repo/demoapp:latest

# Perf testing
- k6 run -e BASE_URL="http://34.133.137.182/" -e PATH="/" ./helloworld_perf.js

# Notes on scale out and scale in requirement
- Scale out at 80% can be done with HPA (to 5 replicas). It has already been implemented and tested (with 50% CPU threshold instead of 80%).
- But Scale in at 20% (while Scale out is 50%) is not possible with HPA as it works with a single threshold
- As an alternative to scaling down at 20%, I've setup slow scale down towards min replicas (2 replicas) over a 5 min period
- If exact behavior is needed, we need KEDA to be setup with custom prometheus queries that report when "real" cpu hits 50% and 20% and orchestrate the scaling. This needs a prometheus instance reachable within the cluster. But since I use GCloud monitoring for Observability, setting up a prometheus stack is a redundant infrastructure that needs to be setup. This requirement needs to be re-evaluated before implementing this.
- 
