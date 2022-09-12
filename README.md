## Training plan 

<img src="plan.png">

### app Deployment in Past using bare-metal 

<img src="bare.png">

### moving from Bare-metal To VM 

<img src="vm.png">

### more vm means more OS -- creating more resources 

<img src="vmprob.png">

### Introduction to containers 

<img src="cont.png">

### Container journey 

<img src="cont1.png">

## Container ENgine 

<img src="cre.png">

### Installing docker ce on LInux by amazon 

```
[root@mobi-dockerserver ~]# yum   install  docker  -y
Failed to set locale, defaulting to C
Loaded plugins: extras_suggestions, langpacks, priorities, update-motd
Resolving Dependencies
--> Running transaction check
---> Package docker.x86_64 0:20.10.17-1.amzn2 will be installed
--> Processing Dependency: runc >= 1.0.0 for package: docker-20.10.17-1.amzn2.x86_64
--> Processing Dependency: libcgroup >= 0.40.rc1-5.15 for package: docker-20.10.17-1.amzn2.x86_64
--> Processing Dependency: containerd >= 1.3.2 for package: docker-20.10.17-1.amzn2.x86_64
--> Processing Dependency: pigz for package: docker-20.10.17-1.amzn2.x86_64
--> Running transaction check
---> Package containerd.x86_64 0:1.6.6-1.amzn2 will be installe
```

### starting docker service 

```
[root@mobi-dockerserver ~]# systemctl start  docker 
[root@mobi-dockerserver ~]# systemctl enable  docker 
Created symlink from /etc/systemd/system/multi-user.target.wants/docker.service to /usr/lib/systemd/system/docker.service.
[root@mobi-dockerserver ~]# systemctl status  docker 
● docker.service - Docker Application Container Engine
   Loaded: loaded (/usr/lib/systemd/system/docker.service; enabled; vendor preset: disabled)
   Active: active (running) since Mon 2022-09-12 08:54:46 UTC; 15s ago
     Docs: https://docs.docker.com
 Main PID: 3635 (dockerd)

```

### Docs to install Docker ce 20 version 

[link](https://docs.docker.com/engine/install/)

### login with non root user 

```
[ashu@mobi-dockerserver ~]$ whoami
ashu
[ashu@mobi-dockerserver ~]$ docker  version 
Client:
 Version:           20.10.17
 API version:       1.41
 Go version:        go1.18.3
 Git commit:        100c701
 Built:             Thu Jun 16 20:08:47 2022
 OS/Arch:           linux/amd64
 Context:           default
 Experimental:      true

Server:
 Engine:
  Version:          20.10.17
  API version:      1.41 (minimum version 1.12)
  Go version:       go1.18.3
  Git commit:       a89b842
  Built:            Thu Jun 16 20:09:24 2022
  OS/Arch:          linux/amd64
  Experimental:     false
 containerd:
  Version:          1.6.6
  GitCommit:        10c12954828e7c7c9b6e0ea9b0c02b01407d3ae1
```


