#!/bin/bash
# Update domain settings, including attaching lifecycle scripts to the domain

set -eux

aws sagemaker update-domain --domain-id <sageMakerDomainId> \
--default-user-settings '{
"JupyterServerAppSettings": {
  "DefaultResourceSpec": {
    "LifecycleConfigArn": "<ARN>",
    "InstanceType": "system"
   },
   "LifecycleConfigArns": [
      "<ARN>" 
   ]
}}'