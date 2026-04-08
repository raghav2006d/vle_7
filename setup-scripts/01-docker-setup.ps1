# 01-docker-setup.ps1
# Phase 1: Infrastructure Setup (Docker installation on Windows)

Write-Host "Installing Docker Desktop on Windows..." -ForegroundColor Cyan

# Check if docker is installed
if (Get-Command docker -ErrorAction SilentlyContinue) {
    Write-Host "Docker is already installed." -ForegroundColor Green
    docker --version
} else {
    Write-Host "Downloading and installing Docker Desktop using winget..."
    winget install Docker.DockerDesktop --accept-package-agreements --accept-source-agreements
    Write-Host "Docker Desktop installed. You MUST restart your PowerShell or restart Windows for the changes to take effect and start Docker Desktop manually." -ForegroundColor Yellow
}
