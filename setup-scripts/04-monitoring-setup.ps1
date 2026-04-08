# 04-monitoring-setup.ps1
# Phase 4 & 5: Monitoring Setup (Helm, Prometheus, Grafana)

Write-Host "Installing Helm using winget..." -ForegroundColor Cyan
winget install Helm.Helm --accept-package-agreements --accept-source-agreements

# Refresh environment variables
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

Write-Host "Adding Prometheus Community Helm Repo..." -ForegroundColor Yellow
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

Write-Host "Creating 'monitoring' namespace..."
kubectl create namespace monitoring

Write-Host "Installing kube-prometheus-stack..." -ForegroundColor Yellow
helm install monitoring prometheus-community/kube-prometheus-stack -n monitoring

Write-Host "Monitoring stack installed successfully!" -ForegroundColor Green
Write-Host "To access Grafana locally, run:" -ForegroundColor Cyan
Write-Host "kubectl port-forward svc/monitoring-grafana 3000:80 -n monitoring"
Write-Host "Login to Grafana at http://localhost:3000 with admin / prom-operator"
