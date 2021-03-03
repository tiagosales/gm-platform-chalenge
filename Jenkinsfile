node {
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
        ECR_ADDRESS = sh(script: 'bash get-ecr-repo.sh ${REPO_NAME} ${REGION}', returnStdout: true)
        withEnv(['ECR_ADDRESS=${ECR_ADDRESS}']){
          docker.withRegistry("https://${ECR_ADDRESS}", '') {
            sh("aws ecr --no-verify-ssl get-login-password --region ${REGION} | docker login --username AWS --password-stdin ${ECR_ADDRESS}")
            docker.image('gmile-challenge').push("${env.BUILD_NUMBER}")
            docker.image('gmile-challenge').push("latest")
          }
        }
      }
    }
}
