# PetClinic on Kubernetes

Use a disposable namespace in your current Kubernetes context. The example needs `kubectl`, Bash, and OpenSSL.

```bash
kubectl create namespace petclinic-demo
bash k8s/create-db-secret.sh petclinic-demo
kubectl -n petclinic-demo apply -f k8s/
kubectl -n petclinic-demo rollout status deployment/demo-db --timeout=180s
kubectl -n petclinic-demo rollout status deployment/petclinic --timeout=180s
```

The script generates a database login at runtime and sends the values to `kubectl` over stdin. It creates the namespace-local `demo-db` Secret used by PostgreSQL and by the PetClinic service binding. Keep the same Secret when reapplying the manifests. For an existing deployment, coordinate credential rotation with the database before replacing its Secret.

Delete the example namespace when finished. This removes its workloads, database data, and Secret.

```bash
kubectl delete namespace petclinic-demo
```
