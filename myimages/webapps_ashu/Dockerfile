FROM nginx 
# nginx server image from docker hub 
LABEL name=ashutoshh
COPY html-sample-app /usr/share/nginx/html/
# COPY / ADD they always read .dockerignore file 
# Note if we don't user CMD/Entrypoint then From image CMd/entrypoint will be
# inherited 