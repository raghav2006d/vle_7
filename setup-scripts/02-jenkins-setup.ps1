# 02-jenkins-setup.ps1
# Phase 2: CI/CD using Jenkins (Installation on Windows using Docker)

Write-Host "Starting Jenkins in a Docker container..." -ForegroundColor Cyan

# Check if docker is running
if (!(Get-Process "Docker Desktop" -ErrorAction SilentlyContinue)) {
    Write-Host "Docker Desktop doesn't seem to be running. Please start Docker Desktop first!" -ForegroundColor Yellow
}

# Run Jenkins container
Write-Host "Running jenkins/jenkins:lts container..."
docker run -d -p 8080:8080 -p 50000:50000 -v jenkins_home:/var/jenkins_home --name jenkins jenkins/jenkins:lts

if ($?) {
    Write-Host "Waiting 20 seconds for Jenkins to initialize to fetch the initial password..." -ForegroundColor Yellow
    Start-Sleep -Seconds 20

    Write-Host "Jenkins is up. Initial Admin Password:" -ForegroundColor Green
    docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
    Write-Host "Access Jenkins at http://localhost:8080" -ForegroundColor Cyan
} else {
    Write-Host "Failed to start Jenkins container. If it already exists, use 'docker start jenkins'." -ForegroundColor Red
}
