FROM alpine
LABEL name=ashutoshh
RUN apk add python3 &&  mkdir /pycodes
ADD https://raw.githubusercontent.com/redashu/pythonLang/main/while.py /pycodes/
# COPY and add both are same keyword but add can take data from URL as well
ENTRYPOINT python3  /pycodes/while.py 
# CMD and Entrypoint are almost same 