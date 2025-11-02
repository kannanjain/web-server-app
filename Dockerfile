FROM nginx:alpine

# Copy Nginx config
COPY web/nginx.conf /etc/nginx/nginx.conf

# Copy HTML content
COPY web /usr/share/nginx/html

EXPOSE 8080

