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
                    // Wait for Tomcat to start
                    echo "Waiting for Tomcat to start..."
                    sleep(time: 30, unit: 'SECONDS') // Adjust time as necessary
                }
            }
        }

        stage('Check Tomcat Status') {
            steps {
                script {
                    // Define the URL to check
                    def tomcatUrl = 'http://localhost:9092/register'
                    def responseStatus = bat(script: "curl -s -o /dev/null -w \"%{http_code}\" ${tomcatUrl}", returnStdout: true).trim()

                    // Check if Tomcat is running
                    if (responseStatus == '200') {
                        echo "Tomcat is up and running on ${tomcatUrl}"
                    } else {
                        error("Tomcat is not accessible at ${tomcatUrl}, received HTTP status: ${responseStatus}")
                    }
                }
            }
        }

        stage('Show MySQL Data of Users') {
            steps {
                script {
                    // MySQL container name
                    def mysqlContainerName = 'mysql' // Adjust this if necessary

                    // Database credentials
                    def dbUser = 'hibernate-user' // MySQL username
                    def dbPassword = 'Dharan@123' // MySQL password
                    def dbName = 'hibernate' // MySQL database name
                    
                    // MySQL command to retrieve user data
                    def query = 'SELECT * FROM Users;' // Adjust this query based on your table structure
                    def mysqlCommand = "mysql -u ${dbUser} -p${dbPassword} -D ${dbName} -e \'${query}\'"

                    echo "Fetching MySQL data of users from container ${mysqlContainerName}..."
                    
                    // Execute the MySQL command inside the MySQL container
                    bat(script: "docker exec ${mysqlContainerName} sh -c \"${mysqlCommand}\"")
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
