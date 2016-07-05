
def applicationName = "jenkins-docker-maven-example"
def beanstalkRegion = "us-east-1"
def beanstalkInstanceProfile = ""
def beanstalkServiceRole = ""

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
  // Now let's pull it, just to test that a pull from Nexus works correctly
  docker.withRegistry('https://nexus.doyouevenco.de', 'nexus-admin') {
     docker.image("jenkins-docker-maven-example:latest").pull()
  }
  
  stage 'Pull EB deploy container'
   // Check to ensure that we can access the EB deploy commands container
   def ebcliDocker = docker.image("coxauto/aws-ebcli")
   ebcliDocker.pull()
   
   //Now we deploy
  stage 'Deploy Production to Beanstalk'
  
    createBeanstalkEnvironmentsIfUnavailable(applicationName, applicationName, applicationName,
       beanstalkRegion, beanstalkInstanceProfile, beanstalkServiceRole)
    
    deployToEnvironment(applicationName)
    
}


def createBeanstalkEnvironmentsIfUnavailable(appName, env, cnamePrefix, region, ip, role) {
    echo 'Verifying availability of beanstalk app: ' + appName + ' and env: ' + env + ' in region ' + region

    def ebcliDocker = docker.image("coxauto/aws-ebcli")

    ebcliDocker.inside() {
        sh 'aws elasticbeanstalk describe-environments --region ' + region + ' --application-name ' + appName + ' --query \'Environments[?EnvironmentName==`' + env + '`]\' > env.available'
    }

    def ebEnvStatus = readFile('env.available');

    if (ebEnvStatus.contains(env) && ! ebEnvStatus.contains('Terminated')) {
        echo 'Environment ' + env + ' is available for deployment'
    } else {
        echo 'Environment' + env + ' is not available.  Creating beanstalk environment...'
        ebcliDocker.inside() {
            sh 'eb create ' + env + ' -c ' + cnamePrefix + ' --sample ' //--instance_profile ' + ip + ' --service-role ' + role
        }
    }
}

def deployToEnvironment(env) {
    echo 'Deploying to ' + env

    def ebcliDocker = docker.image("coxauto/aws-ebcli")
    ebcliDocker.inside() {
        sh 'eb deploy ' + env
    }

    echo 'Completed deployment'
}
