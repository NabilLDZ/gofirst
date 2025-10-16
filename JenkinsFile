pipeline {
    agent any

    environment {
        IMAGE = "nabilldz/gofirst:latest"
        DEPLOY_USER = "servergolangadmin"
        DEPLOY_SERVER = "35.247.180.230"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/NabilLDZ/gofirst.git'
            }
        }

        stage('Build') {
            steps {
                sh 'go mod tidy'
                sh 'go build -o gofirst'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${IMAGE} ."
            }
        }

        stage('Push to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh """
                    echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                    docker push ${IMAGE}
                    docker logout
                    """
                }
            }
        }

        stage('Deploy to Server2') {
            steps {
                sshagent(['ssh-server2-key']) {
                    sh """
                    ssh -o StrictHostKeyChecking=no ${DEPLOY_USER}@${DEPLOY_SERVER} '
                      docker login -u ${DOCKER_USER} -p ${DOCKER_PASS}
                      docker pull ${IMAGE}
                      docker stop gofirst || true
                      docker rm gofirst || true
                      docker run -d --name gofirst -p 80:8080 ${IMAGE}
                      docker logout
                    '
                    """
                }
            }
        }
    }
}
