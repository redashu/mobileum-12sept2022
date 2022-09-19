## Training plan 

<img src="plan.png">

## Training plan 

<img src="plan.png">

### lets check connection to k8s cluster 

```
[ashu@mobi-dockerserver myimages]$ kubectl  get  nodes
NAME            STATUS   ROLES           AGE    VERSION
control-plane   Ready    control-plane   6d2h   v1.25.0
node1           Ready    <none>          6d2h   v1.25.0
node2           Ready    <none>          6d2h   v1.25.0
node3           Ready    <none>          6d2h   v1.25.0
[ashu@mobi-dockerserver myimages]$ kubectl config get-contexts 
CURRENT   NAME                          CLUSTER      AUTHINFO           NAMESPACE
*         kubernetes-admin@kubernetes   kubernetes   kubernetes-admin   ashu-project
[ashu@mobi-dockerserver myimages]$ 

```

### Deleting all resources in personal Namespaces 

```
[ashu@mobi-dockerserver myimages]$ kubectl  delete  deploy,svc,hpa --all
No resources found
```

## Introduction to CI & CD 

### for CI& CD purpose we will use -- Jenkins 

<img src="ci.png">


### Understanding CICD 

<img src="cicd.png">



