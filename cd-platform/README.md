
## Buils

```bash
cd cd-platform
helm lint
helm dep up
cd ..
helm package cd-platform
```

## Install

```
kubectl create namespace kube-system
helm install --debug --namespace kube-system cdplatform cd-platform-0.1.0.tgz --timeout 600s -f parameters.yaml
```

## Postdeploy

```
./postdeploy.sh
```

### URLS
http://localhost:8001/api/v1/namespaces/kube-system/services/https:cdplatform-kubernetes-dashboard:443/proxy/


## destroy

```
helm uninstall  --namespace kube-system cdplatform cd-platform-0.1.0.tgz
```

