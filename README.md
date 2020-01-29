# bootstrap

Bootstrap kind and local tools

- Kind
- Spinnaker
- Ingress Controller  (TODO)
- Jenkins (TODO)

## SETUP

```
make kind
make package
make install
kubectl proxy &
```

(Not needed!!) Remember to add registry in /etc/hosts:
```
127.0.0.1       localhost proxy registry
```


## TODO

[ ] It has the registry harcoded, pointing to marcecaro user in docker-hub, make it configurable

