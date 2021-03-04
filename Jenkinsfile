node {
    stage('Clone repo') {
        checkout scm
    }

    stage('Build app') {
         sh './gradlew clean build'
         //archiveArtifacts artifacts: 'build/libs/*.jar'
    }

    stage('Build docker image') {
         docker.build('gmile-app')
    }

    withEnv(['REPO_NAME=gmile-repo', 'REGION=us-east-1','CLUSTER=gmile-ecs-cluster','SERVICE_NAME=gmile-service','TASKDEF=gmile-app:1','NUMTASKS=1']){
      stage('Push docker image') {
        ECR_ADDRESS = sh(script: 'bash get-ecr-repo.sh ${REPO_NAME} ${REGION}', returnStdout: true)
        withEnv(['ECR_ADDRESS=${ECR_ADDRESS}']){
          docker.withRegistry("https://$ECR_ADDRESS", '') {
            sh("aws ecr --no-verify-ssl get-login-password --region ${REGION} | docker login --username AWS --password-stdin ${ECR_ADDRESS}")
            docker.image('gmile-challenge').push("${env.BUILD_NUMBER}")
            docker.image('gmile-challenge').push("latest")
            sh("aws ecs --no-verify-ssl update-service --cluster ${CLUSTER} --region ${REGION} --service ${SERVICE_NAME} --task-definition ${TASKDEF} --desired-count ${NUMTASKS} --force-new-deployment")
          }
        }
      }
    }
}
