
## Buils

```bash
cd cd-platform
helm lint
helm dep up
cd ..
helm package cd-platform
```

## Install

Add the following new hosts
``` 
127.0.0.1    localhost, api, spinnaker, spinnakergate, telemetry, weave   (in linux no ',' )
```

```
kubectl create namespace kube-system
helm install --debug --namespace kube-system cdplatform cd-platform-0.1.0.tgz --timeout 600s -f parameters.yaml
```

## Postdeploy

```
./postdeploy.sh
```

## Jenkins configuration

```
https://github.com/OStartUp/universe.git
```
https://www.spinnaker.io/setup/ci/jenkins/#configure-jenkins-and-spinnaker-for-csrf-protection

### URLS

Get Dashboard token
```
NAMESPACE=kube-system kubectl get secret $(kubectl get sa cdplatform-kubernetes-dashboard -n $NAMESPACE -o jsonpath='{.secrets[0].name}') -n $NAMESPACE -o jsonpath='{.data.token}' | base64 -d
```
http://localhost:8001/api/v1/namespaces/kube-system/services/https:cdplatform-kubernetes-dashboard:443/proxy/


## destroy

```
helm uninstall  --namespace kube-system cdplatform cd-platform-0.1.0.tgz
```
