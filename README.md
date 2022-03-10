## PRiSM SampleRNN (Jupyter Notebook)

This is a version of RNCM PRiSM's [PRiSM SampleRNN Google Colab notebook](https://colab.research.google.com/gist/relativeflux/10573e9e1b10b1ff45e3a00099259741/prism-samplernn.ipynb#scrollTo=II4WuZilwzWB), adapted for use on GPU-enabled instances in [Amazon SageMaker Studio](https://aws.amazon.com/sagemaker/studio/).

[PRiSM SampleRNN](https://www.rncm.ac.uk/research/research-centres-rncm/prism/prism-collaborations/prism-samplernn/) is an AI-assisted composition tool that "learns" from audio input to generate new audio output. It is open-source software authored by Dr Christopher Melen, [RNCM PRiSM](https://www.rncm.ac.uk/research/research-centres-rncm/prism/).

This repository is automatically cloned into new instances of the SageMaker Studio app (along with [prism-samplernn](https://github.com/rncm-prism/prism-samplernn) itself) using SageMaker Studio's [lifecycle configuration scripts](https://aws.amazon.com/blogs/machine-learning/customize-amazon-sagemaker-studio-using-lifecycle-configurations/). These scripts also install the necessary packages.
