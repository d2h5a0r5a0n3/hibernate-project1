# Stage 1: Build Stage
FROM openjdk:11 AS BUILD_IMAGE

# Install Maven and Git
RUN apt update && apt install -y maven git

RUN git config --global http.postBuffer 1048576000  # Set Git post buffer size

# Clone the repository
RUN git clone --depth=1 https://github.com/d2h5a0r5a0n3/hibernate-project1.git

# Change directory and build the project
WORKDIR /hibernate-project1
RUN mvn clean install
RUN mvn clean package

# Remove the target folder to reduce image size
RUN rm -rf /hibernate-project1/target

# Stage 2: Runtime Stage
FROM tomcat:9-jre11

# Remove default web applications
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the WAR file from the build stage to Tomcat's webapps directory
COPY --from=BUILD_IMAGE /hibernate-project1/target/hibernate-project.war /usr/local/tomcat/webapps/ROOT.war

# Change Tomcat's server port to 9092
RUN sed -i 's/8080/9092/g' /usr/local/tomcat/conf/server.xml

# Expose Tomcat's new port (9092)
EXPOSE 9092

# Start Tomcat
CMD ["catalina.sh", "run"]
