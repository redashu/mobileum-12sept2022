## Training plan 

<img src="plan.png">

### Revision 

<img src="rev.png">

### Ingress controller 

<img src="ig.png">

### clusterIP type service -- for internal exposing app 

<img src="svc1.png">

### creating clusterIP type service 

```
kubectl create service clusterip  ashulb001 --tcp 1234:80 --dry-run=client -o yaml >clusterip.yaml 
```

### updated service yaml 

```
apiVersion: v1
kind: Service
metadata:
  creationTimestamp: null
  labels:
    app: ashulb001
  name: ashulb001
  namespace: ashu-project # adding namespace 
spec:
  ports:
  - name: 1234-80
    port: 1234
    protocol: TCP
    targetPort: 80
  selector: # updating label of pods 
    app: ashu-app
  type: ClusterIP # type of service 
status:
  loadBalancer: {}

```

### creating ingress object for routing rules 

```
[ashu@mobi-dockerserver ~]$ kubectl api-resources |   grep -i ingress
ingressclasses                                 networking.k8s.io/v1                   false        IngressClass
ingresses                         ing          networking.k8s.io/v1                   true         Ingress
[ashu@mobi-dockerserver ~]$ 



```

### lets deploy all yaml 

```
ashu@mobi-dockerserver app-deploy]$ kubectl apply -f  . 
service/ashulb001 created
deployment.apps/ashu-app created
horizontalpodautoscaler.autoscaling/ashu-app created
ingress.networking.k8s.io/ashu-ingress-rule created
[ashu@mobi-dockerserver app-deploy]$ 
[ashu@mobi-dockerserver app-deploy]$ kubectl  get  deploy
NAME       READY   UP-TO-DATE   AVAILABLE   AGE
ashu-app   1/1     1            1           14s
[ashu@mobi-dockerserver app-deploy]$ kubectl  get  po
NAME                       READY   STATUS    RESTARTS   AGE
ashu-app-6fb456798-tp66x   1/1     Running   0          5s
ashu-app-6fb456798-wdpl4   1/1     Running   0          20s
ashu-app-6fb456798-x7g8p   1/1     Running   0          5s
[ashu@mobi-dockerserver app-deploy]$ kubectl  get  svc
NAME        TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
ashulb001   ClusterIP   10.101.37.116   <none>        1234/TCP   24s
[ashu@mobi-dockerserver app-deploy]$ kubectl  get  hpa
NAME       REFERENCE             TARGETS         MINPODS   MAXPODS   REPLICAS   AGE
ashu-app   Deployment/ashu-app   <unknown>/70%   3         15        3          35s
[ashu@mobi-dockerserver app-deploy]$ kubectl  get  ingress
NAME                CLASS   HOSTS                 ADDRESS        PORTS   AGE
ashu-ingress-rule   nginx   jaipur.ashutoshh.in   172.31.83.42   80      40s
[ashu@mobi-dockerserver app-deploy]$ 
```


### Ingress traffic flow 

<img src="ingresstr.png">

## Dashboard 

### Deploy 

```
[ashu@mobi-dockerserver ~]$ kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.6.1/aio/deploy/recommended.yaml
namespace/kubernetes-dashboard created
serviceaccount/kubernetes-dashboard created
service/kubernetes-dashboard created
secret/kubernetes-dashboard-certs created
secret/kubernetes-dashboard-csrf created
secret/kubernetes-dashboard-key-holder created
configmap/kubernetes-dashboard-settings created
role.rbac.authorization.k8s.io/kubernetes-dashboard created
clusterrole.rbac.authorization.k8s.io/kubernetes-dashboard created
rolebinding.rbac.authorization.k8s.io/kubernetes-dashboard created
clusterrolebinding.rbac.authorization.k8s.io/kubernetes-dashboard created
deployment.apps/kubernetes-dashboard created
service/dashboard-metrics-scraper created
deployment.apps/dashboard-metrics-scraper created
```

### verify 

```
kubectl get all -n kubernetes-dashboard
```

### checking token 

