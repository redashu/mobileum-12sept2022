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