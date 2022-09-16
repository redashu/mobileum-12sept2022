## Training plan 

<img src="plan.png">

## Namespace 

### namespace for k8s resources Isolation 

<img src="ns.png">

### checking default namespaces 

<img src="ns1.png">

### creating and checking namespaces 

```
[ashu@mobi-dockerserver myimages]$ kubectl  get namespaces 
NAME              STATUS   AGE
default           Active   3d2h
kube-node-lease   Active   3d2h
kube-public       Active   3d2h
kube-system       Active   3d2h
spinnaker         Active   3d1h
```

### creating 

```
[ashu@mobi-dockerserver myimages]$ kubectl  create  namespace  ashu-project 
namespace/ashu-project created
[ashu@mobi-dockerserver myimages]$ kubectl   get  ns
NAME              STATUS   AGE
ashu-project      Active   4s
default           Active   3d2h
fjv               Active   17s
kube-node-lease   Active   3d2h
kube-public       Active   3d2h
kube-system       Active   3d2h
sofia-project     Active   2s
spinnaker         Active   3d1h
```


### setting default namespace to k8s client user 

```
[ashu@mobi-dockerserver myimages]$ kubectl  config set-context --current --namespace=ashu-project  
Context "kubernetes-admin@kubernetes" modified.
[ashu@mobi-dockerserver myimages]$ 
[ashu@mobi-dockerserver myimages]$ kubectl  get  pods
No resources found in ashu-project namespace.
[ashu@mobi-dockerserver myimages]$ 
[ashu@mobi-dockerserver myimages]$ 
[ashu@mobi-dockerserver myimages]$ 
[ashu@mobi-dockerserver myimages]$ 
[ashu@mobi-dockerserver myimages]$ kubectl  config get-contexts 
CURRENT   NAME                          CLUSTER      AUTHINFO           NAMESPACE
*         kubernetes-admin@kubernetes   kubernetes   kubernetes-admin   ashu-project
```

### all k8s control plane components are running in Kube-system namespaces 

```
[ashu@mobi-dockerserver myimages]$ kubectl  get  pods  -n kube-system 
NAME                                       READY   STATUS    RESTARTS        AGE
calico-kube-controllers-58dbc876ff-d2jj8   1/1     Running   3 (5h41m ago)   3d2h
calico-node-bqpv6                          1/1     Running   3 (5h41m ago)   3d2h
calico-node-ggglc                          1/1     Running   3 (5h41m ago)   3d2h
calico-node-xdtwj                          1/1     Running   3 (5h41m ago)   3d2h
calico-node-zp89l                          1/1     Running   3 (5h41m ago)   3d2h
coredns-565d847f94-jtnr5                   1/1     Running   3 (5h41m ago)   3d2h
coredns-565d847f94-jwjxl                   1/1     Running   3 (5h41m ago)   3d2h
etcd-control-plane                         1/1     Running   3 (5h41m ago)   3d2h
kube-apiserver-control-plane               1/1     Running   3 (5h41m ago)   3d2h
kube-controller-manager-control-plane      1/1     Running   3 (5h41m ago)   3d2h
kube-proxy-8fptn                           1/1     Running   3 (5h41m ago)   3d2h
kube-proxy-l5pkn                           1/1     Running   3 (5h41m ago)   3d2h
kube-proxy-skdn2                           1/1     Running   3 (5h41m ago)   3d2h
kube-proxy-vpscw                           1/1     Running   3 (5h41m ago)   3d2h
kube-scheduler-control-plane               1/1     Running   3 (5h41m ago)   3d2h
metrics-server-767967fcd-jq7pr             1/1     Running   3 (5h41m ago)   3d2h
[ashu@mobi-dockerserver myimages]$ 
```

### Namespace and Networking 

<img src="ns3.png">

### k8s networking resources 

<img src="net4.png">

## Demo -- POd -- SVc 

### creating pod yaml 

```
[ashu@mobi-dockerserver myimages]$ cd k8s-resources/
[ashu@mobi-dockerserver k8s-resources]$ ls
ashupod1.yaml  autopod.yaml  logs.txt  nodeport.yaml  q1.yaml
[ashu@mobi-dockerserver k8s-resources]$ kubectl   run ashuwebapp --image=docker.io/dockerashu/ashuapp:mobiv11  --port 80 --dry-run=client -o yaml  >webpod.yaml 
[ashu@mobi-dockerserver k8s-resources]$ 

```

