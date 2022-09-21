#!/bin/bash

if [ "$deploy" == "webapp1" ]
then
    cp -rf /common/app1/*  /var/www/html/
    httpd -DFOREGROUND

elif [ "$deploy" == "webapp2" ]
then
    cp -rf /common/app2/*  /var/www/html/
    httpd -DFOREGROUND 
else 
    echo "please check your Env var value" >/var/www/html/index.html
    httpd -DFOREGROUND
fi 