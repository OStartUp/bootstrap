```
kubectl create namespace spinnaker
helm install --debug --namespace spinnaker spinnaker stable/spinnaker  --timeout 600s -f values.yaml
helm uninstall --debug --namespace spinnaker spinnaker
```


```
kubectl -n spinnaker get events --sort-by='{.lastTimestamp}'
```

```
helm status spinnaker
```

1. You will need to create 2 port forwarding tunnels in order to access the Spinnaker UI:
  export DECK_POD=$(kubectl get pods --namespace spinnaker -l "cluster=spin-deck" -o jsonpath="{.items[0].metadata.name}")
  kubectl port-forward --namespace spinnaker $DECK_POD 9000

  export GATE_POD=$(kubectl get pods --namespace spinnaker -l "cluster=spin-gate" -o jsonpath="{.items[0].metadata.name}")
  kubectl port-forward --namespace spinnaker $GATE_POD 8084

2. Visit the Spinnaker UI by opening your browser to: http://127.0.0.1:9000

To customize your Spinnaker installation. Create a shell in your Halyard pod:

  kubectl exec --namespace spinnaker -it spinnaker-spinnaker-halyard-0 bash




  sed: can't read spinnaker.conf: Permission denied
sed: can't read spinnaker.conf: Permission denied
Enabling site spinnaker.
To activate the new configuration, you need to run:
  service apache2 reload
ERROR: Can't open /etc/apache2/sites-available/spinnaker.conf: Permission deniedsed: can't read ports.conf: Permission denied
apache2: Syntax error on line 150 of /etc/apache2/apache2.conf: Could not open configuration file /etc/apache2/ports.conf: Permission denied
Action '-D FOREGROUND' failed.
The Apache error log may have more information.