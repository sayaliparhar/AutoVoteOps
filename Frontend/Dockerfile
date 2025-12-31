# Use the official Nginx image (Alpine version is very small/fast)
FROM nginx:alpine

# 1. Remove the default Nginx welcome page
RUN rm -rf /usr/share/nginx/html/*

# 2. Copy your static files (index.html, style.css) to the Nginx folder
# This assumes the Dockerfile is in the same folder as your HTML/CSS
COPY . /usr/share/nginx/html

# 3. Copy your custom Nginx config to handle the /api proxying
# This overwrites the default Nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# 4. Expose port 80 so we can access it
EXPOSE 80

# 5. Start Nginx (daemon off keeps the container running)
CMD ["nginx", "-g", "daemon off;"]