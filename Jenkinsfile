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
                    def dockerStatus = bat(script: 'docker info', returnStatus: true)
                    if (dockerStatus != 0) {
                        error("Docker daemon is not running.")
                    }
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
                    bat 'docker-compose build   '
                    bat 'docker-compose up'
                }
            }
        }
        stage('Show MySQL Data of Users') {
            steps {
                script {
                    def mysqlContainerName = 'mysql'
                    def dbUser = 'hibernate-user'
                    def dbPassword = 'Dharan@123'
                    def dbName = 'hibernate'
                    def query = 'SELECT * FROM Users;'
                    def mysqlCommand = "mysql -u ${dbUser} -p${dbPassword} -D ${dbName} -e \'${query}\'"
                    echo "Fetching MySQL data of users from container ${mysqlContainerName}..."
                    bat(script: "docker exec ${mysqlContainerName} sh -c \"${mysqlCommand}\"")
                }
            }
        }

        stage('Wait for Tomcat') {
            steps {
                script {
                    echo "Waiting for Tomcat to start..."
                }
            }
        }

        stage('Open Tomcat URL') {
            steps {
                script {
                    echo "Tomcat is expected to be running on http://localhost:9092"
                }
            }
        }
    }
}
