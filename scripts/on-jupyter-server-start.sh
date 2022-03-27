#!/bin/bash
# Script to be run on starting the jupyter server

set -eux

export NOTEBOOK_DIR="prism-samplernn-jupyter-notebook"
export NOTEBOOK_URL="https://github.com/stephenjbradshaw/prism-samplernn-jupyter-notebook.git"
export PRISM_SAMPLERNN_DIR="prism-samplernn"
export PRISM_SAMPLERNN_URL="https://github.com/rncm-prism/prism-samplernn.git"
# Idle time before sever shuts down automatically
export TIMEOUT_IN_MINS=30

# ----- SET UP WORKING ENVIRONMENT -----

cd /home/sagemaker-user

# Get the notebook if not exists
if [ ! -f "notebook.ipynb" ] ; then
    git clone "$NOTEBOOK_URL"
    mv "$NOTEBOOK_DIR/input.wav" .
    mv "$NOTEBOOK_DIR/notebook.ipynb" .
    mv "$NOTEBOOK_DIR/parameters.md" .
    rm -rf "$NOTEBOOK_DIR"
fi

# Clone prism-samplernn repository, or pull latest if exists
git -C "$PRISM_SAMPLERNN_DIR" pull || git clone "$PRISM_SAMPLERNN_URL"

# ----- INSTALL AUTOSHUTDOWN SERVER EXTENSION -----

# By working in a directory starting with ".", we won't clutter up users' Jupyter file tree views
mkdir -p .auto-shutdown

# Create the command-line script for setting the idle timeout
cat > .auto-shutdown/set-time-interval.sh << EOF
#!/opt/conda/bin/python
import json
import requests
TIMEOUT=${TIMEOUT_IN_MINS}
session = requests.Session()
# Getting the xsrf token first from Jupyter Server
response = session.get("http://localhost:8888/jupyter/default/tree")
# calls the idle_checker extension's interface to set the timeout value
response = session.post("http://localhost:8888/jupyter/default/sagemaker-studio-autoshutdown/idle_checker",
            json={"idle_time": TIMEOUT, "keep_terminals": False},
            params={"_xsrf": response.headers['Set-Cookie'].split(";")[0].split("=")[1]})
if response.status_code == 200:
    print("Succeeded, idle timeout set to {} minutes".format(TIMEOUT))
else:
    print("Error!")
    print(response.status_code)
EOF
chmod +x .auto-shutdown/set-time-interval.sh

# "wget" is not part of the base Jupyter Server image, you need to install it first if needed to download the tarball
sudo yum install -y wget
# You can download the tarball from GitHub or alternatively, if you're using VPCOnly mode, you can host on S3
wget -O .auto-shutdown/extension.tar.gz https://github.com/aws-samples/sagemaker-studio-auto-shutdown-extension/raw/main/sagemaker_studio_autoshutdown-0.1.5.tar.gz

# Installs the extension
cd .auto-shutdown
tar xzf extension.tar.gz
cd sagemaker_studio_autoshutdown-0.1.5
pip install --no-dependencies --no-build-isolation -e .
jupyter serverextension enable --py sagemaker_studio_autoshutdown

# Restarts the jupyter server
nohup supervisorctl -c /etc/supervisor/conf.d/supervisord.conf restart jupyterlabserver

# Waiting for 30 seconds to make sure the Jupyter Server is up and running
sleep 30

# Calling the script to set the idle-timeout and active the extension
/home/sagemaker-user/.auto-shutdown/set-time-interval.sh