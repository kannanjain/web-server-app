#!/usr/bin/env bash
set -e

CERT_DIR="Docker/ssl"

# Generate certificates if they don't exist
generate_certs() {
  mkdir -p "${CERT_DIR}"
  local crt="${CERT_DIR}/certificate.pem"
  local key="${CERT_DIR}/privkey.pem"

  if [[ -f "$crt" && -f "$key" ]]; then
    echo "Using certificates at ${CERT_DIR}/"
    return
  fi

  echo "Generating self-signed certificate for localhost"
  openssl req -x509 -newkey rsa:2048 -nodes -days 365 \
    -keyout "$key" -out "$crt" \
    -subj "/CN=localhost" \
    -addext "subjectAltName=DNS:localhost,IP:127.0.0.1" >/dev/null 2>&1

  echo "Created: ${crt} and ${key}"
}

generate_certs

docker build -t web-server-app .

# Remove existing container if it exists
docker rm -f web-server 2>/dev/null || true

# Run container
docker run -d --rm --name web-server -p 8443:8443 web-server-app

echo "Web server running at https://localhost:8443"
