FROM nginx:alpine
# Copy your built frontend files
COPY . /usr/share/nginx/html
# Copy your custom config
COPY default.conf /etc/nginx/conf.d/default.conf
EXPOSE 80