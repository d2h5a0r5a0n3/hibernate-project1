# Stage 1: Build Stage
FROM openjdk:11 AS BUILD_IMAGE

# Install Maven
RUN apt update && apt install -y maven git

RUN git config --global http.postBuffer 1048576000  # 1 GB

# Clone the repository
RUN git clone https://github.com/d2h5a0r5a0n3/hibernate-project1.git

# Change directory and build the project
WORKDIR /hibernate-project1
RUN mvn clean package -DskipTests

# Stage 2: Runtime Stage
FROM tomcat:9-jre11

# Remove default web applications
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the WAR file from the build stage to Tomcat's webapps directory
COPY --from=BUILD_IMAGE /hibernate-project1/target/hibernate-project.war /usr/local/tomcat/webapps/

# Expose Tomcat's default port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
