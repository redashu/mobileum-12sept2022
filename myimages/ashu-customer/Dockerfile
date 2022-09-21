FROM oraclelinux:8.4
LABEL name=ashutoshh
ENV deploy=webapp 
RUN yum install httpd -y && mkdir /common /common/app1 /common/app2 
COPY project-html-website /common/app1/
COPY project-website-template /common/app2/
COPY deploy.sh /common/
WORKDIR /common
RUN chmod +x deploy.sh 
ENTRYPOINT ["./deploy.sh"]