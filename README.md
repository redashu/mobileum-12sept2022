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

## basic docker system architecture understanding 

<img src="darch.png">

## application to run in a container 

<img src="appc.png">

### Search image to docker hub 

```
[ashu@mobi-dockerserver ~]$ docker  search  nodejs
NAME                               DESCRIPTION                                     STARS     OFFICIAL   AUTOMATED
amazon/aws-lambda-nodejs           AWS Lambda base images for NodeJS               32                   
centos/nodejs-8-centos7            Platform for building and running Node.js 8 …   14                   
jelastic/nodejs                    An image of the NodeJS application server ma…   10                   
openshift/nodejs-010-centos7       DEPRECATED: A Centos7 based NodeJS v0.10 ima…   8                    
centos/nodejs-10-centos7           Platform for building and running Node.js 10…   8                    
nodejscn/node                      Docker Image for Node.js                        7                    [OK]
mc2labs/nodejs       
```
### pulling image from docker hub 

```
[ashu@mobi-dockerserver ~]$ docker  images
REPOSITORY   TAG       IMAGE ID   CREATED   SIZE
[ashu@mobi-dockerserver ~]$ docker  pull openjdk 
Using default tag: latest
latest: Pulling from library/openjdk
492d84e496ea: Pull complete 
f7d74542bd1a: Pull complete 
f066d8ddc02a: Pull complete 
Digest: sha256:5798afbe93d0d7519a8fa2cfd01d8073f6edb797d5a90e3681e80d62ce737328
Status: Downloaded newer image for openjdk:latest
docker.io/library/openjdk:latest
[ashu@mobi-dockerserver ~]$ 
[ashu@mobi-dockerserver ~]$ docker  pull  mysql 
Using default tag: latest
latest: Pulling from library/mysql
492d84e496ea: Already exists 
bbe20050901c: Pull complete 
e3a5e171c2f8: Pull complete 
c2cedd8aa061: Pull complete 
```

### pulling images 

```
   14  docker  pull  nginx:1.23
   15  history 
[ashu@mobi-dockerserver ~]$ docker  images
REPOSITORY   TAG       IMAGE ID       CREATED       SIZE
python       latest    4f9baf941f8e   4 days ago    921MB
openjdk      latest    2ca167855991   12 days ago   462MB
mysql        latest    ff3b5098b416   12 days ago   447MB
nginx        1.23      2b7d6430f78d   2 weeks ago   142MB
bash         latest    58c36729bafd   4 weeks ago   13MB
alpine       latest    9c6f07244728   4 weeks ago   5.54MB

```

### creating first container 

<img src="cc.png">

### creating container 

```
[ashu@mobi-dockerserver ~]$ docker  run  --name ashuc1  -d   alpine:latest  ping google.com 
1b3a15c047a5ebbfdc9c8254bdb857c10225110ccb859992cd27847c7efddaf2
[ashu@mobi-dockerserver ~]$ docker  ps
CONTAINER ID   IMAGE           COMMAND             CREATED              STATUS              PORTS     NAMES
1b3a15c047a5   alpine:latest   "ping google.com"   11 seconds ago       Up 10 seconds                 ashuc1
1b286a961408   alpine:latest   "ping google.com"   12 seconds ago       Up 10 seconds                 filipe_alpine_1
bc83b635c82d   alpine:latest   "ping google.com"   30 seconds ago       Up 28 seconds                 rajc1
b6aa093e05b3   alpine:latest   "ping google.com"   53 seconds ago       Up 52 seconds                 sofiac1
91b7207d7175   alpine          "ping 8.8.8.8"      About a minute ago   Up About a minute             ricardo-1
efad82cb3630   alpine:latest   "ping google.com"   2 minutes ago        Up 2 minutes                  arya1
[ashu@mobi-dockerserver ~]$ 


```


### running a child command /process in a running container 

```
[ashu@mobi-dockerserver ~]$ docker  exec  ashuc1  uname -r
5.10.130-118.517.amzn2.x86_64
```

### container is using heavily less resources 

