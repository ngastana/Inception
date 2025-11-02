# 🏰 Inception

**system administration and containerization**: set up a complete **virtualized infrastructure** using **Docker** — all from scratch.  
Building my own mini cloud ☁️ (without paying AWS prices 💸).

---

## 🧠 Project Overview

You’ll create a small **personal server** composed of multiple containers, each running a different service:  
- 🐋 **Nginx** (as a reverse proxy with TLS)  
- 🗄️ **MariaDB** (as the database)  
- 📝 **WordPress** (as the web application)

Everything must run in **isolated containers**, connected via a **Docker network**, and managed by a single **docker-compose.yml**.

                +-------------------+
                |       NGINX       |
                | (TLS / Port 443)  |
                +---------+---------+
                          |
                          |
               +----------+----------+
               |                     |
      +--------v--------+   +--------v--------+
      |   WordPress     |   |    MariaDB      |
      | (PHP-FPM + PHP) |   |   (Database)    |
      +-----------------+   +-----------------+


Each service runs in its own container, communicates via Docker’s internal network,  
and stores data in persistent **volumes** (so you don’t lose anything on restart 🧱).

---

## 🧱 Mandatory Services

| Service | Role | Key Notes |
|----------|------|-----------|
| **Nginx** | Reverse proxy | Handles HTTPS (SSL/TLS certificates) and routes traffic |
| **WordPress** | Web app | Runs on PHP-FPM and connects to MariaDB |
| **MariaDB** | Database | Stores WordPress data |
| **Volumes** | Persistence | Keep DB and WordPress data safe |
| **Network** | Communication | Connects all containers internally |

---

## 🧰 Technologies

- 🐋 **Docker**  
- ⚙️ **Docker Compose**  
- 🧩 **Nginx**  
- 🐘 **PHP / PHP-FPM**  
- 🗃️ **MariaDB**  
- 🧾 **WordPress**  
- 🔒 **OpenSSL** (for self-signed certificates)  
- 🧱 **Alpine Linux** (minimal base image)  

---

## 🚀 How to Run
```bash
make
docker ps
```
### 🌐 Access the Website

Once all containers are up and running, open your browser and go to:

👉 **https://localhost** (in my case https://localhost.ngastana.42.fr)

You should see your **WordPress installation page** 📝

If this is your first time running it:
1. Choose your site’s language.
2. Fill in the installation form (site name, username, password, email).
3. Click **Install WordPress**.
4. Log in at **https://localhost/wp-admin** using your credentials.

From now on, your WordPress site is live inside Docker 🚀

> 🧠 **Note:**  
> - If you see a “connection not secure” warning, it’s normal — you’re using a self-signed SSL certificate.  
> - Just click **“Advanced → Proceed to localhost”** to continue.  
> - Don’t worry — it’s only on your local machine!

