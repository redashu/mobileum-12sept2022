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



