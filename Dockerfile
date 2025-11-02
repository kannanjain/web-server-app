FROM nginx:alpine

# Copy Nginx config
COPY Docker/nginx.conf /etc/nginx/nginx.conf

# Copy TLS materials 
COPY Docker/ssl /etc/nginx/ssl

# Copy HTML content
COPY web /usr/share/nginx/html

EXPOSE 8443

