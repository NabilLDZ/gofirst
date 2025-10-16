pipeline {
    agent any

    environment {
        DOCKERHUB_USER = 'nabilondocker'           // ganti username Docker Hub kamu
        IMAGE_NAME = 'gofirst'
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/NabilLDZ/gofirst.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $DOCKERHUB_USER/$IMAGE_NAME:latest .'
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([string(credentialsId: 'dockerhub-token', variable: 'DOCKERHUB_PASS')]) {
                    sh '''
                        echo "$DOCKERHUB_PASS" | docker login -u "$DOCKERHUB_USER" --password-stdin
                        docker push $DOCKERHUB_USER/$IMAGE_NAME:latest
                    '''
                }
            }
        }

        stage('Deploy to Server 2') {
            steps {
                sh '''
                    ssh -o StrictHostKeyChecking=no ubuntu@SERVER2_IP "
                        docker pull $DOCKERHUB_USER/$IMAGE_NAME:latest &&
                        docker stop gofirst || true &&
                        docker rm gofirst || true &&
                        docker run -d -p 5678:5678 --name gofirst $DOCKERHUB_USER/$IMAGE_NAME:latest
                    "
                '''
            }
        }
    }
}
