# Parameters

[Return to the notebook](./notebook.ipynb)

## Training

The following table lists the hyperparameters that may be passed to the `train.py` script:

| Parameter Name               | Description                                                                                                                                                                                                  | Default Value           | Required? |
| ---------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ----------------------- | --------- |
| `id`                         | Id for the training session.                                                                                                                                                                                 | `default`               | No        |
| `data_dir`                   | Path to the directory containing the training data.                                                                                                                                                          | `None`                  | Yes       |
| `verbose`                    | Set training output verbosity. If `False` training step output is overwritten, if `True` (the default) it is written to a new line.                                                                          | `None`                  | No        |
| `logdir_root`                | Location in which to store training log files and checkpoints. All such files are placed in a subdirectory with the id of the training session.                                                              | `./logdir`              | No        |
| `output_dir`                 | Path to the directory for audio generated during training.                                                                                                                                                   | `./generated`           | No        |
| `config_file`                | File containing the configuration parameters for the training model. Note that this file must contain valid JSON, and should have a name that conforms to the `*.config.json` pattern.                       | `./default.config.json` | No        |
| `num_epochs`                 | Number of epochs to run the training.                                                                                                                                                                        | 100                     | No        |
| `batch_size`                 | Size of the mini-batch. It is recommended that the batch size divide the length of the training corpus without remainder, otherwise the dataset will be truncated to the nearest multiple of the batch size. | 64                      | No        |
| `optimizer`                  | TensorFlow optimizer to use for training. (`adam`, `sgd` or `rmsprop`)                                                                                                                                       | `adam`                  | No        |
| `learning_rate`              | Learning rate of the training optimizer.                                                                                                                                                                     | 0.001                   | No        |
| `reduce_learning_rate_after` | Exponentially reduce learning rate after this many epochs.                                                                                                                                                   | `None`                  | No        |
| `momentum`                   | Momentum of the training optimizer (applies to `sgd` and `rmsprop` only).                                                                                                                                    | 0.9                     | No        |
| `checkpoint_every`           | Interval (in epochs) at which to generate a checkpoint file. Defaults to 1, for every epoch.                                                                                                                 | 1                       | No        |
| `checkpoint_policy`          | Policy for saving checkpoints - `Always` to save at the epoch interval determined by the value of `checkpoint_every`, or `Best` to save only when the loss and accuracy have improved since the last save.   | `All`                   | No        |
| `max_checkpoints`            | Maximum number of checkpoints to keep on disk during training. Defaults to 5. Pass `None` to keep all checkpoints.                                                                                           | 5                       | No        |
| `resume`                     | Whether to resume training, either from the last available checkpoint or from one supplied using the `resume_from` parameter.                                                                                | `True`                  | No        |
| `resume_from`                | Checkpoint from which to resume training. Ignored when `resume` is `False`.                                                                                                                                  | `None`                  | No        |
| `early_stopping_patience`    | Number of epochs with no improvement after which training will be stopped.                                                                                                                                   | 3                       | No        |
| `generate`                   | Whether to generate audio output during training. Generation is aligned with checkpoints, meaning that audio is only generated after a new checkpoint has been created.                                      | `True`                  | No        |
| `max_generate_per_epoch`     | Maximum number of output files to generate at the end of each epoch.                                                                                                                                         | 1                       | No        |
| `sample_rate`                | Sample rate of the generated audio.                                                                                                                                                                          | 22050                   | No        |
| `output_file_dur`            | Duration of generated audio files (in seconds).                                                                                                                                                              | 3                       | No        |
| `temperature`                | Sampling temperature for generated audio.                                                                                                                                                                    | 0.75                    | No        |
| `seed`                       | Path to audio for seeding when generating audio.                                                                                                                                                             | `None`                  | No        |
| `seed_offset`                | Starting offset of the seed audio.                                                                                                                                                                           | 0                       | No        |
| `num_val_batches`            | Number of batches to reserve for validation.                                                                                                                                                                 | 1                       | No        |

Model parameters are specified through a JSON configuration file, which may be passed to the training script through the `--config_file` parameter (defaults to the supplied `default.config.json`). The following table lists the available model parameters (note that all parameters are optional and have defaults):

| Parameter Name   | Description                                                                                                                                                                             | Default Value |
| ---------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------- |
| `seq_len`        | RNN sequence length. Note that the value must be evenly-divisible by the top tier frame size.                                                                                           | 1024          |
| `frame_sizes`    | Frame sizes (in samples) of the two upper tiers in the architecture, in ascending order. Note that the frame size of the upper tier must be an even multiple of that of the lower tier. | [16,64]       |
| `dim`            | RNN hidden layer dimensionality                                                                                                                                                         | 1024          |
| `rnn_type`       | RNN type to use, either `gru` or `lstm`                                                                                                                                                 | `gru`         |
| `num_rnn_layers` | Depth of the RNN in each of the two upper tiers                                                                                                                                         | 4             |
| `q_type`         | Quantization type (`mu-law` or `linear`)                                                                                                                                                | `mu-law`      |
| `q_levels`       | Number of quantization channels (note that if `q_type` is `mu-law` this parameter is ignored, as mu-law quantization requires 256 channels)                                             | 256           |
| `emb_size`       | Size of the embedding layer in the bottom tier (sample-level MLP)                                                                                                                       | 256           |
| `skip_conn`      | Whether to add skip connections to the model's RNN layers                                                                                                                               | `False`       |

## Generating Audio

When we are done training we can use the `generate.py` script to generate new audio based on a saved model. The command line parameters to the script are as follows:

| Parameter Name    | Description                                                                                                                | Default Value | Required? |
| ----------------- | -------------------------------------------------------------------------------------------------------------------------- | ------------- | --------- |
| `output_path`     | Path to the generated .wav file.                                                                                           | `None`        | Yes       |
| `checkpoint_path` | Path to a saved checkpoint for the model.                                                                                  | `None`        | Yes       |
| `config_file`     | Path to the JSON config for the model.                                                                                     | `None`        | Yes       |
| `dur`             | Duration of generated audio.                                                                                               | 3             | No        |
| `num_seqs`        | Number of audio sequences to generate.                                                                                     | 1             | No        |
| `sample_rate`     | Sample rate of the generated audio.                                                                                        | 44100         | No        |
| `temperature`     | Sampling temperature for generated audio. Multiple values may be passed, to match the number of sequences to be generated. | 0.75          | No        |
| `seed`            | Path to audio for seeding when generating audio.                                                                           | `None`        | No        |
| `seed_offset`     | Starting offset of the seed audio.                                                                                         | 0             | No        |

[Return to the notebook](./notebook.ipynb)
