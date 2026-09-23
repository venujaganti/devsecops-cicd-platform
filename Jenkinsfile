pipeline {
    agent any

    environment {
        PROJECT_NAME = 'devsecops-cicd-platform'
    }

    stages {
        stage('Foundation Check') {
            steps {
                echo "Starting ${PROJECT_NAME} foundation pipeline"
                echo "Phase 1 - Project Foundation"
            }
        }

        stage('Git Check') {
            steps {
                sh 'git --version'
            }
        }

        stage('Podman Check') {
            steps {
                sh 'podman --version'
            }
        }
    }

    post {
        success {
            echo 'Phase 1 foundation pipeline completed successfully.'
        }

        failure {
            echo 'Phase 1 foundation pipeline failed.'
        }
    }
}