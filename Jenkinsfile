node {
    stage('Clonar repo') {
        checkout scm
    }

    stage('Build') {
         sh './gradlew clean build'
         archiveArtifacts artifacts: 'build/libs/*.jar'
    }

    stage('Realizar o build da imagem') {
         docker.build('gmile-challenge')
    }

    stage('Push image') {
       withCredentials([string(credentialsId: 'ecr-address', variable: 'ECR_ADDRESS')]) {
           docker.withRegistry("https://${ECR_ADDRESS}", '') {
               sh('aws ecr --no-verify-ssl get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${ECR_ADDRESS}')
               docker.image('gmile-challenge').push("${env.BUILD_NUMBER}")
               docker.image('gmile-challenge').push("latest")
           }
       }
    }
}
