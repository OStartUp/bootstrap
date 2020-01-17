NAMESPACE = kube-system
help:
	@echo "make kind"
	@echo "make package"
	@echo "make install"
	@echo "--------------"
	@echo "make kinddown"
	@echo "make uninstall"
	@echo "--------------"
	@echo "make postdeploy"

kind:
	./start-kind

kinddown:
	./stop-kind

package: cd-platform 
	cd cd-platform/cd-platform ; helm lint 
	cd cd-platform/cd-platform ; helm dep up
	cd cd-platform ; helm package cd-platform

install:
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/mandatory.yaml
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/baremetal/service-nodeport.yaml
	cd cd-platform ; helm install --debug --namespace $(NAMESPACE) cdplatform cd-platform-0.1.0.tgz --timeout 600s -f parameters.yaml --set jenkins.master.jenkinsUrl=http://localhost:8001/api/v1/namespaces/$(NAMESPACE)/services/http:cdplatform-jenkins:8080/proxy/
	cd cd-platform ; ./postdeploy.sh $(NAMESPACE)
upgrade:
	cd cd-platform ; helm upgrade --debug --namespace $(NAMESPACE) cdplatform cd-platform-0.1.0.tgz --timeout 600s -f parameters.yaml --set jenkins.master.jenkinsUrl=http://localhost:8001/api/v1/namespaces/$(NAMESPACE)/services/http:cdplatform-jenkins:8080/proxy/
	cd cd-platform ; ./postdeploy.sh $(NAMESPACE)

uninstall:
	kubectl delete -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/baremetal/service-nodeport.yaml
	kubectl delete -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/mandatory.yaml
	cd cd-platform ; helm uninstall  --namespace $(NAMESPACE) cdplatform cd-platform-0.1.0.tgz

postdeploy:
	cd cd-platform ; ./postdeploy.sh $(NAMESPACE)


	

.PHONY: help kind kinddown package install uninstall postdeploy values