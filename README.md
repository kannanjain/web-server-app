# Web Server Application

A containerized HTTPS web server that displays a local webpage with a single command. Built with Docker and nginx, featuring automatic SSL certificate generation and an animated UI

##  Quick Start

### Prerequisites

- **Docker** installed and running ([Install Docker](https://docs.docker.com/get-docker/))
- **OpenSSL** (might be pre-installed on macOS/Linux)

### Running the Server

Simply execute the provided script:

```bash
./run.sh
```

The script will:
1. Generate self-signed SSL certificates (if they don't already exist) in Docker/ssl/ folder
2. Build the Docker image
3. Start the container on port 8443

### Accessing the Webpage

Open your browser and navigate to:
```
https://localhost:8443
```

**Note:** Your browser will show a security warning because we're using a self-signed certificate. This is expected and safe for local development. Click "Advanced" -> "Proceed to localhost" (or equivalent in your browser). Also note, using port 8443 avoids interefering with usual http traffic.

### Stopping the Server

```bash
docker rm -f web-server
```

---

## Solution Components

### Web Server: Nginx

Nginx is a is a popular open-source web server and reverse proxy known for  high scalability and performance with limited resources

**Highlighted features**

- Great for serving static content (our current web server is serving static content)
- Being reverse proxy it gives an additional layer of security to interact with backend services
- Good for load balancing
- Has a cache server that is great for speed 
- Has good documentation because it is extensively used

**Compared to other services**
1. **Apache** - Had very similar pros as using nginx. However, Nginx (event based) is more lightweight in comparison to Apache (thread-based) 
2. **Tomcat** - Overkill for static display but used good for Java applications
3. **IIS** - Good for windows but not ideal for MacOS

### Dockerfile and Shell

Used a shell file to perform configuration management to automate environment setup using Docker to build a Docker image that is easily build and run on different devices.

**Highlighted features**
- Does not require an OS specific setup
- Straightforward dev setup by adding commonly used run commands to run.sh script to make the program executable with a single command
- Isolates the web-server environment, good for security
- Easy to add CI/CD or deploy to cloud and is production ready

**Compared to other services**
1. **Programming Languages (eg. python)** - It is a familiar setup for many but is not production ready and trickier to make exectuable in a single command
2. **Confgiuration Managmenet Tools (eg. Ansible)** - Overkill for the requirements of the challenge (Also a higher learning curve for me personally)

### Self-signed Certificate using openSSL
Not signed by a Certificate Authority but only endorsed by the entity that created it 

**Highlighted features**
- Simple setup using OpenSSL (that is preinstalled on most devices)
- Free to generate
- Currently we are the developer so we know there's no malicious code or intent

**Drawbacks**
- Not endorsed by a certificate authority easily prone to malicious attacks as the program scales
- Not trusted by users

---

##  Architecture

```
┌─────────────────────────────────────┐
│         run.sh (orchestrator)       │
│  • Generates SSL certificates       │
│  • Builds Docker image              │
│  • Runs container                   │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│      Docker Container               │
│  ┌──────────────────────────────┐  │
│  │    nginx:alpine               │  │
│  │  ┌────────────────────────┐   │  │
│  │  │ nginx.conf (HTTPS)     │   │  │
│  │  │ Port 8443              │   │  │
│  │  └────────────────────────┘   │  │
│  │  ┌────────────────────────┐   │  │
│  │  │ /usr/share/nginx/html  │   │  │
│  │  │ (web/* files)          │   │  │
│  │  └────────────────────────┘   │  │
│  │  ┌────────────────────────┐   │  │
│  │  │ SSL certificates       │   │  │
│  │  │ (Docker/ssl/*)         │   │  │
│  │  └────────────────────────┘   │  │
│  └──────────────────────────────┘  │
└─────────────────────────────────────┘
```

---

##  Project Structure

```
web-server-app/
├── Dockerfile              # Container definition
├── run.sh                  # Main execution script
├── README.md               # This file
├── Docker/
│   ├── nginx.conf          # Nginx HTTPS configuration
│   └── ssl/                # SSL certificates (auto-generated, gitignored)
│       ├── certificate.pem
│       └── privkey.pem
└── web/
    └── index.html          # Local webpage
```

---

##  Troubleshooting

### "Cannot connect to Docker daemon"
**Solution:** Start Docker Desktop (macOS/Windows) or Docker service (Linux)

### "Port 8443 already in use"
**Solution:** 
```bash
docker rm -f web-server
```
Then run `./run.sh` again.

### Certificate generation fails
**Solution:** Ensure OpenSSL is installed:
- macOS: Pre-installed
- Linux: `sudo apt-get install openssl` (Ubuntu/Debian)
- Windows: Install via WSL or Git Bash

### Browser shows "Connection Refused"
**Solution:** 
1. Check container is running: `docker ps`
2. Check logs: `docker logs web-server`
3. Rebuild: `./run.sh`

### Permission denied on `run.sh`
**Solution:** Make script executable:
```bash
chmod +x run.sh
```