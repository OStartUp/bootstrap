

## Current

[] Test bazel by creating a pupet python project
[] Test build cluster (installed with helm)
[] Create a helm package with all necesary for build system
[] Build puppet project with build cluster
[] Add helm packaging in puppet project
[] Add bazel target for packaging 
....
Jenkins ... install with helm
....
Install spinnaker
Integrate 
 

## Install Basics


```
curl -sLO https://get.helm.sh/helm-v3.0.2-linux-amd64.tar.gz
tar -zxvf helm-v3.0.2-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/helm
helm repo add stable https://kubernetes-charts.storage.googleapis.com/
```
```
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
```

```
curl -Lo ./kind https://github.com/kubernetes-sigs/kind/releases/download/v0.7.0/kind-$(uname)-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind
```
```
sudo snap install helm3
```

```
helm3 search hub spinnaker
```

```
curl https://bazel.build/bazel-release.pub.gpg | sudo apt-key add -
echo "deb [arch=amd64] https://storage.googleapis.com/bazel-apt stable jdk1.8" | sudo tee /etc/apt/sources.list.d/bazel.list
sudo apt-get update
sudo apt-get install bazel
```

## Kind

```
kind create cluster --config kind-example-config.yaml
```

```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
    - role: control-plane
    - role: worker
    - role: worker
```

```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
    - role: control-plane
    - role: control-plane
    - role: control-plane
    - role: worker
    - role: worker
    - role: worker
```

You can map extra ports from the nodes to the host machine with extraPortMappings

```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  extraPortMappings:
  - containerPort: 80
    hostPort: 80
    listenAddress: "0.0.0.0" # Optional, defaults to "0.0.0.0"
    protocol: udp # Optional, defaults to tcp
```

## Helm install

### Search
```
helm search repo spinnaker
helm search hub
```

```
helm repo addhelm
```

### Install

```
helm install kubernetes-dashboard stable/kubernetes-dashboard --set rbac.create=true --set rbac.clusterAdminRole=true --namespace kube-system
kubectl -n kube-system port-forward service/kubernetes-dashboard 8443:443
kubectl get secret $(kubectl get sa kubernetes-dashboard -n kube-system -o jsonpath='{.secrets[0].name}') -n kube-system -o jsonpath='{.data.token}' | base64 -d
helm uninstall kubernetes-dashboard -n kube-system
```

export POD_NAME=$(kubectl get pods -n default -l "app=kubernetes-dashboard,release=kubernetes-dashboard" -o jsonpath="{.items[0].metadata.name}")
echo https://127.0.0.1:8443/
kubectl -n default port-forward $POD_NAME 8443:8443
```

```
helm show values stable/spinnaker
```
```
