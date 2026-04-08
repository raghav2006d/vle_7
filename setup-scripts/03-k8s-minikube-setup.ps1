# 03-k8s-minikube-setup.ps1
# Phase 3: Kubernetes Setup (Minikube and kubectl on Windows)

Write-Host "Installing Minikube and kubectl using winget..." -ForegroundColor Cyan

# Install Minikube
Write-Host "Installing Minikube..."
winget install minikube --accept-package-agreements --accept-source-agreements

# Install Kubectl
Write-Host "Installing kubectl..."
winget install Kubernetes.kubectl --accept-package-agreements --accept-source-agreements

# Refresh environment variables so minikube/kubectl are recognized if just installed
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

Write-Host "Starting Minikube using Docker driver..." -ForegroundColor Yellow
minikube start --driver=docker

Write-Host "Minikube started!" -ForegroundColor Green
kubectl get nodes
