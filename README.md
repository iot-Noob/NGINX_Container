# 🚀 NGINX Docker Reverse Proxy Setup with SSL

This project sets up an NGINX server in Docker with full support for:
- SSL/TLS (self-signed or imported certs)
- Multiple exposed ports
- Reverse proxy (e.g., for Jellyfin or other apps)
- Cleanly organized volume structure

---

## 📁 Directory Structure

```
Nginx2/
├── docker-compose.yaml
├── Dockerfile
├── .gitignore
├── README.md (this file)
└── Nginx-Config/
    ├── config/
    │   ├── conf.d/
    │   ├── sites-available/
    │   ├── sites-enabled/
    │   ├── nginx.conf
    │   └── mime.types
    ├── ssl/
    │   ├── netflix.talha.pk/
    │   └── nginx.talha.pk/
    ├── vassl/               # Optional: Linked OpenSSL paths (if needed)
    └── www/                 # Web root (static content)
```

---

## 🐳 Docker Compose

```yaml
version: '3.8'

services:
  nginx:
    build:
      context: .
      dockerfile: Dockerfile
    container_name: nginx-talha
    hostname: nginx.talha.pk
    dns:
      - 192.168.100.33
      - 1.1.1.1
      - 8.8.8.8
    networks:
      - a-class-bridge
    ports:
      - "80:80"
      - "443:443"
      - "4000:4000"
      - "3000:3000"
      - "8080:8080"
    volumes:
      - "./Nginx-Config/config:/etc/nginx"
      - "./Nginx-Config/www:/var/www"
      - "./Nginx-Config/ssl:/etc/ssl"
      - "./Nginx-Config/vassl:/usr/lib/ssl"

networks:
  a-class-bridge:
    external: true
```

---

## 📦 Dockerfile

```dockerfile
FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y \
    nginx \
    openssl \
    curl wget \
    iputils-ping net-tools iproute2 traceroute dnsutils \
    htop screen \
    lsof \
    nano vim \
    && apt clean

EXPOSE 80 443 8080 3000 4000

CMD ["nginx", "-g", "daemon off;"]
```

---

## 📜 .gitignore

```gitignore
*.key
*.csr
*.crt
*.pem
*.der
*.pfx
*.p12
*.srl
*.jks
*.keystore
*.truststore
*.cnf
certs/
ca/
crt/
key/
```

---

## 🔧 Usage

1. **Edit `nginx.conf` and site configs** in:
   ```
   Nginx-Config/config/
   ```

2. **Place your SSL certs** (e.g., from your CA script or Let's Encrypt) in:
   ```
   Nginx-Config/ssl/<your-domain>/
   ```

3. **Start the container**:
   ```bash
   docker-compose up --build -d
   ```

4. **Check logs**:
   ```bash
   docker logs -f nginx-talha
   ```

---

## 🔒 Notes on SSL

- Certificates should be placed under `ssl/<domain>/`:
  - `fullchain.crt`
  - `domain.key`
  - Optional: `talha-rootCA.crt` if using a custom CA
- Android requires CA in `.der` format.

---

## ✅ Example NGINX HTTPS Block

```nginx
server {
    listen 443 ssl http2;
    server_name netflix.talha.pk;

    ssl_certificate     /etc/ssl/netflix.talha.pk/crt/fullchain.crt;
    ssl_certificate_key /etc/ssl/netflix.talha.pk/key/netflix.talha.pk.key;
    ssl_trusted_certificate /etc/ssl/netflix.talha.pk/crt/talha-rootCA.crt;

    # Add security headers and reverse proxy rules...
}
```

---

## 📬 Credits

Made with ❤️ by Talha
