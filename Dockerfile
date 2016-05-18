FROM jimschubert/8-jdk-alpine-mvn
MAINTAINER Chris Kulinski

COPY ./target/*.jar /data/springboot-helloworld/
WORKDIR /data/springboot-helloworld

EXPOSE 8090

CMD ["java", "-jar", "helloworld-1.0-SNAPSHOT.jar"]
