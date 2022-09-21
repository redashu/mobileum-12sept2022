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
