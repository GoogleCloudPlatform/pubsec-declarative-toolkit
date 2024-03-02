export TF_VAR_GCP_PROJECT=`gcloud config get-value project`
export TF_VAR_GCE_REGION=`gcloud config get-value compute/region`
export TF_VAR_GCE_ZONE=`gcloud config get-value compute/zone`


echo "Resources will be deployed into $TF_VAR_GCP_PROJECT project"
echo "Your default region/zone are: $TF_VAR_GCE_REGION/$TF_VAR_GCE_ZONE"

terraform init
terraform apply -var="prefix=$prefix"
