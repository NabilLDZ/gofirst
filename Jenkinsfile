pipeline {
    agent any

    environment {
        DOCKERHUB_USER = 'nabilondocker'
        IMAGE_NAME     = 'gofirst'
    }

    stages {
        stage('Checkout Source Code') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $DOCKERHUB_USER/$IMAGE_NAME:latest .'
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push $DOCKER_USER/$IMAGE_NAME:latest
                    '''
                }
            }
        }

        stage('Deploy to Server 2') {
            steps {
                sshagent(credentials: ['jenkins-deployy']) {
                sh '''
                    ssh -o StrictHostKeyChecking=no jenkins-deploy@136.110.0.5 \
                    'docker pull nabilondocker/gofirst:latest &&
                    docker stop gofirst || true &&
                    docker rm gofirst || true &&
                    docker run -d -p 5678:5678 --name gofirst nabilondocker/gofirst:latest'
                '''
                }
            }
        }
    }

    post {
        always {
            sh 'docker logout || true'
        }
    }
}
