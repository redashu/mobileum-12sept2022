## Training plan 

<img src="plan.png">

## Demo Docker context  

```
 21  ssh-keygen 
   22  ssh-copy-id  remote@52.200.191.206
   23  history 
   24  ssh  remote@52.200.191.206
   25  docker  context  ls
  
   27  docker  context  create  mobi-dockerserver  --docker "host=ssh://remote@52.200.191.206" 
   28  docker  context  ls
   29  docker  context use mobi-dockerserver 

```

## Dockerfile Tomcat example 

### source code 

```
[ashu@mobi-dockerserver myimages]$ ls
ashu-compose  javacode  pythoncode  webapps_ashu
[ashu@mobi-dockerserver myimages]$ mkdir  ashu-javawebapp
[ashu@mobi-dockerserver myimages]$ cd  ashu-javawebapp/
[ashu@mobi-dockerserver ashu-javawebapp]$ git clone https://github.com/redashu/javawebapp.git
Cloning into 'javawebapp'...
remote: Enumerating objects: 71, done.
remote: Counting objects: 100% (71/71), done.
remote: Compressing objects: 100% (67/67), done.
remote: Total 71 (delta 31), reused 5 (delta 0), pack-reused 0
Receiving objects: 100% (71/71), 50.95 KiB | 8.49 MiB/s, done.
Resolving deltas: 100% (31/31), done.
[ashu@mobi-dockerserver ashu-javawebapp]$ ls  
javawebapp
[ashu@mobi-dockerserver ashu-javawebapp]$ ls  javawebapp/
Dockerfile  myapp  README.md
[ashu@mobi-dockerserver ashu-javawebapp

````

### running compose file 

```
[ashu@mobi-dockerserver ashu-javawebapp]$ docker-compose up -d 
[+] Running 1/1
 ⠿ Container ashujc1  Started                                                                    1.0s
[ashu@mobi-dockerserver ashu-javawebapp]$ docker-compose ps
NAME                COMMAND             SERVICE             STATUS              PORTS
ashujc1             "catalina.sh run"   ashujavaapp         running             0.0.0.0:2244->8080/tcp, :::2244->8080/tcp
[ashu@mobi-dockerserver ashu-javawebapp]$ docker-compose  images
Container           Repository          Tag                 Image Id            Size
ashujc1             ashujavaweb         appv1               6db97f49e178        475MB
[ashu@mobi-dockerserver ashu-javaw
```

### rebuild docker image 

```
[ashu@mobi-dockerserver ashu-javawebapp]$ docker-compose up -d --build 
[+] Building 0.2s (10/10) FINISHED                                                                    
 => [internal] load build definition from Dockerfile                                             0.0s
 => => transferring dockerfile: 32B                                                              0.0s
 => [internal] load .dockerignore                                                                0.0s
 => => transferring context: 2B                                                                  0.0s
 => [internal] load metadata for docker.io/library/tomcat:latest                                 0.1s
 => [1/5] FROM docker.io/library/tomcat@sha256:bb81645575fef90e48e6f9fff50e06d5b78d4ac9d2683845  0.0s
 => [internal] load build context                                                                0.0s
 => => transferring context: 575B                                                                0.0s
 => CACHED [2/5] WORKDIR /usr/local/tomcat/webapps                                               0.0s
 => CACHED [3/5] RUN mkdir mobileum                                                              0.0s
 => CACHED [4/5] WORKDIR mobileum                                                                0.0s
 => [5/5] ADD myapp .                                                                            0.0s
 => exporting to image                                                                           0.0s
 => => exporting layers                                                                          0.0s
 => => writing image sha256:c9ea9219196dcf6f66c8b185912ad724d1ba457f37eb483eac8c5f3747fee17e     0.0s
 => => naming to docker.io/library/ashujavaweb:appv1                                             0.0s
[+] Running 2/2
 ⠿ Network ashu-javawebapp_default  Created                                                      0.0s
 ⠿ Container ashujc1                Started  
```

