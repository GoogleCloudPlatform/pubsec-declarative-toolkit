# hello-app

This example is based off the [hello-app](https://github.com/GoogleCloudPlatform/kubernetes-engine-samples/tree/main/hello-app) from Google's Kubernetes Engine samples repo on GitHub.

## Deploying hello-app

Once you have a functional GKE cluster, run the following command from this folder to deploy the hello-app.

> Warning: A an external IP will be allocated. Please destroy the deployment when unused.

```sh
kubectl apply -f .
```

> Example output result

```console
Warning: Autopilot increased resource requests for Deployment default/helloweb to meet requirements. See http://g.co/gke/autopilot-resources
deployment.apps/helloweb created
Warning: autoscaling/v2beta2 HorizontalPodAutoscaler is deprecated in v1.23+, unavailable in v1.26+; use autoscaling/v2 HorizontalPodAutoscaler
horizontalpodautoscaler.autoscaling/cpu created
ingress.networking.k8s.io/helloweb created
service/helloweb-backend created
service/helloweb created
```

Retrieve the external IP of the helloweb service.

```sh
kubectl get services
```

> Example result. 

> Note: External IP redacted.

```console
NAME               TYPE           CLUSTER-IP     EXTERNAL-IP      PORT(S)          AGE
helloweb           LoadBalancer   10.166.0.162   x.x.x.x          80:30499/TCP     63s
helloweb-backend   NodePort       10.166.2.62    <none>           8080:31327/TCP   63s
kubernetes         ClusterIP      10.166.0.1     <none>           443/TCP          5h4m
```

Test the hello-app by connecting to the external IP using a browser or issue this command from your console.

```sh
curl EXTERNAL-IP
```

> Example result

```console
Hello, world!
Version: 2.0.0
Hostname: helloweb-58999c56d8-tnngt
```

When finished delete the hello-app deployment.

```sh
kubectl delete -f .
```