# Kubernetes Quick Reference

## Cluster Management Commands

### Basic Cluster Info
```bash
kubectl cluster-info
kubectl get nodes
kubectl get nodes -o wide
kubectl describe node <node-name>
```

### Namespaces
```bash
kubectl get namespaces
kubectl create namespace <name>
kubectl delete namespace <name>
kubectl config set-context --current --namespace=<name>
```

## Pod Management

### Pod Operations
```bash
kubectl get pods
kubectl get pods -o wide
kubectl get pods --all-namespaces
kubectl describe pod <pod-name>
kubectl logs <pod-name>
kubectl logs -f <pod-name>  # follow logs
kubectl exec -it <pod-name> -- /bin/bash
kubectl delete pod <pod-name>
```

### Create Pods
```bash
kubectl run <pod-name> --image=<image>
kubectl run nginx --image=nginx --restart=Never
kubectl run busybox --image=busybox --command -- sleep 3600
```

## Deployment Management

### Deployment Operations
```bash
kubectl get deployments
kubectl create deployment <name> --image=<image>
kubectl create deployment nginx --image=nginx --replicas=3
kubectl scale deployment <name> --replicas=<number>
kubectl rollout status deployment/<name>
kubectl rollout history deployment/<name>
kubectl rollout undo deployment/<name>
kubectl delete deployment <name>
```

### Deployment Examples
```bash
# Create deployment with resource limits
kubectl create deployment web --image=nginx
kubectl patch deployment web -p '{"spec":{"template":{"spec":{"containers":[{"name":"nginx","resources":{"requests":{"memory":"64Mi","cpu":"100m"},"limits":{"memory":"128Mi","cpu":"200m"}}}]}}}}'
```

## Service Management

### Service Operations
```bash
kubectl get services
kubectl get svc
kubectl describe service <service-name>
kubectl delete service <service-name>
```

### Expose Services
```bash
kubectl expose deployment <deployment-name> --port=80 --type=ClusterIP
kubectl expose deployment <deployment-name> --port=80 --type=NodePort
kubectl expose deployment <deployment-name> --port=80 --target-port=8080 --type=LoadBalancer
```

### Port Forwarding
```bash
kubectl port-forward service/<service-name> 8080:80
kubectl port-forward pod/<pod-name> 8080:80
```

## Configuration Management

### ConfigMaps
```bash
kubectl get configmaps
kubectl create configmap <name> --from-literal=key1=value1 --from-literal=key2=value2
kubectl create configmap <name> --from-file=<file-path>
kubectl describe configmap <name>
kubectl delete configmap <name>
```

### Secrets
```bash
kubectl get secrets
kubectl create secret generic <name> --from-literal=username=admin --from-literal=password=secret
kubectl create secret generic <name> --from-file=<file-path>
kubectl describe secret <name>
kubectl delete secret <name>
```

## Troubleshooting Commands

### Debugging
```bash
kubectl get events
kubectl get events --sort-by='.lastTimestamp'
kubectl describe <resource-type> <resource-name>
kubectl logs <pod-name> --previous  # logs from previous container
kubectl top nodes
kubectl top pods
```

### Resource Inspection
```bash
kubectl get all
kubectl get all -A  # all namespaces
kubectl api-resources
kubectl explain <resource-type>
kubectl explain pod.spec.containers
```

## YAML Manifests

### Apply Manifests
```bash
kubectl apply -f <file.yaml>
kubectl apply -f <directory>/
kubectl apply -f https://example.com/manifest.yaml
kubectl delete -f <file.yaml>
```

### Generate YAML
```bash
kubectl create deployment nginx --image=nginx --dry-run=client -o yaml > deployment.yaml
kubectl expose deployment nginx --port=80 --dry-run=client -o yaml > service.yaml
kubectl run pod --image=nginx --dry-run=client -o yaml > pod.yaml
```

## Useful Commands for This Cluster

### Access Nodes
```bash
# From host machine
vagrant ssh k8s-master
vagrant ssh k8s-worker1
vagrant ssh k8s-worker2

# SSH directly
ssh -p 2220 vagrant@localhost  # master
ssh -p 2221 vagrant@localhost  # worker1
ssh -p 2222 vagrant@localhost  # worker2
```

### Copy kubeconfig to Host
```bash
vagrant ssh k8s-master -c "sudo cat /etc/kubernetes/admin.conf" > kubeconfig
export KUBECONFIG=./kubeconfig
kubectl get nodes
```

### Test Network Connectivity
```bash
# From master node
./test-connectivity.sh

# Test pod networking
kubectl run test-pod --image=busybox --restart=Never -- sleep 3600
kubectl exec test-pod -- nslookup kubernetes.default
kubectl delete pod test-pod
```

### Monitor Cluster
```bash
# Watch pods in real-time
kubectl get pods --watch

# Monitor cluster events
kubectl get events --watch

# Check resource usage
kubectl top nodes
kubectl top pods
```

## Sample Application Deployment

### Simple Web Server
```bash
kubectl create deployment web --image=nginx
kubectl expose deployment web --port=80 --type=NodePort
kubectl get svc web  # Note the NodePort
# Access via http://192.168.56.11:<nodeport> or http://192.168.56.12:<nodeport>
```

### Multi-tier Application
```bash
# Database
kubectl create deployment db --image=postgres:13
kubectl set env deployment/db POSTGRES_PASSWORD=secret
kubectl expose deployment db --port=5432

# Backend API
kubectl create deployment api --image=node:16-alpine
kubectl expose deployment api --port=3000

# Frontend
kubectl create deployment frontend --image=nginx
kubectl expose deployment frontend --port=80 --type=NodePort
```

### Cleanup
```bash
kubectl delete deployment web db api frontend
kubectl delete service web db api frontend
```
