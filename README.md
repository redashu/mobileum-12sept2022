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

