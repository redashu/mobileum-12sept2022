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

## Multi stage Dockerfile 

<img src="multi.png">

### Demo -- cloning springboot app 

```
[ashu@mobi-dockerserver ashu-javawebapp]$ docker-compose down 
[+] Running 2/2
 ⠿ Container ashujc1                Removed                                                      0.2s
 ⠿ Network ashu-javawebapp_default  Removed                                                      0.1s
[ashu@mobi-dockerserver ashu-javawebapp]$ cd ..
[ashu@mobi-dockerserver myimages]$ mkdir ashu-multistage
[ashu@mobi-dockerserver myimages]$ cd ashu-multistage/
[ashu@mobi-dockerserver ashu-multistage]$ 
[ashu@mobi-dockerserver ashu-multistage]$ git clone https://github.com/redashu/java-springboot.git
Cloning into 'java-springboot'...
remote: Enumerating objects: 23, done.
remote: Counting objects: 100% (23/23), done.
remote: Compressing objects: 100% (17/17), done.
remote: Total 23 (delta 4), reused 0 (delta 0), pack-reused 0
Receiving objects: 100% (23/23), 5.62 KiB | 5.62 MiB/s, done.
Resolving deltas: 100% (4/4), done.
[ashu@mobi-dockerserver ashu-multistage]$ 
```

### making files 

```
[ashu@mobi-dockerserver ashu-multistage]$ ls
java-springboot
[ashu@mobi-dockerserver ashu-multistage]$ touch compose.yaml 
[ashu@mobi-dockerserver ashu-multistage]$ touch Dockerfile
[ashu@mobi-dockerserver ashu-multistage]$ ls
compose.yaml  Dockerfile  java-springboot
[ashu@mobi-dockerserver ashu-multistage]$ 

```

## Dockerfile 

```
FROM oraclelinux:8.4  as Stage1 
LABEL name=ashutoshh 
RUN yum install maven java-1.8.0-openjdk.x86_64 java-1.8.0-openjdk-devel.x86_64 -y && mkdir /webapp
ADD java-springboot /webapp/
WORKDIR /webapp
# to change directory during image build time 
RUN mvn clean package
# to build javaspring app into a .war file --target/WebApp.war 
FROM tomcat
LABEL name=ashu
LABEL email=ashutoshh@linux.com 
COPY   --from=Stage1 /webapp/target/WebApp.war /usr/local/tomcat/webapps/
# taking war from stage 1 and copy it to tomcat default location


```


### compose file 

```
version: '3.8'
services:
  ashuspring:
    image: ashuspring:v1 
    build: . 
    container_name: ashujjcc1
    ports:
    - "3355:8080" 
```

### .dockerignore 

```
java-springboot/.git
java-springboot/README.md
```

### lets run it 

```
[ashu@mobi-dockerserver ashu-multistage]$ ls
compose.yaml  Dockerfile  java-springboot
[ashu@mobi-dockerserver ashu-multistage]$ docker-compose  up -d 
[+] Running 0/0
 ⠿ ashuspring Error                                                                              0.1s
[+] Building 104.1s (13/13) FINISHED                                                                  
 => [internal] load build definition from Dockerfile                                             0.0s
 => => transferring dockerfile: 572B                                                             0.0s
 => [internal] load .dockerignore                                                                0.0s
 => => transferring context: 86B                                                                 0.0s
 => [internal] load metadata for docker.io/library/tomcat:latest                                 0.1s
 => [internal] load metadata for docker.io/library/oraclelinux:8.4                               0.0s
 => CACHED [stage-1 1/2] FROM docker.io/library/tomcat@sha256:bb81645575fef90e48e6f9fff50e06d5b  0.0s
 => [stage1 1/5] FROM docker.io/library/oraclelinux:8.4                                          0.0s
 => [internal] load build context                                                                0.1s
 => => transferring context: 5.82kB                                                              0.0s
 => [stage1 2/5] RUN yum install maven java-1.8.0-openjdk.x86_64 java-1.8.0-openjdk-devel.x86_  50.3s
 => [stage1 3/5] ADD java-springboot /webapp/                                                    0.1s 
 => [stage1 4/5] WORKDIR /webapp                                                                 0.2s
 => [stage1 5/5] RUN mvn clean package                                                          53.2s
 => [stage-1 2/2] COPY   --from=Stage1 /webapp/target/WebApp.war /usr/local/tomcat/webapps/      0.1s
 => exporting to image                                                                           0.1s
 => => exporting layers                                                                          0.0s
 => => writing image sha256:93d6c733c8acf3e242e5fd517eaf73dccba100fad36bc6096b64d71a63daa82e     0.0s
 => => naming to docker.io/library/ashuspring:v1                                                 0.0s
[+] Running 2/2
 ⠿ Network ashu-multistage_default  Created                                                      0.4s
 ⠿ Container ashujjcc1              Started          
```
## image pushing 

### Docker Hub 

```
 364  docker tag ashuspring:v1  docker.io/dockerashu/mobispring:appv1 
  365  docker login  -u dockerashu
  366  docker push docker.io/dockerashu/mobispring:appv1
  367  docker logout
```

### ECR 

```
 369  docker tag ashuspring:v1  751136288263.dkr.ecr.us-east-1.amazonaws.com/mobileumspringapp:ashuv1 
  370  history 
  371  docker  login 751136288263.dkr.ecr.us-east-1.amazonaws.com -u AWS
  372  hsitor
  373  history 
  374  cat  /tmp/pass.txt 
  375  history 
  376  docker push 751136288263.dkr.ecr.us-east-1.amazonaws.com/mobileumspringapp:ashuv1
  377  docker  logout  751136288263.dkr.ecr.us-east-1.amazonaws.com 
  378  history 
```




