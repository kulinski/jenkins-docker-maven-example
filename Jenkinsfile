node {
    
  stage 'Checkout'
  //git 'https://github.com/kulinski/jenkins-docker-maven-example.git'
  // shortcut to checkout from where this Jenkinsfile is hosted
  checkout scm

  stage 'Build and Test'
  // Build using a plain docker container, not our local Dockerfile
  def mvnContainer = docker.image('jimschubert/8-jdk-alpine-mvn')
  mvnContainer.inside('-v /m2repo:/m2repo') {
      // Set up a shared Maven repo so we don't need to download all dependencies on every build.
      writeFile file: 'settings.xml',
         text: '<settings><localRepository>/m2repo</localRepository></settings>'
      
      // Build with maven settings.xml file that specs the local Maven repo.
      sh 'mvn -B -s settings.xml package'
   }
        
  stage 'Package Docker image'
  // Build final releasable image using our Dockerfile and the docker.build cmd
  // This container only contains the packaged jar, not the source or interim build steps
  def img = docker.build('jenkins-docker-maven-example:latest', '.')
    
  stage name: 'Push Image', concurrency: 1
  // All the tests passed. We can now retag and push the 'latest' image
  docker.withRegistry('https://nexus.doyouevenco.de', 'nexus-admin') {
     img.push('latest')
  }
    
  stage 'Pull Image'
  // Now let's pull it to test that a pull from Nexus works correctly
  docker.withRegistry('https://nexus.doyouevenco.de', 'nexus-admin') {
     docker.image("jenkins-docker-maven-example:latest").pull()
  }
  
  stage 'Pull EB deploy container'
   // use container that has AWS EB CLI installed from a "trusted" source
   def ebcliDocker = docker.image("kulinski/aws-ebcli")
   ebcliDocker.pull()
   
   //Now we deploy
  stage 'Deploy Production to Beanstalk'
   ebcliDocker.inside() {
     // sh '''
     //    ebEnv="prod"
     //    
     //    # Check to see if the eb environment exists and then run create or deploy depending
     //    createCheck=`eb status $ebEnv`
     //    if [[ -z "${createCheck##*Status*}" ]]; then
     //       eb deploy $ebEnv
     //    else
     //       eb create $ebEnv --instance_profile IAM-3-ElasticBeanstalkEC2InstanceProfile-XXXXXX --service-role IAM-3-ElasticBeanstalkServiceRole-XXXXXX
     //    fi
     // '''
     sh ' eb --version'
   } 
    
}
