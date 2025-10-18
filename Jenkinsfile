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
                withCredentials([sshUserPrivateKey(credentialsId: 'goappdev-ssh', keyFileVariable: 'SSH_KEY')]) {
                    sh '''
                        ssh -o StrictHostKeyChecking=no -i $SSH_KEY jenkins-deploy@136.110.0.5 "
                            docker pull $DOCKERHUB_USER/$IMAGE_NAME:latest &&
                            docker stop $IMAGE_NAME || true &&
                            docker rm $IMAGE_NAME || true &&
                            docker run -d -p 5678:5678 --name $IMAGE_NAME $DOCKERHUB_USER/$IMAGE_NAME:latest
                        "
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
