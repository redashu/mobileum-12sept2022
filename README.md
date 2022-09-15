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

