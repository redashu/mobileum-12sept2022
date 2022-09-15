## Training plan 

<img src="plan.png">

## K8s architecture is important to Understand 

<img src="k8sarch.png">

### COntrol plane component  --- Kube-apiServer 

<img src="apis.png">

### Installing kubectl client side software on Mac 

```
fire@ashutoshhs-MacBook-Air ~ %  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/darwin/amd64/kubectl"
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   138  100   138    0     0    351      0 --:--:-- --:--:-- --:--:--   350
100 47.8M  100 47.8M    0     0  4309k      0  0:00:11  0:00:11 --:--:-- 5328k
fire@ashutoshhs-MacBook-Air ~ % 
fire@ashutoshhs-MacBook-Air ~ % ls
Applications		Downloads		Music			certs			kubectl
Desktop			Library			Pictures		config_file_create.sh	sa.kubeconfig
Documents		Movies			Public			go			svc.yml
fire@ashutoshhs-MacBook-Air ~ % sudo mv kubectl /usr/local/bin 
Password:
fire@ashutoshhs-MacBook-Air ~ % sudo chmod +x  /usr/local/bin/kubectl 
fire@ashutoshhs-MacBook-Air ~ % kubectl version --client 
WARNING: This version information is deprecated and will be replaced with the output from kubectl version --short.  Use --output=yaml|json to get the full version.
Client Version: version.Info{Major:"1", Minor:"25", GitVersion:"v1.25.0", GitCommit:"a866cbe2e5bbaa01cfd5e969aa3e033f3282a8a2", GitTreeState:"clean", BuildDate:"2022-08-23T17:44:59Z", GoVersion:"go1.19", Compiler:"gc", Platform:"darwin/amd64"}
Kustomize Version: v4.5.7
fire@ashutoshhs-MacBook-Air ~ % kubectl version --client  -o yaml 
clientVersion:
  buildDate: "2022-08-23T17:44:59Z"
  compiler: gc
  gitCommit: a866cbe2e5bbaa01cfd5e969aa3e033f3282a8a2
  gitTreeState: clean
  gitVersion: v1.25.0
  goVersion: go1.19
  major: "1"
  minor: "25"
  platform: darwin/amd64
kustomizeVersion: v4.5.7

fire@ashutoshhs-MacBook-Air ~ % kubectl version --client  -o json 
{
  "clientVersion": {
    "major": "1",
    "minor": "25",
    "gitVersion": "v1.25.0",
    "gitCommit": "a866cbe2e5bbaa01cfd5e969aa3e033f3282a8a2",
    "gitTreeState": "clean",
    "buildDate": "2022-08-23T17:44:59Z",
    "goVersion": "go1.19",
    "compiler": "gc",
    "platform": "darwin/amd64"
  },
  "kustomizeVersion": "v4.5.7"
}


```

## TO install on windows & linux systems use below link 

[click](https://kubernetes.io/docs/tasks/tools/)


## COntrol plane auth file location for clients 

```
[root@control-plane ~]# cd  /etc/kubernetes/
[root@control-plane kubernetes]# ls
admin.conf 
```

### lets check connection b/w client and apiserver 

```
fire@ashutoshhs-MacBook-Air ~ % cd ~/Desktop
fire@ashutoshhs-MacBook-Air Desktop % ls
ANIPL				awscred5thsept.txt		k8sarch.png			spinnaker
admin.conf.txt			hello.java			new_user_credentials (1).csv	thexyzcompany
apis.png			id_rsa.pub			ordertraining
fire@ashutoshhs-MacBook-Air Desktop % 
fire@ashutoshhs-MacBook-Air Desktop % 
fire@ashutoshhs-MacBook-Air Desktop % 
fire@ashutoshhs-MacBook-Air Desktop % kubectl  get  nodes  --kubeconfig  admin.conf.txt 
NAME            STATUS   ROLES           AGE    VERSION
control-plane   Ready    control-plane   2d3h   v1.25.0
node1           Ready    <none>          2d3h   v1.25.0
node2           Ready    <none>          2d3h   v1.25.0
node3           Ready    <none>          2d3h   v1.25.0
fire@ashutoshhs-MacBook-Air Desktop % 
fire@ashutoshhs-MacBook-Air Desktop % kubectl  cluster-info   --kubeconfig  admin.conf.txt 
Kubernetes control plane is running at https://44.209.211.99:6443
CoreDNS is running at https://44.209.211.99:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
fire@ashutoshhs-MacBook-Air Desktop % 


```

### linux client setup 

```
ashu@mobi-dockerserver myimages]$ wget http://44.209.211.99/admin.conf
--2022-09-15 09:06:01--  http://44.209.211.99/admin.conf
Connecting to 44.209.211.99:80... connected.
HTTP request sent, awaiting response... 200 OK
Length: 5637 (5.5K) [text/plain]
Saving to: ‘admin.conf’

100%[============================================================>] 5,637       --.-K/s   in 0s      

2022-09-15 09:06:01 (293 MB/s) - ‘admin.conf’ saved [5637/5637]

[ashu@mobi-dockerserver myimages]$ mkdir ~/.kube
[ashu@mobi-dockerserver myimages]$ cp -v admin.conf   ~/.kube/config 
‘admin.conf’ -> ‘/home/ashu/.kube/config’
[ashu@mobi-dockerserver myimages]$ kubectl   get  nodes
NAME            STATUS   ROLES           AGE    VERSION
control-plane   Ready    control-plane   2d3h   v1.25.0
node1           Ready    <none>          2d3h   v1.25.0
node2           Ready    <none>          2d3h   v1.25.0
```


