pipeline {
  agent any
  
  environment {
      DOCKER_IMAGE = "myapp"
  }

  stages {
    stage('Checkout') {
      steps {
        // In a real scenario, this gets the source code from SCM.
        // For this lab, we assume the code or Dockerfile is present.
        echo 'Checking out code...'
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
