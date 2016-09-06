#!/bin/bash
aws cloudformation create-stack \
--stack-name "AppStack" \
--template-body file:///home/user1/development/devops/aws/cloudformation/docker/docker.v3.json \
--parameters file:///home/user1/development/devops/aws/cloudformation/docker/parameter.json \
--on-failure "DO_NOTHING"
