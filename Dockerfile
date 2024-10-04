# Stage 1: Build Stage
FROM openjdk:11 AS BUILD_IMAGE

# Install Maven
RUN apt update && apt install -y maven

# Set the working directory
WORKDIR /app

# Copy the local Maven project files into the container
COPY . .

# Build the project
RUN mvn clean package -DskipTests

# Stage 2: Runtime Stage
FROM tomcat:9-jre11

# Remove default web applications
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the WAR file from the build stage to Tomcat's webapps directory
COPY --from=BUILD_IMAGE /app/target/hibernate-project.war /usr/local/tomcat/webapps/ROOT.war

# Change Tomcat's server port to 9092
RUN sed -i 's/8080/9092/g' /usr/local/tomcat/conf/server.xml

# Expose Tomcat's new port (9092)
EXPOSE 9092

# Start Tomcat
CMD ["catalina.sh", "run"]
