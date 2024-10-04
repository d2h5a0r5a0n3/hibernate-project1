pipeline {
    agent any

    environment {
        MYSQL_USER = 'hibernate-user'
        MYSQL_PASSWORD = 'Dharan@123'
        MYSQL_DATABASE = 'hibernate'
        MYSQL_CONTAINER = 'mysql'  // Use the custom container name
        TOMCAT_PORT = '9092'       // Define your Tomcat port here
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Run Docker Compose') {
            steps {
                sh 'docker-compose up -d'
            }
        }

        stage('Wait for MySQL') {
            steps {
                script {
                    waitUntil {
                        script {
                            def mysqlReady = sh(script: "docker exec ${MYSQL_CONTAINER} mysqladmin ping -u${MYSQL_USER} -p${MYSQL_PASSWORD} --silent", returnStatus: true) == 0
                            return mysqlReady
                        }
                    }
                }
            }
        }

        stage('Query MySQL') {
            steps {
                script {
                    // Run SQL query inside the MySQL container and capture output
                    def queryResult = sh(script: """
                        docker exec ${MYSQL_CONTAINER} mysql -u${MYSQL_USER} -p${MYSQL_PASSWORD} ${MYSQL_DATABASE} -e "SELECT * FROM Users;"
                    """, returnStdout: true).trim()
                    
                    // Print the output of the query
                    echo "Query Result: \n${queryResult}"
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
            sh 'docker-compose down'
        }
    }
}
