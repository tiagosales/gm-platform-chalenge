FROM java:8-jre-alpine
COPY ./build/libs/gm-platform-chalenge-0.0.1-SNAPSHOT.jar /opt/app/
WORKDIR /opt/app
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "gm-platform-chalenge-0.0.1-SNAPSHOT.jar"]
