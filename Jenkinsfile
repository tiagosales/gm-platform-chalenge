node {
    def REPO_NAME = 'gmile-challenge'
    def REGION = 'us-east-1'

    stage('Clonar repo') {
        checkout scm
    }

    stage('Build') {
         sh './gradlew clean build'
         //archiveArtifacts artifacts: 'build/libs/*.jar'
    }

    stage('Realizar o build da imagem') {
         docker.build('gmile-challenge')
    }

    withEnv(['REPO_NAME=gmile-challenge', 'REGION=us-east-1']){
      stage('Push image') {
        ECR_ADDRESS = sh script: "aws ecr --no-verify-ssl describe-repositories --repository-names ${REPO_NAME} --region ${REGION} | grep repositoryUri | awk -F: {\\\'print \\\$2 \\\'} | tr -d \\\",|awk {\\\'print \\\$1 \\\'}", returnStdout: true
        sh('echo ecr_addr = ${ECR_ADDRESS}')
        docker.withRegistry("https://${ECR_ADDRESS}", '') {
          sh('aws ecr --no-verify-ssl get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${ECR_ADDRESS}')
          docker.image('gmile-challenge').push("${env.BUILD_NUMBER}")
          docker.image('gmile-challenge').push("latest")
        }
      }
    }
}
