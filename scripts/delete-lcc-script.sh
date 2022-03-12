#!/bin/bash
# Delete an unused lifecycle configuration script

set -eux

export LCC_SCRIPT_NAME="<scriptName>"

aws sagemaker --region eu-west-2 delete-studio-lifecycle-config \
  --studio-lifecycle-config-name $LCC_SCRIPT_NAME