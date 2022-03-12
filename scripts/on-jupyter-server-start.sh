#!/bin/bash
# Script to be run on starting the jupyter server

set -eux

export SAGEMAKER_USER="/home/sagemaker-user"
export NOTEBOOK_DIR="prism-samplernn-jupyter-notebook"
export NOTEBOOK_URL="https://github.com/stephenjbradshaw/prism-samplernn-jupyter-notebook.git"
export PRISM_SAMPLERNN_DIR="prism-samplernn"
export PRISM_SAMPLERNN_URL="https://github.com/rncm-prism/prism-samplernn.git"

cd /home/sagemaker-user

# Get the notebook if not exists
if [ ! -f "notebook.ipynb" ] ; then
    git clone "$NOTEBOOK_URL"
    mv $NOTEBOOK_DIR/input.wav .
    mv $NOTEBOOK_DIR/notebook.ipynb .
    mv $NOTEBOOK_DIR/parameters.md .
    rm -rf $NOTEBOOK_DIR
fi

# Clone prism-samplernn repository, or pull latest if exists
if [ ! -d "$PRISM_SAMPLERNN_DIR" ] ; then
    git clone "$PRISM_SAMPLERNN_URL"
    cd "$PRISM_SAMPLERNN_DIR"
else
    cd "$PRISM_SAMPLERNN_DIR"
    git pull
fi

# Create directory for chunking script if not exists
mkdir -p chunks