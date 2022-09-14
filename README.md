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

