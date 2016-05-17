# Spring Boot Hello World

A spring boot enabled hello world application

## Usage

- Directly using maven

	mvn spring-boot:run


- Using executable jar file

	mvn clean package
	java -jar target/helloworld-1.0-SNAPSHOT.jar

## Dockerfile

Dockerfile will build self-running container *after* a maven install is run


## CI/CD build via Jenkinsfile

1. run `mvn package`
2. run ` mvn test jacoco:report coveralls:report`
3. run `docker build` for the releasable docker container
4. push docker container
5. deploy docker contianer
