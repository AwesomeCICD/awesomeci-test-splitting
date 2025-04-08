#!/bin/bash
aws ecr get-login-password --region $AWS_DEFAULT_REGION | docker login --username AWS --password-stdin $ECR_IMAGE_REPO
docker tag $FE_CUSTOM_DOCKER:$TAG $ECR_IMAGE_REPO/$FE_CUSTOM_DOCKER:$TAG
echo -e "\033[0;32mReady to push image to ECR....\033[0m"
docker push $ECR_IMAGE_REPO/$FE_CUSTOM_DOCKER:$TAG