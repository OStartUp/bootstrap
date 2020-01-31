#!/bin/bash
set -x
echo "Enabling 127.0.0.1 80 and 443"
for port in 80 443
do
    node_port=$(kubectl get service -n ingress-nginx ingress-nginx -o=jsonpath="{.spec.ports[?(@.port == ${port})].nodePort}")

    docker run -d --name kind-control-plane-${port} \
      --publish 127.0.0.1:${port}:${port} \
      --link kind-control-plane:target \
      alpine/socat -dd \
      tcp-listen:${port},fork,reuseaddr tcp-connect:target:${node_port}
done