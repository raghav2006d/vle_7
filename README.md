# VLE-7: Full DevOps Monitoring System (Local Windows Setup)

This project contains all the necessary scripts, pipelines, and manifests to fulfill the VLE-7 DevOps lab, combining local Windows utilities, Docker, Jenkins, Kubernetes (Minikube), and Prometheus + Grafana.

## Prerequisites
- A Windows System with PowerShell.
- Docker Desktop installed and running ([Download here](https://www.docker.com/products/docker-desktop)).
- Optional: Windows Subsystem for Linux (WSL 2) enabled for better Docker Desktop performance.

---

## Instructions

All setup scripts for Windows are provided in the `setup-scripts` directory as PowerShell (`.ps1`) scripts.

### Phase 1 & 2: Infrastructure & Jenkins

If you don't have Docker Desktop installed, run:
```powershell
.\setup-scripts\01-docker-setup.ps1
```
*(Note: Requires PowerShell restart after installation.)*

We will run Jenkins locally using a Docker container for a clean setup.
```powershell
.\setup-scripts\02-jenkins-setup.ps1
```
- Wait for the script to print the initial admin password.
- Go to `http://localhost:8080` in your browser, paste the password, and install the suggested plugins.

### Phase 3: Kubernetes Setup (Minikube)

We will install Minikube (`minikube`) and `kubectl` using Windows Package Manager (`winget`) and start the cluster using the Docker driver.

```powershell
.\setup-scripts\03-k8s-minikube-setup.ps1
```

### Phase 4 & 5: Monitoring Stack (Helm & Prometheus)

We install Helm via `winget` and configure the Prometheus community stack on our local cluster.

```powershell
.\setup-scripts\04-monitoring-setup.ps1
```

### Phase 6: CI/CD Pipeline & Deploying the App

1. In Jenkins at `http://localhost:8080`, install the **Docker Pipeline** and **Kubernetes** plugins.
2. Create a Pipeline job in Jenkins and paste the contents of `Jenkinsfile`.
   *(Note: Since Jenkins is running inside a container, direct commands mapped to your Windows host's Minikube cluster might require advanced configuration. For local testing, you can deploy the sample app manually.)*
3. **Deploy Sample App Manually:**
   ```powershell
   kubectl apply -f .\k8s\deployment.yaml
   ```

### Accessing Grafana Locally

The Helm stack provides standard dashboards out of the box.

1. Port-forward the Grafana service to your localhost:
   ```powershell
   kubectl port-forward svc/monitoring-grafana 3000:80 -n monitoring
   ```
2. Open `http://localhost:3000`
3. Username: `admin`
4. Password: `prom-operator`

### Alert Registration

Apply our custom alerting rules for PodCrashLoop, High CPU, and Node down:
```powershell
kubectl apply -f .\k8s\prometheus-alerts.yaml
```

You can view these alerts in the Prometheus UI by port-forwarding Prometheus:
```powershell
kubectl port-forward svc/monitoring-prometheus 9090:9090 -n monitoring
```
Then browsing to `http://localhost:9090/alerts`.

---

## CI/CD + Monitoring Integration Summary
1. Changes to `index.html` or `Dockerfile` are pushed.
2. Jenkins builds the Docker Image.
3. Code is deployed into Minikube via `kubectl`.
4. Prometheus scrapes your local Minikube cluster metrics.
5. Grafana visualizes the local pods.
6. Alertmanager tracks metrics based on `prometheus-alerts.yaml` to trigger alerts on app failures.