### modify YAML 

```
apiVersion: v1
kind: Pod
metadata:
  namespace: ashu-project # namespace info 
  creationTimestamp: null
  labels: # label of pod 
    x: helloashu # creating new label 
  name: ashuwebapp # name of pod 
spec:
  containers:
  - image: docker.io/dockerashu/ashuapp:mobiv11 # image from docker hub 
    name: ashuwebapp # name of container 
    ports: # container app port 
    - containerPort: 80
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}

```

### deploy POD 

```
[ashu@mobi-dockerserver k8s-resources]$ ls
ashupod1.yaml  autopod.yaml  logs.txt  nodeport.yaml  q1.yaml  webpod.yaml
[ashu@mobi-dockerserver k8s-resources]$ kubectl  apply -f  webpod.yaml 
pod/ashuwebapp created
[ashu@mobi-dockerserver k8s-resources]$ kubectl  get  pods
NAME         READY   STATUS    RESTARTS   AGE
ashuwebapp   1/1     Running   0          4s
[ashu@mobi-dockerserver k8s-resources]$ kubectl  get  pods -o wide
NAME         READY   STATUS    RESTARTS   AGE   IP               NODE    NOMINATED NODE   READINESS GATES
ashuwebapp   1/1     Running   0          10s   192.168.135.49   node3   <none>           <none>
[ashu@mobi-dockerserver k8s-resources]$ 


```

### creating Nodeport service 

```
kubectl   create  service  nodeport ashuwebsvc --tcp 1234:80 --dry-run=client -o yaml     >websvc.yaml 
```

### deploy svc 

```
[ashu@mobi-dockerserver k8s-resources]$ kubectl   create  service  nodeport ashuwebsvc --tcp 1234:80 --dry-run=client -o yaml     >websvc.yaml 
[ashu@mobi-dockerserver k8s-resources]$ kubectl  apply -f websvc.yaml 
service/ashuwebsvc created
[ashu@mobi-dockerserver k8s-resources]$ kubectl  get  svc
NAME         TYPE       CLUSTER-IP     EXTERNAL-IP   PORT(S)          AGE
ashuwebsvc   NodePort   10.107.95.29   <none>        1234:32300/TCP   28s
[ashu@mobi-dockerserver k8s-resources]$ 
[ashu@mobi-dockerserver k8s-resources]$ kubectl  get  ep 
NAME         ENDPOINTS   AGE
ashuwebsvc   <none>      33s
[ashu@mobi-dockerserver k8s-resources]$ 


```

### service YAML modification 

```
apiVersion: v1
kind: Service
metadata:
  namespace: ashu-project 
  creationTimestamp: null
  labels:
    app: ashuwebsvc
  name: ashuwebsvc
spec:
  ports:
  - name: 1234-80
    port: 1234
    protocol: TCP
    targetPort: 80
  selector: # pod finder using pod label 
    x: helloashu # label of pod 
  type: NodePort
status:
  loadBalancer: {}

```

### redeploy 

```
[ashu@mobi-dockerserver k8s-resources]$ kubectl  apply -f websvc.yaml 
service/ashuwebsvc configured
[ashu@mobi-dockerserver k8s-resources]$ kubectl  get svc -o wide
NAME         TYPE       CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE    SELECTOR
ashuwebsvc   NodePort   10.107.108.104   <none>        1234:31604/TCP   115s   x=helloashu
[ashu@mobi-dockerserver k8s-resources]$ 
[ashu@mobi-dockerserver k8s-resources]$ kubectl  get  ep 
NAME         ENDPOINTS           AGE
ashuwebsvc   192.168.135.49:80   2m3s
[ashu@mobi-dockerserver k8s-resources]$ kubectl  get po -o wide
NAME         READY   STATUS    RESTARTS   AGE   IP               NODE    NOMINATED NODE   READINESS GATES
ashuwebapp   1/1     Running   0          17m   192.168.135.49   node3   <none>           <none>
```


