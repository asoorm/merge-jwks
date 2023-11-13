# Merge JWKS Demo

## Requirements
1. [minikube](https://minikube.sigs.k8s.io/docs/start/)
2. [kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl)
3. [helm](https://helm.sh/docs/intro/install/)

## Installation

### Minikube

Start Minikube
```
minikube start
minikube addons enable ingress
```

### ArgoCD

Install ArgoCD on Minikube

```
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

You can expose ArgoCD UI using the following command:
```
kubectl port-forward svc/argocd-server --namespace argocd 8443:443
```

You can access the Keycloak instance in your browser at [localhost:8443](http://localhost:8443):
```
Username: admin
```

You can get the ArgoCD admin password by running the following command:
```
kubectl get secrets -n argocd argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

### Install ArgoCD Apps

The apps that will be installed are:
- Tyk
- Tyk Operator
- HttpBin Deployment and service
- Keycloak
- 
- HttpBin API definition that will you the merge-jwks application

Install Apps

```
kubectl apply -f example/apps
```

You can expose the Tyk Gateway to your localhost using the following command:
```
kubectl port-forward svc/gateway-svc-tyk-gateway --namespace tyk 8080
```

You can expose Keycloak to your localhost using the following command:
```
kubectl port-forward svc/keycloak-service --namespace keyclaok 7000
```

You can access the Keycloak instance in your browser at [localhost:7000](http://localhost:7000):
```
Username: default@example.com
Password: topsecretpassword
```

Generate JWT from Keycloak:
```
curl -L -s -X POST 'http://localhost:7000/realms/keycloak-oauth/protocol/openid-connect/token' \
   -H 'Content-Type: application/x-www-form-urlencoded' \
   --data-urlencode 'client_id=keycloak-oauth' \
   --data-urlencode 'grant_type=password' \
   --data-urlencode 'client_secret=NoTgoLZpbrr5QvbNDIRIvmZOhe9wI0r0' \
   --data-urlencode 'scope=openid' \
   --data-urlencode 'username=user@example.com' \
   --data-urlencode 'password=topsecretpassword' | jq -r '.access_token'
```

You can expose the merge-jwks to your localhost using the following command:
```
kubectl port-forward svc/merge-jwks-merge-jwks-svc --namespace merge-jwks 9000:80
```

You can access the certs endpoint in your browser at [localhost:9000/certs](http://localhost:9000/certs):