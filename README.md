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

### cleaning namespace data 

```
[ashu@mobi-dockerserver k8s-resources]$ kubectl delete all --all
pod "ashu-postgre-db-7bcf848ff9-l99vx" deleted
deployment.apps "ashu-postgre-db" deleted
replicaset.apps "ashu-postgre-db-7bcf848ff9" deleted
[ashu@mobi-dockerserver k8s-resources]$ kubectl delete cm,secret --all
configmap "ashu-db-env" deleted
configmap "kube-root-ca.crt" deleted
secret "ashu-db-sec" deleted
[ashu@mobi-dockerserver k8s-resources]$ 
```

### using multi container pod concept 

<img src="mcpod.png">

### understanding mounting concept 

<img src="mount.png">

### YAML 

```
apiVersion: v1
kind: Pod
metadata:
  name: ashu-mcpod
  labels: # label of pod 
    x: helloashu
    z: hiashu
spec: 
  volumes: # creating volume 
  - name: ashutest-vol1
    hostPath:
      path: /mnt/ashudata
      type: DirectoryOrCreate 
  containers:  # creating container 
  - name: ashuc2 
    image: nginx 
    volumeMounts:
    - name: ashutest-vol1
      mountPath: /usr/share/nginx/html/
      readOnly: True 
  - name: ashuc1
    image: alpine 
    volumeMounts:
    - name: ashutest-vol1
      mountPath: /opt/data/
    command: ['/bin/sh','-c','while true;do uptime >>/opt/data/load.txt;sleep 10;done']
```

### Deploy it 

```
[ashu@mobi-dockerserver k8s-resources]$ kubectl apply -f multi-container.yaml 
pod/ashu-mcpod created
[ashu@mobi-dockerserver k8s-resources]$ kubectl  get  po 
NAME         READY   STATUS    RESTARTS   AGE
ashu-mcpod   2/2     Running   0          4s
[ashu@mobi-dockerserver k8s-resources]$ 

```

### verify it 

```
[ashu@mobi-dockerserver ~]$ kubectl  get  po 
NAME         READY   STATUS    RESTARTS   AGE
ashu-mcpod   2/2     Running   0          75s
[ashu@mobi-dockerserver ~]$ kubectl  exec -it  ashu-mcpod  -- bash 
Defaulted container "ashuc2" out of: ashuc2, ashuc1
root@ashu-mcpod:/# 
root@ashu-mcpod:/# 
root@ashu-mcpod:/# 
root@ashu-mcpod:/# cd  /usr/share/nginx/html/
root@ashu-mcpod:/usr/share/nginx/html# ls
load.txt
root@ashu-mcpod:/usr/share/nginx/html# rm load.txt 
rm: cannot remove 'load.txt': Read-only file system
root@ashu-mcpod:/usr/share/nginx/html# 
exit
command terminated with exit code 1
[ashu@mobi-dockerserver ~]$ kubectl  exec -it  ashu-mcpod  -c ashuc1 -- sh 
/ # cd /opt/data/
/opt/data # ls
load.txt
/opt/data # mkdir hhhelloo
/opt/data # ls
hhhelloo  load.txt
/opt/data # exit
[ashu@mobi-dockerserver ~]$ 
```
### exposing pod with Nodeport service 

```
[ashu@mobi-dockerserver ~]$ kubectl  get po --show-labels 
NAME         READY   STATUS    RESTARTS   AGE   LABELS
ashu-mcpod   2/2     Running   0          13m   x=helloashu,z=hiashu
[ashu@mobi-dockerserver ~]$ 
[ashu@mobi-dockerserver ~]$ kubectl expose pod ashu-mcpod --type  NodePort --port 80 --name ashulb008 
service/ashulb008 exposed
[ashu@mobi-dockerserver ~]$ kubectl  get  svc
NAME        TYPE       CLUSTER-IP       EXTERNAL-IP   PORT(S)        AGE
ashulb008   NodePort   10.109.144.186   <none>        80:31982/TCP   3s
[ashu@mobi-dockerserver ~]$ kubectl  get po --show-labels 
NAME         READY   STATUS              RESTARTS   AGE   LABELS
ashu-mcpod   0/2     ContainerCreating   0          0s    x=helloashu,z=hiashu
[ashu@mobi-dockerserver ~]$ kubectl  get po --show-labels 
NAME         READY   STATUS    RESTARTS   AGE   LABELS
ashu-mcpod   2/2     Running   0          4s    x=helloashu,z=hiashu
[ashu@mobi-dockerserver ~]$ 

```
## Understanding users in k8s 

<img src="user.png">

## creating kubeconfig file with limited access 

### creating NS 

```
[ashu@mobi-dockerserver k8s-resources]$ kubectl  create  ns  ashu-restricted 
namespace/ashu-restricted created
[ashu@mobi-dockerserver k8s-resources]$ kubectl  get  sa -n ashu-restricted 
NAME      SECRETS   AGE
default   0         41s
[ashu@mobi-
```

