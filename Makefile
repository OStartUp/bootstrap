NAMESPACE = kube-system
help:
	@echo "make kind"
	@echo "make package"
	@echo "make install"
	@echo "make upgrade"
	@echo "--------------"
	@echo "make debug"
	@echo "make list"
	@echo "make token"
	@echo "make prune"
	@echo "--------------"
	@echo "make kinddown"
	@echo "make uninstall"
	@echo "--------------"
	@echo "make postdeploy"

kind:
	./start-kind

gitinfo:
	@cd ../universe ;\
	git fetch --tag ;\
	echo "Current Production Commit (production_pointer)" ;\
	git rev-parse --verify production_pointer 


debug: int
	kubectl delete deployment -l run=busybox
	kubectl run busybox  --image=radial/busyboxplus:curl -i --tty
	kubectl delete deployment -l run=busybox

debugprod: prod
	kubectl delete deployment -l run=busybox
	kubectl run busybox  --image=radial/busyboxplus:curl -i --tty
	kubectl delete deployment -l run=busybox

prune:
	docker container prune
	docker image prune -a
	docker system prune --volumes
	rm -rf ~/.cache

token:
	@echo ""
	@kubectl get secret $$(kubectl get sa cdplatform-kubernetes-dashboard -n $(NAMESPACE) -o jsonpath='{.secrets[0].name}') -n $(NAMESPACE) -o jsonpath='{.data.token}' | base64 -d
	@echo ""
kinddown:
	./stop-kind

package: cd-platform 
	cd cd-platform/cd-platform ; helm lint 
	cd cd-platform/cd-platform ; helm dep up
	cd cd-platform ; helm package cd-platform

install:  int
	@rm -f /tmp/cdplatform.yaml
	#-kubectl config set-cluster kind-production --insecure-skip-tls-verify=true
	-kubectl create namespace "echo-prod"
	-kubectl create namespace "pet-prod"
	-kubectl create namespace "reflector-prod"
	-kubectl create namespace "reflector"
	-kubectl create namespace "echo"
	-kubectl create namespace "pet"
	-cp $$HOME/.kube/config /tmp/config_template
	-sed "s/127.0.0.1:/kubernetes.default.svc.cluster.local  #/g" /tmp/config_template > /tmp/config
	-kubectl delete secret my-kubeconfig -n $(NAMESPACE)
	-kubectl create secret generic --from-file=/tmp/config my-kubeconfig -n $(NAMESPACE)
	helm template cdplatform cd-platform/cd-platform-0.1.0.tgz -n $(NAMESPACE) -f cd-platform/parameters.yaml  > /tmp/cdplatform.yaml
	kubectl apply -n $(NAMESPACE) -f /tmp/cdplatform.yaml
	# cd cd-platform ; helm install --debug -n $(NAMESPACE) cdplatform cd-platform-0.1.0.tgz --timeout 600s -f parameters.yaml 
	cd cd-platform ; ./postdeploy.sh $(NAMESPACE)

prod:
	@echo "Switching to Production Environment"
	kubectl config use-context kind-production


int:
	@echo "Switching to Integration Environment"
	kubectl config use-context kind-kind


upgrade: int
	@rm -f /tmp/cdplatform.yaml
	helm template cdplatform cd-platform/cd-platform-0.1.0.tgz -n $(NAMESPACE)  -f cd-platform/parameters.yaml > /tmp/cdplatform.yaml
	kubectl apply -n $(NAMESPACE) -f /tmp/cdplatform.yaml
	# cd cd-platform ; helm upgrade --install --debug -n $(NAMESPACE) cdplatform cd-platform-0.1.0.tgz --timeout 600s -f parameters.yaml 
	cd cd-platform ; ./postdeploy.sh $(NAMESPACE)

uninstall: int
	@rm -f /tmp/cdplatform.yaml
	helm template cdplatform cd-platform/cd-platform-0.1.0.tgz -n $(NAMESPACE)  -f cd-platform/parameters.yaml  > /tmp/cdplatform.yaml
	-@kubectl delete -n $(NAMESPACE) -f /tmp/cdplatform.yaml || true
	-@kubectl delete deployment  -n $(NAMESPACE) -l release=cdplatform
	-@kubectl delete svc         -n $(NAMESPACE) -l release=cdplatform
	-@kubectl delete ingress     -n $(NAMESPACE) -l release=cdplatform
	-@kubectl delete statefulset -n $(NAMESPACE) -l release=cdplatform
	-@kubectl delete statefulset -n $(NAMESPACE) -l app=spin
	-@kubectl delete deployments -n $(NAMESPACE) -l app=spin

postdeploy: int
	cd cd-platform ; ./postdeploy.sh $(NAMESPACE)

list:
	helm list --all-namespaces

.PHONY: help kind kinddown package install uninstall postdeploy list int prod gitinfo

# kubectl wait --for=condition=Ready pod/busybox1