#!/bin/bash
# Script to be run on starting the kernel

set -eux

# Install required packages
pip install --upgrade natsort pydub librosa keras-tuner