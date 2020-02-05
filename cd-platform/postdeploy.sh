#!/bin/bash

NAMESPACE=$1
kubectl get secret $(kubectl get sa cdplatform-kubernetes-dashboard -n $NAMESPACE -o jsonpath='{.secrets[0].name}') -n $NAMESPACE -o jsonpath='{.data.token}' | base64 -d 
echo ""
#set -x
echo "------------------"
echo "http://localhost:8001/api/v1/namespaces/$NAMESPACE/services/https:cdplatform-kubernetes-dashboard:443/proxy/"
echo "http://localhost:8001/api/v1/namespaces/$NAMESPACE/services/http:spin-deck:9000/proxy/"
echo "http://localhost:8001/api/v1/namespaces/$NAMESPACE/services/http:cdplatform-jenkins:8080/proxy/"
echo ""

echo "Waiting for Spinnaker"
sleep 10
kubectl wait pod cdplatform-spinnaker-halyard-0 --for=condition=Ready -n $NAMESPACE --timeout=300s
sleep 60
echo "Post configuration Spinnaker"
kubectl exec --namespace $NAMESPACE -it cdplatform-spinnaker-halyard-0 -- bash -C hal config security ui edit --override-base-url  http://spinnaker:8080
kubectl exec --namespace $NAMESPACE -it cdplatform-spinnaker-halyard-0 -- bash -C hal config security api edit --override-base-url http://spinnakergate:8080
kubectl exec --namespace $NAMESPACE -it cdplatform-spinnaker-halyard-0 -- bash -C hal deploy apply

echo "------------------"
echo "http://localhost:8001/api/v1/namespaces/$NAMESPACE/services/https:cdplatform-kubernetes-dashboard:443/proxy/"
echo "http://localhost:8001/api/v1/namespaces/$NAMESPACE/services/http:spin-deck:9000/proxy/"
echo "http://localhost:8001/api/v1/namespaces/$NAMESPACE/services/http:cdplatform-jenkins:8080/proxy/"

kubectl get secret $(kubectl get sa cdplatform-kubernetes-dashboard -n $NAMESPACE -o jsonpath='{.secrets[0].name}') -n $NAMESPACE -o jsonpath='{.data.token}' | base64 -d
echo ""
echo "Waiting for Jenkins"
kubectl wait pod -l "app.kubernetes.io/component=jenkins-master" --for=condition=Ready -n $NAMESPACE --timeout=300s

echo "Cleaning tests pods"
kubectl get pods -n mynamespace -n $NAMESPACE -o=name| grep test | xargs kubectl delete -n $NAMESPACE


read -s -p "Docker Hub Token: " DOCKERTOKEN
echo ""
read -s -p "Jenkins API Token: " JTOKEN
sed "s/DOCKERTOKEN/$DOCKERTOKEN/g" CI_Template.xml > CI.xml
./set_jenkins_config $JTOKEN

echo "Jenkins admin password: admin"
echo "Jenkins url:      http://localhost:8080/jenkins/"
echo "K8sDashboard url: http://localhost:8080/"
echo "Spinnaker url:    http://spinnaker:8080/spinnaker/"

