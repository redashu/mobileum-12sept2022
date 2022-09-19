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

## Steps 

### creating gitrepo and clone it to docker server 

```
[ashu@mobi-dockerserver myimages]$ git clone  https://github.com/redashu/ashumobi-ci.git
Cloning into 'ashumobi-ci'...
remote: Enumerating objects: 3, done.
remote: Counting objects: 100% (3/3), done.
remote: Total 3 (delta 0), reused 0 (delta 0), pack-reused 0
Receiving objects: 100% (3/3), done.
[ashu@mobi-dockerserver myimages]$ ls
ashu-compose   ashu-javawebapp  ashu-multistage  k8s-resources  webapps_ashu
ashu-customer  ashumobi-ci      javacode         pythoncode
[ashu@mobi-dockerserver myimages]$ cd  ashumobi-ci/
[ashu@mobi-dockerserver ashumobi-ci]$ 

```

### step 2 pushing code to github 

```
 git  add . 
[ashu@mobi-dockerserver ashumobi-ci]$ ls
Dockerfile  docker.png  index.html  README.md
[ashu@mobi-dockerserver ashumobi-ci]$ git commit -m  "app code v1 "
Author identity unknown

*** Please tell me who you are.

Run

  git config --global user.email "you@example.com"
  git config --global user.name "Your Name"

to set your account's default identity.
Omit --global to set the identity only in this repository.

fatal: unable to auto-detect email address (got 'ashu@mobi-dockerserver.(none)')
[ashu@mobi-dockerserver ashumobi-ci]$ git config --global user.email ashutoshh@linux.com
[ashu@mobi-dockerserver ashumobi-ci]$ git config --global user.name  redashu

===
[ashu@mobi-dockerserver ashumobi-ci]$ git push origin master
Enumerating objects: 7, done.
Counting objects: 100% (7/7), done.
Delta compression using up to 2 threads
Compressing objects: 100% (5/5), done.
Writing objects: 100% (6/6), 19.39 KiB | 19.39 MiB/s, done.
Total 6 (delta 0), reused 0 (delta 0), pack-reused 0
To https://github.com/redashu/ashumobi-ci.git
   f43c4c4..2d82d8a  master -> master
```

### configuring auto build trigger in Jenkins using poll scm 

<img src="trigger.png">

### creating YAML for application Deployment 

```
kubectl create deployment ashu-app --image=dockerashu/ashumobiwebapp:latest  --port 80 --dry-run=client -o yaml  >deployment.yaml 
```
### adding changes 

```
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels: # label  
    app: ashu-app
  name: ashu-app # name of deployment 
  namespace: ashu-project # namespace info 
spec:
  replicas: 1
  selector:
    matchLabels:
      app: ashu-app
  strategy: {}
  template: # to create pods 
    metadata:
      creationTimestamp: null
      labels: # label of pdo 
        app: ashu-app
    spec:
      containers:
      - image: dockerashu/ashumobiwebapp:latest
        name: ashumobiwebapp
        ports:
        - containerPort: 80
        resources: # for pha purpose 
          requests:
            cpu: 100m
            memory: 300M  
          limits:
            cpu: 200m 
            memory: 600M 
status: {}

```

### creating service YAML 

```
kubectl  create  service loadbalancer  ashulb1  --tcp 1234:80 --dry-run=client -o yaml >loadbalancer.yaml 
```

### adding changes 

```
apiVersion: v1
kind: Service
metadata:
  creationTimestamp: null
  labels:
    app: ashulb1
  name: ashulb1 # name of service 
  namespace: ashu-project # name space 
spec:
  ports:
  - name: 1234-80
    port: 1234
    protocol: TCP
    targetPort: 80
  selector: # pod finder 
     app: ashu-app # exact label of pods 
  type: LoadBalancer
status:
  loadBalancer: {}

```

### creating HPA yaml 

