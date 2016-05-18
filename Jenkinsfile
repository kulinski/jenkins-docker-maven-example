node {
    
  stage 'Checkout'

  git 'https://github.com/kulinski/jenkins-docker-maven-example.git'

  stage 'Build and Test'

  // Build using a plain docker container, not our local Dockerfile
  docker.image('jimschubert/8-jdk-alpine-mvn').inside('-u root:root') {
    sh 'mvn -B package'
	// package goal also runs tests      
  }
        
  stage 'Package Docker image'

  // Build final releasable image using our Dockerfile
  // This container only contains the packaged jar, not the source or interim build steps
  def img = docker.build('jenkins-docker-maven-example:latest', '.')
    
   stage name: 'Deploy Image', concurrency: 1
        // All the tests passed. We can now retag and push the 'latest' image
   //     pcImg.push('latest');    
}