```
[ashu@mobi-dockerserver ~]$ kubectl  describe secrets cicd -n kubernetes-dashboard 
Name:         cicd
Namespace:    kubernetes-dashboard
Labels:       <none>
Annotations:  kubernetes.io/service-account.name: kubernetes-dashboard
              kubernetes.io/service-account.uid: 342f02cc-b8d3-4f37-84d1-1a696a8c0a5e

Type:  kubernetes.io/service-account-token

Data
====
ca.crt:     1099 bytes
namespace:  20 bytes
token:      eyJhbGciOiJSUzI1Ni
```

### giving power to k8s dashboard to access application 

```
kubectl create clusterrolebinding power1 --clusterrole cluster-admin --serviceaccount=kubernetes-dashboard:kubernetes-dashboard
clusterrolebinding.rbac.authorization.k8s.io/power1 created
```


### SIngle yaml task solution 

```
apiVersion: v1
kind: Namespace
metadata:
  creationTimestamp: null
  name: ashuk8s1
spec: {}
status: {}
---
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: pod1
  name: pod1
  namespace: ashuk8s1
spec:
  containers:
  - command:
    - sleep
    - "10000"
    image: ubuntu
    name: pod1
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}

---
apiVersion: v1
kind: Service
metadata:
  creationTimestamp: null
  labels:
    app: ashusvc1
  name: ashusvc1
  namespace: ashuk8s1
spec:
  ports:
  - name: 1234-80
    port: 1234
    protocol: TCP
    targetPort: 80
    nodePort: 31111
  selector:
    app: ashusvc1
  type: NodePort
status:
  loadBalancer: {}
```

### deploy it 

```
[ashu@mobi-dockerserver k8s-resources]$ kubectl apply -f mytask.yaml 
namespace/ashuk8s1 created
pod/pod1 created
service/ashusvc1 created
[ashu@mobi-dockerserver k8s-resources]$ kubectl get po,svc -n ashuk8s1 
NAME       READY   STATUS    RESTARTS   AGE
pod/pod1   1/1     Running   0          10s

NAME               TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
service/ashusvc1   NodePort   10.97.213.189   <none>        1234:31111/TCP   10s
[ashu@mobi-dockerserver k8s-resources]$ kubectl -n ashuk8s1 cp  q1.yaml   pod1:/tmp/
[ashu@mobi-dockerserver k8s-resources]$ 
```

### commands to create YAML 

```
 894  kubectl create ns  ashuk8s1  --dry-run=client -o yaml 
  895  kubectl run pod1 --image=ubuntu --command sleep 10000 --namespace ashuk8s1 --dry-run=client -o yaml 
  896  history 
  897  kubectl create service nodeport  ashusvc1 --tcp 1234:80 --namespace ashuk8s1 --dry-run=client -o yaml 
```

##  Storage in Kubernetes 

<img src="st.png">

### Deploy postgresql in k8s using deployment 

<img src="postg.png">

### creating a deployment File 

```
kubectl  create  deployment  ashu-postgre-db --image=postgres --port=5432  --dry-run=client -o yaml  >postgre_deployment.yaml 
```

### creating configMap to store Env section of Deployment 

```
[ashu@mobi-dockerserver k8s-resources]$ kubectl  create configmap  ashu-db-env --from-literal POSTGRES_USER="admin" --from-literal POSTGRES_PASSWORD="Db@098#" --dry-run=client -o yaml 
apiVersion: v1
data:
  POSTGRES_PASSWORD: Db@098#
  POSTGRES_USER: admin
kind: ConfigMap
metadata:
  creationTimestamp: null
  name: ashu-db-env
[ashu@mobi-dockerserver k8s-resources]$ kubectl  create configmap  ashu-db-env --from-literal POSTGRES_USER="admin" --from-literal POSTGRES_PASSWORD="Db@098#" --dry-run=client -o yaml  >configmap.yaml
[ashu@mobi-dockerserver k8s-resources]$ 

```

### creating cm 

```
[ashu@mobi-dockerserver k8s-resources]$ kubectl apply -f configmap.yaml 
configmap/ashu-db-env created
[ashu@mobi-dockerserver k8s-resources]$ kubectl  get  cm 
NAME               DATA   AGE
ashu-db-env        2      4s
```

