pipeline {
  agent any
  
  environment {
      DOCKER_IMAGE = "myapp"
  }

  stages {
    stage('Checkout') {
      steps {
        echo "Checking out code from https://github.com/raghav2006d/vle_7.git..."
        git branch: 'main', url: 'https://github.com/raghav2006d/vle_7.git'
      }
    }
    
    stage('Build Docker Image') {
      steps {
        // Assumes a Dockerfile is available in the root directory.
        // If not, we will create a dummy one or use standard nginx.
        sh 'docker build -t ${DOCKER_IMAGE}:latest .'
      }
    }
    
    stage('Deploy to Kubernetes') {
      steps {
        // Assumes Minikube and Kubectl are configured for the Jenkins user
        // We apply the deployment.yaml to the Kubernetes cluster
        sh 'kubectl apply -f k8s/deployment.yaml'
      }
    }
    
    stage('Verify Deployment') {
      steps {
        // Quick verification of the pods
        sh 'kubectl get pods -l app=myapp'
      }
    }
  }
}
