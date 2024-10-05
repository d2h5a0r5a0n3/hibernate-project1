# Stage 1: Build Stage
FROM openjdk:11 AS BUILD_IMAGE
RUN apt update && apt install -y maven git
RUN git config --global http.postBuffer 1048576000
RUN git clone --depth=1 https://github.com/d2h5a0r5a0n3/hibernate-project1.git
WORKDIR /hibernate-project1
RUN mvn clean install
RUN mvn clean package
# Stage 2: Runtime Stage
FROM tomcat:9-jre11
RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=BUILD_IMAGE /hibernate-project1/target/hibernate-project.war /usr/local/tomcat/webapps/ROOT.war
RUN sed -i 's/8080/9092/g' /usr/local/tomcat/conf/server.xml
EXPOSE 9092
RUN rm -rf /hibernate-project1/target
CMD ["catalina.sh", "run"]