```
 784  kubectl apply -f deployment.yaml 

  786  kubectl autoscale deployment ashu-app --cpu-percent 70 --min 3 --max 15  --dry-run=client -o yaml   >hpa.yaml 
  787  kubectl  delete -f deployment.yaml 
```

### adding changes in Hpa.yaml 
```
apiVersion: autoscaling/v1
kind: HorizontalPodAutoscaler
metadata:
  creationTimestamp: null
  name: ashu-app # name of hpa
  namespace: ashu-project # namespace info 
spec:
  maxReplicas: 15
  minReplicas: 3
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: ashu-app
  targetCPUUtilizationPercentage: 70
status:
  currentReplicas: 0
  desiredReplicas: 0

```

### lets create and verify 

```
[ashu@mobi-dockerserver app-deploy]$ ls
deployment.yaml  hpa.yaml  loadbalancer.yaml
[ashu@mobi-dockerserver app-deploy]$ kubectl apply -f . 
deployment.apps/ashu-app created
horizontalpodautoscaler.autoscaling/ashu-app created
service/ashulb1 created
[ashu@mobi-dockerserver app-deploy]$ kubectl  get  deploy 
NAME       READY   UP-TO-DATE   AVAILABLE   AGE
ashu-app   3/3     3            3           26s
[ashu@mobi-dockerserver app-deploy]$ kubectl  get  svc
NAME      TYPE           CLUSTER-IP     EXTERNAL-IP   PORT(S)          AGE
ashulb1   LoadBalancer   10.97.92.123   <pending>     1234:31642/TCP   29s
[ashu@mobi-dockerserver app-deploy]$ kubectl  get  hpa
NAME       REFERENCE             TARGETS         MINPODS   MAXPODS   REPLICAS   AGE
ashu-app   Deployment/ashu-app   <unknown>/70%   3         15        3          34s
[ashu@mobi-dockerserver app-deploy]$ 

```

## lets roll out changes in new image version 

```
[ashu@mobi-dockerserver app-deploy]$ kubectl  get  deploy 
NAME       READY   UP-TO-DATE   AVAILABLE   AGE
ashu-app   3/3     3            3           11m
[ashu@mobi-dockerserver app-deploy]$ kubectl  rollout restart deployment ashu-app 
deployment.apps/ashu-app restarted
[ashu@mobi-dockerserver app-deploy]$ kubectl  rollout status  deployment ashu-app 
deployment "ashu-app" successfully rolled out
[ashu@mobi-dockerserver app-deploy]$ kubectl  get  po 
NAME                        READY   STATUS        RESTARTS   AGE
ashu-app-6bd95ffd9d-qkvgt   1/1     Running       0          15s
ashu-app-6bd95ffd9d-rvc2h   1/1     Running       0          12s
ashu-app-6bd95ffd9d-vj8vk   1/1     Running       0          14s
ashu-app-6d9d9b8578-7dv5l   1/1     Terminating   0          11m
[ashu@mobi-dockerserver app-deploy]$ 
```

### ReadinessProbe In kubernetes 

<img src="readiness.png">

### adding in deployment yaml in pod template section 

```
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels: # label  
    app: ashu-app
  name: ashu-app # name of deployment 
  namespace: ashu-project # namespace info 
spec:
  replicas: 1
  selector:
    matchLabels:
      app: ashu-app
  strategy: {}
  template: # to create pods 
    metadata:
      creationTimestamp: null
      labels: # label of pdo 
        app: ashu-app
    spec:
      containers:
      - image: dockerashu/ashumobiwebapp:latest
        name: ashumobiwebapp
        ports:
        - containerPort: 80
        readinessProbe: # call by kubelet to do a health check
          httpGet: # using http protocol
            path: /health.html 
            port: 80 
          initialDelaySeconds: 3 # after pod deploy need 3 seconds 
          periodSeconds: 10 # health check interval 
        resources: # for pha purpose 
          requests:
            cpu: 100m
            memory: 300M  
          limits:
            cpu: 200m 
            memory: 600M 
status: {}

```




