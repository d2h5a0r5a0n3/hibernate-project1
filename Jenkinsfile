pipeline {
    agent any

    environment {
        COMPOSE_FILE = 'docker-compose.yml'  // Path to your docker-compose.yml
        TOMCAT_PORT = '9092'  // Define your Tomcat port here
        MYSQL_PORT = '3306'   // Define your MySQL port here
    }

    stages {
        stage('Run Docker Compose') {
            steps {
                script {
                    // Run docker-compose to build and start services
                    sh 'docker-compose build'
                }
            }
        }
    }
    post {
        always {
            // Stop and clean up Docker containers after the job
            script {
                bat 'docker-compose down'
            }
        }
    }
}
