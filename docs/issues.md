Known Issues
============

* Kubectl Timeouts out
  * If your Kubectl times out when you are making changes to your config controller GKE cluster then this is most likely because your IP address of your host / Cloud Shell environment hasn't been added to Authorized Master Networks. You can run `dig +short myip.opendns.com @resolver1.opendns.com` to get your IP address. Then run `gcloud container clusters update CLUSTER_NAME --master-authorized-networks=CIDR, CIDR` to update the cluster.
