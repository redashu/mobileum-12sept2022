## Training plan 

<img src="plan.png">

## Dockerfile for java code 

### sample java code 

```
class myclass { 
    public static void main(String args[]) 
    { 
        // test expression 
        while (true) { 
            System.out.println("Hello World this is container "); 
  
            // update expression 
        } 
    } 
} 
```


### Dockerfile

```
FROM openjdk 
# calling docker image from docker hub 
LABEL email=ashutoshh@linux.com 
RUN mkdir /code 
# to get shell access during image build time 
COPY hello.java /code/
# it can only take data from the same location where Dockerfile is present 
WORKDIR /code 
# to change directory location during image build time 
RUN javac hello.java 
# compiling java code
CMD ["java","myclass"]
# to set default process in this final image 
# also known as container start up program 

```

### lets run it 

```
[ashu@mobi-dockerserver myimages]$ ls
javacode  pythoncode
[ashu@mobi-dockerserver myimages]$ ls javacode/
Dockerfile  hello.java
[ashu@mobi-dockerserver myimages]$ docker  build -t  ashujava:v1  javacode/ 
Sending build context to Docker daemon  3.072kB
Step 1/7 : FROM openjdk
 ---> 2ca167855991
Step 2/7 : LABEL email=ashutoshh@linux.com
 ---> Running in 4f5f68446b40
Removing intermediate container 4f5f68446b40
 ---> 7866b0f87200
Step 3/7 : RUN mkdir /code
 ---> Running in 813ce4bf8c44
Removing intermediate container 813ce4bf8c44
 ---> c36ff19e3a7e
Step 4/7 : COPY hello.java /code/
 ---> ddd934fb8432
Step 5/7 : WORKDIR /code
 ---> Running in d007250a4c85
Removing intermediate container d007250a4c85
 ---> f89ad63190dc
Step 6/7 : RUN javac hello.java
 ---> Running in fdc18db0df19
Removing intermediate container fdc18db0df19
 ---> abc56daef6f5
Step 7/7 : CMD ["java","myclass"]
 ---> Running in 2991f21f8fa6
Removing intermediate container 2991f21f8fa6
 ---> 91bcde702cd4
Successfully built 91bcde702cd4
Successfully tagged ashujava:v1
```


### creating container 

```
[ashu@mobi-dockerserver myimages]$ docker run -itd --name ashujc1 ashujava:v1 
71b5f68ccaaf8ecc1d2cc836ae8b6db0ac86c79377fee6b33bcd4f1549c07f7f
[ashu@mobi-dockerserver myimages]$ docker  ps
CONTAINER ID   IMAGE              COMMAND                  CREATED              STATUS              PORTS     NAMES
71b5f68ccaaf   ashujava:v1        "java myclass"           4 seconds ago        Up 2 seconds                  ashujc1
```

### checking jdk version 

```
[ashu@mobi-dockerserver myimages]$ docker  exec -it ashujc1  bash 
bash-4.4# 
bash-4.4# java -version 
openjdk version "18.0.2.1" 2022-08-18
OpenJDK Runtime Environment (build 18.0.2.1+1-1)
OpenJDK 64-Bit Server VM (build 18.0.2.1+1-1, mixed mode, sharing)
bash-4.4# exit
exit
```

### jdk11 version 

```
FROM oraclelinux:8.4 
# calling docker image from docker hub 
LABEL email=ashutoshh@linux.com 
RUN yum  install java-11-openjdk.x86_64 java-11-openjdk-devel.x86_64 -y 
RUN mkdir /code 
# to get shell access during image build time 
COPY hello.java /code/
# it can only take data from the same location where Dockerfile is present 
WORKDIR /code 
# to change directory location during image build time 
RUN javac hello.java 
# compiling java code
CMD ["java","myclass"]
# to set default process in this final image 
# also known as container start up program 
```

### rebuild it --

```
ashu@mobi-dockerserver myimages]$ docker  build -t  ashujava:jdk11 -f javacode/jdk11.dockerfile   javacode/ 
Sending build context to Docker daemon  4.608kB
Step 1/8 : FROM oraclelinux:8.4
 ---> 97e22ab49eea
Step 2/8 : LABEL email=ashutoshh@linux.com
 ---> Running in 42da582ed0a2
Removing intermediate container 42da582ed0a2
 ---> 043dedc4aaad
Step 3/8 : RUN yum  install java-11-openjdk.x86_64 java-11-openjdk-devel.x86_64 -y
 ---> Running in be57ecdde9ba
Oracle Linux 8 BaseOS Latest (x86_64)            52 MB/s |  49 MB     00:00    

```



