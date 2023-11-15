#

export BOOT_PROJECT_ID=bigquery-ol
export PROJECT_ID=bigquery-ol

gcloud config set project $PROJECT_ID
export SUPER_ADMIN_EMAIL=$(gcloud config list --format json|jq .core.account | sed 's/"//g')
export ORGANIZATION_ID=$(gcloud projects get-ancestors $BOOT_PROJECT_ID --format='get(id)' | tail -1)
export PROJECT_NUMBER=$(gcloud projects list --filter="${PROJECT_ID}" '--format=value(PROJECT_NUMBER)')


export NETWORK_NAME=hub
export SUBNET_NAME=hub-sn
export REGION=northamerica-northeast1
export INPUT_TOPIC_NAME=bqtopic 
export INPUT_SUBSCRIPTION_NAME=bqtopic-sub
export DEAD_LETTER_TOPIC_NAME=bq-dead-topic
export DEAD_LETTER_SUBSCRIPTION_NAME=bq-dead-topic-sub
export LOG_SINK_SERVICE_ACCOUNT=service-${PROJECT_NUMBER}@gcp-sa-logging.iam.gserviceaccount.com
export ORGANIZATION_SINK_NAME=org-sink-splunk
export PUBSUB_WRITER_IDENTITY_SERVICE_ACCOUNT=service-org-${ORGANIZATION_ID}@gcp-sa-logging.iam.gserviceaccount.com

echo "BOOT_PROJECT: $BOOT_PROJECT_ID"
echo "PROJECT_ID: $PROJECT_ID"
echo "SUPER_ADMIN_EMAIL: $SUPER_ADMIN_EMAIL"
echo "ORGANIZATION_ID: $ORGANIZATION_ID"
echo "PROJECT_NUMBER: $PROJECT_NUMBER"
echo "NETWORK_NAME: $NETWORK_NAME"
echo "SUBNET_NAME: $SUBNET_NAME"
echo "REGION: $REGION"
echo "INPUT_TOPIC_NAME: $INPUT_TOPIC_NAME"
echo "INPUT_SUBSCRIPTION_NAME: $INPUT_SUBSCRIPTION_NAME"
echo "DEAD_LETTER_TOPIC_NAME: $DEAD_LETTER_TOPIC_NAME"
echo "DEAD_LETTER_SUBSCRIPTION_NAME: $DEAD_LETTER_SUBSCRIPTION_NAME"
echo "LOG_SINK_SERVICE_ACCOUNT: $LOG_SINK_SERVICE_ACCOUNT"
echo "PUBSUB_WRITER_IDENTITY_SERVICE_ACCOUNT: $PUBSUB_WRITER_IDENTITY_SERVICE_ACCOUNT"
echo "ORGANIZATION_SINK_NAME: $ORGANIZATION_SINK_NAME"


#exit 0

# enable services
gcloud services enable monitoring.googleapis.com
gcloud services enable secretmanager.googleapis.com
gcloud services enable compute.googleapis.com
gcloud services enable pubsub.googleapis.com
gcloud services enable dataflow.googleapis.com

# grant roles
gcloud organizations add-iam-policy-binding $ORGANIZATION_ID --member=user:$SUPER_ADMIN_EMAIL --role=roles/logging.configWriter --quiet > /dev/null 1>&1
gcloud organizations add-iam-policy-binding $ORGANIZATION_ID --member=user:$SUPER_ADMIN_EMAIL --role=roles/compute.networkAdmin --quiet > /dev/null 1>&1
gcloud organizations add-iam-policy-binding $ORGANIZATION_ID --member=user:$SUPER_ADMIN_EMAIL --role=roles/compute.securityAdmin --quiet > /dev/null 1>&1
gcloud organizations add-iam-policy-binding $ORGANIZATION_ID --member=user:$SUPER_ADMIN_EMAIL --role=roles/secretmanager.admin --quiet > /dev/null 1>&1

gcloud compute networks create $NETWORK_NAME --subnet-mode=custom
gcloud compute networks subnets create $SUBNET_NAME \
--network=$NETWORK_NAME \
--region=$REGION \
--range=192.168.1.0/24


gcloud compute firewall-rules create allow-internal-dataflow \
--network=$NETWORK_NAME \
--action=allow \
--direction=ingress \
--target-tags=dataflow \
--source-tags=dataflow \
--priority=0 \
--rules=tcp:12345-12346


gcloud compute routers create nat-router \
--network=$NETWORK_NAME \
--region=$REGION

gcloud compute routers nats create nat-config \
--router=nat-router \
--nat-custom-subnet-ip-ranges=$SUBNET_NAME \
--auto-allocate-nat-external-ips \
--region=$REGION


gcloud compute networks subnets update $SUBNET_NAME \
--enable-private-ip-google-access \
--region=$REGION

gcloud pubsub topics create $INPUT_TOPIC_NAME
gcloud pubsub subscriptions create \
--topic $INPUT_TOPIC_NAME $INPUT_SUBSCRIPTION_NAME


echo "PROJECT_ID: $PROJECT_ID"
echo "INPUT_TOPIC_NAME: $INPUT_TOPIC_NAME"
echo "creating log sink : $ORGANIZATION_SINK_NAME on topic $INPUT_TOPIC_NAME"
gcloud logging sinks create $ORGANIZATION_SINK_NAME \
pubsub.googleapis.com/projects/${PROJECT_ID}/topics/${INPUT_TOPIC_NAME} \
--organization=$ORGANIZATION_ID \
--include-children \
--log-filter='NOT logName:projects/bigquery-ol/logs/dataflow.googleapis.com'

## fix project and topic rendering above

#gcloud pubsub topics add-iam-policy-binding $INPUT_TOPIC_NAME \
#--member=serviceAccount:service-951469276805@gcp-sa-logging.iam.gserviceaccount.com \
#--role=roles/pubsub.publisher

# Please remember to grant `serviceAccount:service-org-583675367868@gcp-sa-logging.iam.gserviceaccount.com` the Pub/Sub Publisher role on the topic.
echo "Granting roles/pubsub.publisher to SA: $PUBSUB_WRITER_IDENTITY_SERVICE_ACCOUNT} on PubSub topic: ${INPUT_TOPIC_NAME}"
gcloud pubsub topics add-iam-policy-binding $INPUT_TOPIC_NAME \
--member=serviceAccount:${PUBSUB_WRITER_IDENTITY_SERVICE_ACCOUNT} \
--role=roles/pubsub.publisher


gcloud pubsub topics create $DEAD_LETTER_TOPIC_NAME
gcloud pubsub subscriptions create --topic $DEAD_LETTER_TOPIC_NAME $DEAD_LETTER_SUBSCRIPTION_NAME

# grant the same role to the 2nd topic

# https://cloud.google.com/architecture/stream-logs-from-google-cloud-to-splunk/deployment
