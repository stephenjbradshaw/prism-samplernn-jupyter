#!/bin/bash
# Update domain settings, including attaching lifecycle scripts to the domain

set -eux

aws sagemaker update-domain --domain-id <DomainId> \
--default-user-settings '{
"JupyterServerAppSettings": {
  "DefaultResourceSpec": {
    "LifecycleConfigArn": "<ARN>",
    "InstanceType": "system"
   },
   "LifecycleConfigArns": [
     "<ARN>"
   ]
},
"KernelGatewayAppSettings": {
   "DefaultResourceSpec": {
      "InstanceType": "ml.g4dn.xlarge",
      "LifecycleConfigArn": "<ARN>",
      "SageMakerImageArn": "<ARN>"
   },
    "LifecycleConfigArns": [
      "<ARN>"
   ]
}
}'