### from k8s 1.24 onwards we have to create secret 

```
apiVersion: v1
kind: Secret
type: kubernetes.io/service-account-token
metadata:
  name: ashu-sa-secret # name of secret 
  namespace: ashu-restriced  # namespace 
  annotations:
    kubernetes.io/service-account.name: "default" # name of sa 
```

### creating 

```
[ashu@mobi-dockerserver k8s-resources]$ kubectl apply -f sa-secret.yaml 
secret/ashu-sa-secret created
[ashu@mobi-dockerserver k8s-resources]$ kubectl  get  sa -n ashu-restricted 
NAME      SECRETS   AGE
default   0         6m4s
[ashu@mobi-dockerserver k8s-resources]$ kubectl  get  secret  -n ashu-restricted 
NAME             TYPE                                  DATA   AGE
ashu-sa-secret   kubernetes.io/service-account-token   3      15s
[ashu@mobi-dockerserver k8s-resources]$ 


```

### kubeconfig file 

```
apiVersion: v1
kind: Config 
clusters:
- name: ashu-k8s-cluster-dev-env 
  cluster: 
    server: https://44.209.211.99:6443 # apiserver URL 
    certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUMvakNDQWVhZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwcmRXSmwKY201bGRHVnpNQjRYRFRJeU1Ea3hNekExTkRFeU0xb1hEVE15TURreE1EQTFOREV5TTFvd0ZURVRNQkVHQTFVRQpBeE1LYTNWaVpYSnVaWFJsY3pDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBS3JkCnFtN1BnSUZHVGpVUjhWMTNOV2pBeGFmeHNlT25wVm85SG51aVd2cDFkbHVWT1YrQUtRTmpFc1ZEMTcvVTVxVlkKNytWSVUwc3pHWTNhWk9SdE5vSTRGRU5LMThWZk1qckJUejZCM1MwcVVWVTBPamhKNFpWeDhoNlMxUE1idHNnZQpCVmExalc5YkpnaS9CWnFmdHgzRFN3T3N1WDlwV3d1dFA1SCtLRXNHa2JTUmtpYTNzQU41UTBJQ21oS1RUWkxtCjNRb3dscnQ4K2pXVTBzUjdkU2JGdVd5YjUxZGx2cVA4a2lvOXExemdWZE9FN1FrSGRiNklNUHg4SG1XU0tIMmgKa1NMZGxnaCtraTJpMnRtNHJwSFVpNi9UVjlXWUo5K2xxSHhWMFcxSWFUSmtrV2pkelppcjRrSXJWMTl0Z0JLMApkRktDKzI2N1lvcjE3bDZxSmxNQ0F3RUFBYU5aTUZjd0RnWURWUjBQQVFIL0JBUURBZ0trTUE4R0ExVWRFd0VCCi93UUZNQU1CQWY4d0hRWURWUjBPQkJZRUZKcXJmQjJKc25YRW9yZzkweE1aQmZWcld2UERNQlVHQTFVZEVRUU8KTUF5Q0NtdDFZbVZ5Ym1WMFpYTXdEUVlKS29aSWh2Y05BUUVMQlFBRGdnRUJBQmZwbnIvZHNSbmlxSHZDdzJnOQpobFAwSXFmallTbW5yWkYwSzhxYjFtUWNtbWJBWkc2OWVsSURIR2lIZHE0NTBJNC80T3JLY3Y2TTBmd2tkMy95CjJkcnJVV2xhUHFZdVYxc1lWYUZPVFIyU1p3SkRCTzZoY1NzbDJPL0pDVVNYMGRVSVZPMXZkakNzOHNEc0czNloKRHlaaU5adGl3dVJaRzR6SzB0VVpReFRMVEFaRGl2SFVwT0RMZWlseFB0ZmtySW9LSVJBQ25YYXZOU29nL2ZTNQpMb1A1RHB3ejU1Yi9lUUkrMXc3L0JEYyt2WjlaZERxenZQUWo3N0RKZHJEaHM0OHovdWpEZXN4clpHK0NYV29CCmFDaXRmZkk1Qk9UZVd0RTZRQWxSNE5LTkk1b3NOSXNVbDJiTk1lWEdBVFpKcEtnb05PZnNmZ2JDM3o3OW0xNW8KUjRvPQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==
contexts:
- name: ashu-dev-app-env 
  context: 
    namespace: ashu-restricted
    cluster: ashu-k8s-cluster-dev-env
    user: default # service account name 
current-context: ashu-dev-app-env
users: 
- name: default # name of sa 
  user: # user secret data 
    token: eyJhbGciOiJSUzI1NiIsImtpZCI6ImRCMGlfQWRtLXY3WFZpbmlGVmtpZFV5RlhHSVlwLU03YU5RRUJHcmlIMkkifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJhc2h1LXJlc3RyaWN0ZWQiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlY3JldC5uYW1lIjoiYXNodS1zYS1zZWNyZXQiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC5uYW1lIjoiZGVmYXVsdCIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50LnVpZCI6IjU3MmQ5ZGVjLTkxNGUtNDYwZi04YzZmLWI0Yjg2NGNlMzIxZiIsInN1YiI6InN5c3RlbTpzZXJ2aWNlYWNjb3VudDphc2h1LXJlc3RyaWN0ZWQ6ZGVmYXVsdCJ9.p6TSMdHnWCdl5vVN5ajbHjQQx7TWc4mbWMoKK7fjifZsasBi_qe7jNu6-nXdoV136nofUwGyA5ZJTeTynaOegZmYsATNV0jD1hD71T0cvd9Hy9G2Fp_J3g0aHNK3A9z7NyRyhPBuNORzaHJtIBQ-51PjRhKKa13-qSZKU2wulb4jCHtrUcy7mBF71Bdl9W5c243xTYRgxLRKtKKHoItEXQ1PnbJ5FmGvG34dm80XPPW_-k-9NKYztMuy8gs9HHcdGeprXUCmZ7ZrH8J5uCWr68I-6QZbb1Hb_eaS7BYtvF-UYW6Q8cutHKP8ZjxBNy5Wvs7dQMrAyILM09VlO9ttmg
```

