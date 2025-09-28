# Custom Backup Automation on Kubernetes  

This repository provides an automated backup solution for various databases and object storage systems (e.g., **InfluxDB**, **MongoDB**, and **MinIO**) running on Kubernetes.  
The solution is built around a **custom Docker image** and a **Kubernetes CronJob** to schedule and manage backups.  

---

## ✨ Features  
- **Supports multiple data sources**: InfluxDB, MongoDB, MinIO (can be extended easily).  
- **Custom Ubuntu-based image** with all required CLI tools installed.  
- **Automated backups via Bash script** (set as container entrypoint).  
- **Timestamped backups** (daily tags for clarity and versioning).  
- **Automatic cleanup of old backups** (retention period configurable by days).  
- **Secrets management** via Kubernetes `Secret` objects for secure access credentials.  
- **Runs on schedule** using Kubernetes `CronJob` for full automation.  

---


