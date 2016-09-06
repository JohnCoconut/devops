#!/bin/bash
aws cloudformation create-stack \
--stack-name "AppStack" \
--template-body file:///home/user1/development/devops/aws/cloudformation/vpc/vpc.v7.json \
--parameters file:///home/user1/development/devops/aws/cloudformation/vpc/parameter.json 
