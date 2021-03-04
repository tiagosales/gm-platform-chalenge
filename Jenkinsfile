node {
    withEnv(['APP_NAME=gmile-app','REGION=us-east-1','CLUSTER=gmile-ecs-cluster','SERVICE_NAME=gmile-service','NUM_TASKS=1']){
        stage('Clone repo') {
            checkout scm
        }

        stage('Build app') {
            sh './gradlew clean build'
            //archiveArtifacts artifacts: 'build/libs/*.jar'
        }

        stage('Build docker image') {
            docker.build("$APP_NAME")
        }

        stage('Push docker image') {
            ECR_ADDRESS = sh(script: 'bash get-ecr-repo.sh ${APP_NAME} ${REGION}', returnStdout: true)
            TASKDEF_REV = sh(script: 'bash get-ecs-taskrev.sh ${APP_NAME} ${REGION}', returnStdout: true)
            withEnv(['ECR_ADDRESS=${ECR_ADDRESS}','TASKDEF_REV=${TASKDEF_REV}']){
              docker.withRegistry("https://$ECR_ADDRESS", '') {
                sh("aws ecr --no-verify-ssl get-login-password --region ${REGION} | docker login --username AWS --password-stdin ${ECR_ADDRESS}")
                docker.image("$APP_NAME").push("${env.BUILD_NUMBER}")
                docker.image("$APP_NAME").push("latest")
              }
            }
        }
        stage('Deploy on ECS'){
          sh("aws ecs --no-verify-ssl update-service --cluster ${CLUSTER} --region ${REGION} --service ${SERVICE_NAME} --task-definition ${APP_NAME}:${TASKDEF_REV} --desired-count ${NUM_TASKS} --force-new-deployment")
        }
    }
}
