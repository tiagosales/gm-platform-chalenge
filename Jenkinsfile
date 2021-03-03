node {
    stage('Clone repo') {
        checkout scm
    }

    stage('Build app') {
         sh './gradlew clean build'
         //archiveArtifacts artifacts: 'build/libs/*.jar'
    }

    stage('Build docker image') {
         docker.build('gmile-challenge')
    }

    withEnv(['REPO_NAME=gmile-challenge', 'REGION=us-east-1','CLUSTER=ecs-cluster1','SERVICE_NAME=gmilechallenge-service','TASKDEF=gmilechallenge-app:1','NUMTASKS=1']){
      stage('Push docker image') {
        ECR_ADDRESS = sh(script: 'bash get-ecr-repo.sh ${REPO_NAME} ${REGION}', returnStdout: true)
        withEnv(['ECR_ADDRESS=${ECR_ADDRESS}']){
          docker.withRegistry("https://$ECR_ADDRESS", '') {
            sh("aws ecr --no-verify-ssl get-login-password --region ${REGION} | docker login --username AWS --password-stdin ${ECR_ADDRESS}")
            docker.image('gmile-challenge').push("${env.BUILD_NUMBER}")
            docker.image('gmile-challenge').push("latest")
            sh("aws ecs update-service --cluster ${CLUSTER} --region ${REGION} --service ${SERVICE_NAME} --task-definition ${TASKDEF} --desired-count ${NUMTASKS}")
          }
        }
      }
    }
}
