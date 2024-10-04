pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Kill Existing Processes') {
            steps {
                script {
                    // Kill process on port 3306 if exists
                    def port3306 = sh(script: "netstat -ano | findstr :3306", returnStdout: true).trim()
                    if (port3306) {
                        def pid = port3306.tokenize().last() // Get the last token (PID)
                        sh "taskkill /PID ${pid} /F" // Kill the process
                    }

                    // Kill process on port 9092 if exists
                    def port9092 = sh(script: "netstat -ano | findstr :9092", returnStdout: true).trim()
                    if (port9092) {
                        def pid = port9092.tokenize().last() // Get the last token (PID)
                        sh "taskkill /PID ${pid} /F" // Kill the process
                    }
                }
            }
        }

        stage('Run Docker Compose') {
            steps {
                script {
                    sh 'docker-compose up -d'
                }
            }
        }
    }

    post {
        always {
            script {
                // Ensure Docker is running before attempting to bring down the containers
                sh 'docker-compose down'
            }
        }
    }
}