```
[ashu@mobi-dockerserver ~]$ docker  stats  ashuc1  
CONTAINER ID   NAME      CPU %     MEM USAGE / LIMIT   MEM %     NET I/O           BLOCK I/O   PIDS
1b3a15c047a5   ashuc1    0.01%     352KiB / 7.76GiB    0.00%     66.6kB / 64.8kB   0B / 0B     1
^C

```

### life of container 

<img src="life.png">

### checking output of container default program 

```
[ashu@mobi-dockerserver ~]$ docker  logs  ashuc1  
PING google.com (172.253.122.113): 56 data bytes
64 bytes from 172.253.122.113: seq=0 ttl=98 time=1.601 ms
64 bytes from 172.253.122.113: seq=1 ttl=98 time=1.655 ms
64 bytes from 172.253.122.113: seq=2 ttl=98 time=1.640 ms

```

### 

```
docker logs -f  ashuc1
```

### stopping your running container 

```
[ashu@mobi-dockerserver ~]$ docker  stop  ashuc1
ashuc1
```

### checking list of containers in every state

```
[ashu@mobi-dockerserver ~]$ docker  ps  -a 
CONTAINER ID   IMAGE           COMMAND                  CREATED          STATUS                            PORTS     NAMES
13e0420b0f82   alpine:latest   "/bin/sh"                6 minutes ago    Exited (0) 6 minutes ago                    sofiac5
8fecced191a1   alpine          "ping google.com"        15 minutes ago   Exited (137) About a minute ago             fernando
9b2da6236710   alpine:latest   "ping google.com"        16 minutes ago   Exited (137) 52 seconds ago                 vbrt
850d8cd85fd1   alpine:latest   "ping google.com"        16 minutes ago   Exited (137) 57 seconds ago                 aseemC1
ca3d21e8c97b   alpine          "ping google.com"        16 minutes ago   Exited (137) 2 seconds ago                  shailendra1
55e82df61f64   bash            "docker-entrypoint.s…"   16 minutes ago   Exited (137) 16 minutes ago                 ricardo-2
c1de348eb37e   bash            "docker-entrypoint.s…"   18 minutes ago   Exited (137) About a minute ago             som1
84e7067d4c94   python:latest   "ping google.com"        18 minutes ago   Created                                     nalina
9d11551faab6   alpine:latest   "ping google.com"        18 minutes ago   Up 18 minutes                               Ritesh
8d92774344c5   alpine:latest   "ping google.com"        18 minutes ago   Exited (137) About a minute ago             som
aee389f6c167   alpine:latest   "docker version"      
```

### starting a stopped container 

```
[ashu@mobi-dockerserver ~]$ docker  start  ashuc1
ashuc1
[ashu@mobi-dockerserver ~]$ docker  ps
CONTAINER ID   IMAGE           COMMAND             CREATED          STATUS                  PORTS     NAMES
63cb23b47b51   alpine:latest   "ping google.com"   22 minutes ago   Up Less than a second             vccardoso1
1b3a15c047a5   alpine:latest   "ping google.com"   22 minutes ago   Up 7 seconds                      ashuc1
bc83b635c82d   alpine:latest   "ping google.com"   23 minutes ago   Up 1 second     
```

### get the container shell 

```
[ashu@mobi-dockerserver ~]$ whoami
ashu
[ashu@mobi-dockerserver ~]$ docker  exec  -it  ashuc1  sh 
/ # 
/ # whoami
root
/ # uname -r
5.10.130-118.517.amzn2.x86_64
/ # 
/ # cat /etc/os-release 
NAME="Alpine Linux"
ID=alpine
VERSION_ID=3.16.2
PRETTY_NAME="Alpine Linux v3.16"
HOME_URL="https://alpinelinux.org/"
BUG_REPORT_URL="https://gitlab.alpinelinux.org/alpine/aports/-/issues"
/ # 
/ # exit
[ashu@mobi-dockerserver ~]$ 
[ashu@mobi-dockerserver ~]$ whoami
ashu
[ashu@mobi-dockerserver ~]$ 
```

### stop and delete container 

```
[ashu@mobi-dockerserver ~]$ docker stop  ashuc1  ; docker rm ashuc1 
ashuc1
ashuc1
```

## Container image management 

### Build custom image to integrate app/source code 

<img src="build.png">




