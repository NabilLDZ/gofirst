pipeline {
    agent any

    environment {
        DOCKERHUB_USER = 'nabilldz'       // ganti username Docker Hub kamu
        IMAGE_NAME = 'gofirst'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/NabilLDZ/gofirst.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $DOCKERHUB_USER/$IMAGE_NAME:latest .'
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push $DOCKER_USER/$IMAGE_NAME:latest
                    '''
                }
            }
        }

        stage('Deploy to Server 2') {
            steps {
                sshagent(['ssh-server2-key']) {
                    sh '''
                        ssh -o StrictHostKeyChecking=no ubuntu@35.247.180.230 "
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

    post {
        always {
            sh 'docker logout'
        }
    }
}
