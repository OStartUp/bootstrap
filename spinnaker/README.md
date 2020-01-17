```
kubectl create namespace spinnaker
helm install --debug --namespace spinnaker spinnaker stable/spinnaker  --timeout 600s -f values.yaml
helm uninstall --debug --namespace spinnaker spinnaker

kubectl exec --namespace spinnaker -it spinnaker-spinnaker-halyard-0 -- bash -C hal config security ui edit --override-base-url http://localhost:8001/api/v1/namespaces/spinnaker/services/http:spin-deck:9000/proxy/

kubectl exec --namespace spinnaker -it spinnaker-spinnaker-halyard-0 -- bash -C hal config security api edit --override-base-url http://localhost:8001/api/v1/namespaces/spinnaker/services/http:spin-gate:8084/proxy/

kubectl exec --namespace spinnaker -it spinnaker-spinnaker-halyard-0 -- bash -C hal deploy apply
```
UI -> http://localhost:8001/api/v1/namespaces/spinnaker/services/http:spin-deck:9000/proxy/

```
kubectl port-forward --namespace spinnaker service/spin-deck 9000:9000
kubectl port-forward --namespace spinnaker service/spin-gate 8084:8084
```


```
helm status spinnaker
```

Visit the Spinnaker UI by opening your browser to: http://127.0.0.1:9000
kubectl exec --namespace spinnaker -it spinnaker-spinnaker-halyard-0 bash
