node {
    
  stage 'Checkout'

  git 'https://github.com/kulinski/jenkins-docker-maven-example.git'

  stage 'Build and Test'

  // Build using a plain docker container, not our local Dockerfile
  docker.image('jimschubert/8-jdk-alpine-mvn').inside('-u root:root') {
    sh 'mvn package'
	sh 'mvn test jacoco:report coveralls:report'         
  }
        
  stage 'Package Docker image'

  // Build final releasable image using our Dockerfile
  def img = docker.build('jenkins-docker-maven-example:latest', '.')

        // Let's tag and push the newly built image. Will tag using the image name provided
        // in the 'docker.build' call above (which included the build number on the tag).
        //pcImg.push();
    
   stage name: 'Deploy Image', concurrency: 1
        // All the tests passed. We can now retag and push the 'latest' image
   //     pcImg.push('latest');    
}