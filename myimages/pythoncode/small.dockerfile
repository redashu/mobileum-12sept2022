FROM oraclelinux:8.4 
# docker host will be download python image from Docker hub 
LABEL name=ashutoshh
LABEL email=ashutoshh@linux.com
# Label is optional but you can use to write image Designer info 
RUN  yum install python3 -y 
RUN mkdir /mycode 
# RUN is for executing shell command during image creation time 
COPY  mobi.py  /mycode/
# copy code inside docker image 
CMD ["python3","/mycode/mobi.py"]
# to set default process/program to this docker image 
