# bootstrap

Bootstrap kind and local tools

- Kind
- Spinnaker
- Ingress Controller  (TODO)
- Jenkins (TODO)

## SETUP

```
sudo /usr/local/bin/enable_socks_v3.sh restart
```

Install helm
```
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
helm version
```

```
make kind
make package
make install
```

Remember to add registry in /etc/hosts:
```
127.0.0.1       localhost  spinnaker spinnakergate
```




## URLs and Token

K8s Token for dashboard:
```
kubectl get secret $(kubectl get sa cdplatform-kubernetes-dashboard -n $NAMESPACE -o jsonpath='{.secrets[0].name}') -n $NAMESPACE -o jsonpath='{.data.token}' | base64 -d
```

Urls:
```
http://localhost:8001/api/v1/namespaces/kube-system/services/https:cdplatform-kubernetes-dashboard:443/proxy/
http://localhost:8001/api/v1/namespaces/kube-system/services/http:spin-deck:9000/proxy/
http://localhost:8001/api/v1/namespaces/kube-system/services/http:cdplatform-jenkins:8080/proxy/
```


## TODO

[ ] It has the registry harcoded, pointing to marcecaro user in docker-hub, make it configurable

