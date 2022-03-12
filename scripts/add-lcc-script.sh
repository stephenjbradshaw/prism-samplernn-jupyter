#!/bin/bash
# Registers a Lifecycle Configuration Script using the AWS CLI

set -eux

export LCC_SCRIPT_NAME='on-jupyter-server-start'
export SCRIPT_FILE_NAME='on-jupyter-server-start.sh'
export SCRIPT_TYPE="JupyterServer"
# export SCRIPT_TYPE="KernelGateway"

export LCC_CONTENT=`cat ${SCRIPT_FILE_NAME} | base64`

aws sagemaker --region eu-west-2 create-studio-lifecycle-config \
  --studio-lifecycle-config-name $LCC_SCRIPT_NAME \
  --studio-lifecycle-config-content $LCC_CONTENT \
  --studio-lifecycle-config-app-type $SCRIPT_TYPE