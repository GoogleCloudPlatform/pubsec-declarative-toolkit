# Google Cloud Landing Zone - gcloud version
## Prepare the scripts

```
gcloud config set project gcloud-ola
mkdir gcloud-ola
cd gcloud-ola/
git clone https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git
cd pubsec-declarative-toolkit/
git checkout gh824-gcloud
cd solutions/gcloud/
```
## edit vars.sh

## Run script
```
~/boot-lz-cdd/github/pubsec-declarative-toolkit/solutions/gcloud (boot-lz-cdd)$ ./gcloud-lz-up.sh -b boot-lz-cdd -c true -d false
```