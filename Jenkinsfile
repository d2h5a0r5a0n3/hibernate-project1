pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Check and Stop Existing Containers') {
            steps {
                script {
                    // Check if the Docker daemon is running
                    def dockerStatus = bat(script: 'docker info', returnStatus: true)

                    if (dockerStatus != 0) {
                        error("Docker daemon is not running.")
                    }
                    
                    // Stop containers on port 3306 and 9092 if they are running
                    try {
                        bat(script: 'docker ps --filter "publish=3306" -q | ForEach-Object { docker stop $_ }')
                    } catch (Exception e) {
                        echo "No containers running on port 3306."
                    }
                    try {
                        bat(script: 'docker ps --filter "publish=9092" -q | ForEach-Object { docker stop $_ }')
                    } catch (Exception e) {
                        echo "No containers running on port 9092."
                    }
                }
            }
        }

        stage('Run Docker Compose') {
            steps {
                script {
                    // Run Docker Compose to start your containers
                    bat 'docker-compose up -d'
                }
            }
        }

        stage('Wait for Tomcat') {
            steps {
                script {
                    // Optionally add logic to wait for Tomcat to be up
                    echo "Waiting for Tomcat to start..."
                    sleep(time: 30, unit: 'SECONDS') // Adjust time as necessary
                }
            }
        }

        stage('Open Tomcat URL') {
            steps {
                script {
                    // Example to open Tomcat URL (if needed)
                    echo "Tomcat is expected to be running on http://localhost:9092"
                }
            }
        }
    }
}
