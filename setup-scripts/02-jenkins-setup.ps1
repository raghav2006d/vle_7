# 02-jenkins-setup.ps1
# Phase 2: CI/CD using Jenkins (Installation on Windows using Docker)

Write-Host "Starting Jenkins in a Docker container..." -ForegroundColor Cyan

# Check if docker is running
if (!(Get-Process "Docker Desktop" -ErrorAction SilentlyContinue)) {
    Write-Host "Docker Desktop doesn't seem to be running. Please start Docker Desktop first!" -ForegroundColor Yellow
}

# Run Jenkins container with docker socket mounted
Write-Host "Running jenkins/jenkins:lts container..."
docker rm -f jenkins 2>$null
docker run -d -u root -p 8080:8080 -p 50000:50000 -v jenkins_home:/var/jenkins_home -v //var/run/docker.sock:/var/run/docker.sock --name jenkins jenkins/jenkins:lts

if ($?) {
    Write-Host "Installing Docker & Kubectl inside the Jenkins agent..." -ForegroundColor Yellow
    docker exec -u root jenkins apt-get update
    docker exec -u root jenkins apt-get install -y docker.io
    docker exec -u root jenkins bash -c "curl -LO 'https://dl.k8s.io/release/v1.30.0/bin/linux/amd64/kubectl' && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && rm kubectl"

    Write-Host "Waiting 10 seconds for Jenkins to initialize to fetch the initial password..." -ForegroundColor Yellow
    Start-Sleep -Seconds 10

    Write-Host "Jenkins is up. Initial Admin Password:" -ForegroundColor Green
    docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
    Write-Host "Access Jenkins at http://localhost:8080" -ForegroundColor Cyan
} else {
    Write-Host "Failed to start Jenkins container. Ensure Docker Desktop is running." -ForegroundColor Red
}
