# cluster creation
```
kind create cluster --config kind.yaml

```
# NGINX Ingress installation might differ for your k8s provider
kubectl apply \
    --filename https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/kind/deploy.yaml

export INGRESS_HOST=192.169.1.10   
# Install Argo CD

```
helm repo add argo https://argoproj.github.io/argo-helm

helm repo update   

helm upgrade --install \
    argocd argo/argo-cd \
    --namespace argocd \
    --create-namespace \
    --set server.ingress.hosts="{argo-cd.$INGRESS_HOST.nip.io}" \
    --set server.ingress.enabled=true \
    --set server.extraArgs="{--insecure}" \
    --set controller.args.appResyncPeriod=30 \
    --wait
```