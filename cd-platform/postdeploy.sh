#!/bin/bash
NAMESPACE=$1
killall kubectl
kubectl proxy &
kubectl get secret $(kubectl get sa cdplatform-kubernetes-dashboard -n $NAMESPACE -o jsonpath='{.secrets[0].name}') -n $NAMESPACE -o jsonpath='{.data.token}' | base64 -d
echo ""
echo "------------------"
echo "http://localhost:8001/api/v1/namespaces/$NAMESPACE/services/https:cdplatform-kubernetes-dashboard:443/proxy/"
echo "http://localhost:8001/api/v1/namespaces/$NAMESPACE/services/http:spin-deck:9000/proxy/"
echo "http://localhost:8001/api/v1/namespaces/$NAMESPACE/services/http:cdplatform-jenkins:8080/proxy/"
echo ""
echo "Waiting for Spinnaker"
kubectl wait pod -l app=spin --for=condition=Ready -n $NAMESPACE --timeout=300s
kubectl exec --namespace $NAMESPACE -it cdplatform-spinnaker-halyard-0 -- bash -C hal config security ui edit --override-base-url http://localhost:8001/api/v1/namespaces/$NAMESPACE/services/http:spin-deck:9000/proxy/
kubectl exec --namespace $NAMESPACE -it cdplatform-spinnaker-halyard-0 -- bash -C hal config security api edit --override-base-url http://localhost:8001/api/v1/namespaces/$NAMESPACE/services/http:spin-gate:8084/proxy/
kubectl exec --namespace $NAMESPACE -it cdplatform-spinnaker-halyard-0 -- bash -C hal deploy apply

echo "------------------"
echo "http://localhost:8001/api/v1/namespaces/$NAMESPACE/services/https:cdplatform-kubernetes-dashboard:443/proxy/"
echo "http://localhost:8001/api/v1/namespaces/$NAMESPACE/services/http:spin-deck:9000/proxy/"
echo "http://localhost:8001/api/v1/namespaces/$NAMESPACE/services/http:cdplatform-jenkins:8080/proxy/"