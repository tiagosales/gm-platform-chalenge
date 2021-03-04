#!/bin/bash
REPO_NAME=$1
REGION=$2
aws ecs --no-verify-ssl describe-task-definition --task-definition ${REPO_NAME} --region ${REGION}| grep revision | awk {'print $2'}
