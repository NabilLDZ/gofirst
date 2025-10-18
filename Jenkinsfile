pipeline {
    agent any

    environment {
        DOCKERHUB_USER = 'nabilondocker'
        IMAGE_NAME     = 'gofirst'
    }

    stages {

        stage('Checkout Source Code') {
            steps {
                echo 'Cloning repository...'
                git branch: 'main', url: 'https://github.com/NabilLDZ/gofirst.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image...'
                sh '''
                    docker build -t $DOCKERHUB_USER/$IMAGE_NAME:latest .
                '''
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                echo 'Logging in to Docker Hub and pushing image...'
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push $DOCKER_USER/$IMAGE_NAME:latest
                    '''
                }
            }
        }

        stage('Deploy to Server 2') {
            steps {
                echo 'Deploying to remote server...'
                sshagent(credentials: ['goappdev-ssh']) {
                    sh '''
                        ssh -o StrictHostKeyChecking=no ubuntu@136.110.0.5 << EOF
                        echo "Pulling latest Docker image..."
                        docker pull $DOCKERHUB_USER/$IMAGE_NAME:latest

                        echo "Stopping existing container if exists..."
                        docker stop $IMAGE_NAME || true
                        docker rm $IMAGE_NAME || true

                        echo "Running new container..."
                        docker run -d -p 5678:5678 --name $IMAGE_NAME $DOCKERHUB_USER/$IMAGE_NAME:latest
                        EOF
                    '''
                }
            }
        }
    }

    post {
        always {
            echo 'Cleaning up Docker login locally...'
            sh 'docker logout || true'
        }
        success {
            echo 'Pipeline executed successfully ✅'
        }
        failure {
            echo 'Pipeline failed ❌'
        }
    }
}
