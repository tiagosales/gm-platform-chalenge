#!/bin/bash
REPO_NAME=$1
REGION=$2
aws ecr --no-verify-ssl describe-repositories --repository-names ${REPO_NAME} --region ${REGION} | grep repositoryUri | awk -F: {'print $2'} | tr -d ",|awk {'print $1'}
