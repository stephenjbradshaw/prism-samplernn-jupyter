#!/bin/bash
# Script to be run on starting the kernel

set -eux

# Install required packages
cd prism-samplernn
pip install -r "requirements.txt"