### adding storage hostPath in deployment and final yaml 

```
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: ashu-postgre-db
  name: ashu-postgre-db
spec:
  replicas: 1
  selector:
    matchLabels:
      app: ashu-postgre-db
  strategy: {}
  template: # for creating pods 
    metadata:
      creationTimestamp: null
      labels:
        app: ashu-postgre-db
    spec:
      volumes: # for creating volume 
      - name: ashuvol1 
        hostPath: # type of volume --gonna take storage from Node 
          path: /mnt/ashudb/ # using this location on the node
          type: DirectoryOrCreate # if not present then create it 
      containers:
      - image: postgres
        name: postgres
        ports:
        - containerPort: 5432
        envFrom: # calling configMap
        - configMapRef:
            name: ashu-db-env # name of cofigmap 
        volumeMounts: # to attach volume created above
        - name: ashuvol1
          mountPath: /var/lib/postgresql/data/ # default db storage of postgres
        
        resources: {}
status: {}

```

###lets deploy it 

```
[ashu@mobi-dockerserver k8s-resources]$ kubectl apply -f postgre_deployment.yaml 
deployment.apps/ashu-postgre-db created
[ashu@mobi-dockerserver k8s-resources]$ kubectl  get  deploy 
NAME              READY   UP-TO-DATE   AVAILABLE   AGE
ashu-postgre-db   1/1     1            1           4s
[ashu@mobi-dockerserver k8s-resources]$ kubectl  get  po
NAME                               READY   STATUS    RESTARTS   AGE
ashu-postgre-db-5b58fc8588-mr5g5   1/1     Running   0          8s
[ashu@mobi-dockerserver k8s-resources]$ 

```

## Introduction to secret 

<img src="secret.png">

### creating secret. 

```
 917  kubectl  create  secret  generic  ashu-db-sec --from-literal        sqlpassword="Db@098#" --dry-run=client -o yaml >dbsecret.yaml 
  918  history 
[ashu@mobi-dockerserver k8s-resources]$ kubectl  apply -f dbsecret.yaml 
secret/ashu-db-sec created
[ashu@mobi-dockerserver k8s-resources]$ kubectl  get  secret
NAME          TYPE     DATA   AGE
ashu-db-sec   Opaque   1      4s
```

### calling in deployment YAML 

```
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: ashu-postgre-db
  name: ashu-postgre-db
spec:
  replicas: 1
  selector:
    matchLabels:
      app: ashu-postgre-db
  strategy: {}
  template: # for creating pods 
    metadata:
      creationTimestamp: null
      labels:
        app: ashu-postgre-db
    spec:
      volumes: # for creating volume 
      - name: ashuvol1 
        hostPath: # type of volume --gonna take storage from Node 
          path: /mnt/ashudb/ # using this location on the node
          type: DirectoryOrCreate # if not present then create it 
      containers:
      - image: postgres
        name: postgres
        ports:
        - containerPort: 5432
        envFrom: # calling configMap
        - configMapRef:
            name: ashu-db-env # name of cofigmap 
        env: # calling env 
        - name: POSTGRES_PASSWORD
          valueFrom:
            secretKeyRef:
              name: ashu-db-sec
              key: sqlpassword
        volumeMounts: # to attach volume created above
        - name: ashuvol1
          mountPath: /var/lib/postgresql/data/ # default db storage of postgres
        
        resources: {}
status: {}

```

### redeploy it 

```
[ashu@mobi-dockerserver k8s-resources]$ kubectl  apply -f dbsecret.yaml -f configmap.yaml -f postgre_deployment.yaml 
secret/ashu-db-sec configured
configmap/ashu-db-env configured
deployment.apps/ashu-postgre-db created
[ashu@mobi-dockerserver k8s-resources]$ kubectl  get  cm,secret,deploy
NAME                         DATA   AGE
configmap/ashu-db-env        1      34m
configmap/kube-root-ca.crt   1      22h

NAME                 TYPE     DATA   AGE
secret/ashu-db-sec   Opaque   1      4m26s

NAME                              READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/ashu-postgre-db   1/1     1            1           28s
```