### token you can find using secret describe of service account 

```
 kubectl describe  secret  ashu-sa-secret   -n ashu-restricted 
```
### now using that file to authentication k8s 

```
  936  kubectl  get  nodes --kubeconfig customk8s.yaml 
  937  kubectl  cluster-info --kubeconfig customk8s.yaml 
  938  kubectl version  --kubeconfig customk8s.yaml 
  939  history 
[ashu@mobi-dockerserver myimages]$ kubectl  cluster-info --kubeconfig customk8s.yaml 

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
Error from server (Forbidden): services is forbidden: User "system:serviceaccount:ashu-restricted:default" cannot list resource "services" in A
```

### creating role for ashu-restricted namespace 

```
kubectl  create  role  ashu-pod-access --resource=pods --verb=get --verb=list  --namespace ashu-restricted --dry-run=client -o yaml >role1.yaml
```

####

```
[ashu@mobi-dockerserver myimages]$ kubectl apply -f role1.yaml 
role.rbac.authorization.k8s.io/ashu-pod-access created
[ashu@mobi-dockerserver myimages]$ kubectl  get  roles -n ashu-restricted 
NAME              CREATED AT
ashu-pod-access   2022-09-20T14:51:54Z
[ashu@mobi-dockerserver myimages]$ 

```

### creating rolebinding to bind role with service account 

```
kubectl  create rolebinding bind1 --role ashu-pod-access --serviceaccount=ashu-restricted:default -n ashu-restricted
[ashu@mobi-dockerserver myimages]$ kubectl  get  rolebindings -n ashu-restricted 
NAME    ROLE                   AGE
bind1   Role/ashu-pod-access   63s
```

### verify it 

```
[ashu@mobi-dockerserver myimages]$ kubectl  get  po  --kubeconfig customk8s.yaml 
No resources found in ashu-restricted namespace.
[ashu@mobi-dockerserver myimages]$ 
[ashu@mobi-dockerserver myimages]$ kubectl  get  svc  --kubeconfig customk8s.yaml 
Error from server (Forbidden): services is forbidden: User "system:serviceaccount:ashu-restricted:default" cannot list resource "services" in API group "" in the namespace "ashu-restricted"
[ashu@mobi-dockerserver myimages]$ kubectl  get  ns  --kubeconfig customk8s.yaml 
Error from server (Forbidden): namespaces is forbidden: User "system:serviceaccount:ashu-restricted:default" cannot list resource "namespaces" in API group "" at the cluster scope
[ashu@mobi-dockerserver myimages]$ 
```

### splunk task 

```
apiVersion: v1
kind: Namespace
metadata:
  creationTimestamp: null
  name: ashusplunkns
spec: {}
status: {}
---
apiVersion: v1
data:
  x: --accept-license
kind: ConfigMap
metadata:
  creationTimestamp: null
  name: splunkcm
  namespace: ashusplunkns
--- 
apiVersion: v1
data:
  "y": U3BsQDA5OCM=
kind: Secret
metadata:
  creationTimestamp: null
  name: spsec
  namespace: ashusplunkns
--- 
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: ashudep-1
  name: ashudep-1
  namespace: ashusplunkns
spec:
  replicas: 1
  selector:
    matchLabels:
      app: ashudep-1
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: ashudep-1
    spec:
      containers:
      - image: splunk/splunk
        name: splunk
        ports:
        - containerPort: 8000
        resources: {}
        env: 
        - name: SPLUNK_START_ARGS
          valueFrom:
            ConfigMapKeyRef:
              name: splunkcm
              key: x
        - name: SPLUNK_PASSWORD
          valueFrom:
            SecretKeyRef:
              name: spsec
              key: y
status: {}

```





