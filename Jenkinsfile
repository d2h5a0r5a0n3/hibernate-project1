pipeline {
    agent any

    environment {
        COMPOSE_FILE = 'docker-compose.yml'  // Path to your docker-compose.yml
        TOMCAT_PORT = '9092'  // Define your Tomcat port here
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout the source code, including docker-compose.yml
                checkout scm
            }
        }

        stage('Run Docker Compose') {
            steps {
                script {
                    // Run docker-compose to build and start services
                    bat 'docker-compose up -d'
                }
            }
        }

        stage('Wait for Tomcat') {
            steps {
                script {
                    // Wait until Tomcat is up and running on the specified port
                    waitUntil {
                        script {
                            def tomcatReady = sh(script: "curl -s -o /dev/null -w '%{http_code}' http://localhost:${TOMCAT_PORT}", returnStatus: true) == 0
                            return tomcatReady
                        }
                    }
                }
            }
        }

        stage('Open Tomcat URL') {
            steps {
                script {
                    // Print the URL to access Tomcat
                    echo "Tomcat is running! Access it at http://localhost:${TOMCAT_PORT}"
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
