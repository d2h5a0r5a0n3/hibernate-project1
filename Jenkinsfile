pipeline {
    agent any  // Use any available agent for this pipeline

    stages {
        stage('Start') {
            steps {
                echo 'Starting the pipeline...'
            }
        }

        stage('Build') {
            steps {
                echo 'Building the project...'
            }
        }

        stage('Test') {
            steps {
                echo 'Running tests...'
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying the application...'
            }
        }

        stage('End') {
            steps {
                echo 'Pipeline finished!'
            }
        }
    }
}
