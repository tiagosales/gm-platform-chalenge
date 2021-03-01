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
           docker.withRegistry('', '') {
               sh 'aws ecr --no-verify-ssl get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${ECR_ADDRESS}'
               docker.image('gmile-challenge').tag('${ECR_ADDRESS}/gmile-challenge','latest')
               docker.image('${ECR_ADDRESS}/gmile-challenge').push("${env.BUILD_NUMBER}")
               docker.image('${ECR_ADDRESS}/gmile-challenge').push("latest")
           }
       }
    }
}
