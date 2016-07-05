# Spring Boot Hello World

A spring boot enabled hello world application

## Usage

- Directly using maven

	`mvn spring-boot:run`


- Using executable jar file

	`mvn clean package`
	`java -jar target/helloworld-1.0-SNAPSHOT.jar`

## Dockerfile

Dockerfile will build self-running container *after* a maven install is run


## CI/CD build via Jenkinsfile

1. run `mvn package` - builds, tests and packages
3. run `docker build` for the releasable docker container
4. push docker container to Nexus
5. create Beanstalk env
6. deploy docker container into Beanstalk
