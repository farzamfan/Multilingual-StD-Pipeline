# Multilingual Stance Detection

A Multilingual Stance Detection Pipeline for Political Communication Analysis

**Extended Abstract** ICA 2022.

This repository contains the models and code accompanying the paper.

ArXiv Link: `coming-soon`

PDF Link: `coming-soon`

Poster and Slides: `coming-soon`

## Overview

### Abstract

we introduce a pipeline for multilingual stance detection for the analysis of political texts analysis. 
The main objective of this work is to provide an easy-to-use tool for political communication scholars, to facilitate their substantive research. 

#### Modules
- The **Prepare Dataset** module is in charge of processing and modifying the given dataset of use to a predetermined format for the pipeline. 
- The **Dataset Loader** module is in charge of creating the train and test set, as well as implementing specific sampling techniques, and batch processing. 
  - For example, if the data set has unbalanced classes1, this module has inbuilt functions to create balanced batches. 
- The **Model Loader** module receives as an input the model-specific parameters, such as tokenizers, language model, and architecture of the additional layers (in case of fine-tuning). 
- The **Model Trainer** module takes as input the training parameters, such as the number of epochs, loss functions, and validation metrics. In turn, this module trains the model with given epoch numbers and saves the best-performing model for later validation, testing, and predictions. 
- After training the model, selecting the best hyper-parameters, and testing the predictions, the resulting model can be used to automatically identify stances in the political texts under study.



## Dependencies

| Dependency                  | Version | Installation Command                                                |
| ----------                  | ------- | ------------------------------------------------------------------- |
| Python                      | 3.8.5   | `conda create --name stance python=3.8` and `conda activate stance` |
| PyTorch, cudatoolkit        | 1.5.0   | `conda install pytorch==1.5.0 cudatoolkit=10.1 -c pytorch`          |
| Transformers  (HuggingFace) | 3.5.0   | `pip install transformers==3.5.0`     |
| Scikit-learn                | 0.23.1  | `pip install scikit-learn==0.23.1`    |
| scipy                       | 1.5.0   | `pip install scipy==1.5.0`            |
| Ekphrasis                   | 0.5.1   | `pip install ekphrasis==0.5.1`        |
| emoji                       | 0.6.0   | `pip install emoji`                   |
| wandb                       | 0.9.4   | `pip install wandb==0.9.4`            |


## Instructions


### Directory Structure

Following is the structure of the codebase, in case you wish to play around with it.

- `train.py`: Model and training loop.
- `bertloader.py`: Common Dataloader for the 6 datasets.
- `params.py`: Argparsing to enable easy experiments.
- `README.md`: This file :slightly_smiling_face:
- `.gitignore`: N/A
- `data`: Directory to store all datasets
  - `data/wtwt`: Folder for WT–WT dataset
    - `data/wtwt/README.md`: README for setting up WT–WT dataset
    - `data/wtwt/process.py`: Script to set up the WT–WT dataset
  - `data/mt`: Folder for the MT dataset
    - `data/mt/README.md`: README for setting up MT dataset
    - `data/mt/process.py`: Script to set up the MT dataset
  - `data/encryption`: Folder for the Encryption-Debate dataset
    - `data/encryption/README.md`: README for setting up Encryption-Debate dataset
    - `data/encryption/process.py`: Script to set up the Encryption-Debate dataset
  - `data/19rumoureval`: Folder for the RumourEval2019 dataset
    - `data/19rumoureval/README.md`: README for setting up RumourEval2019 dataset
    - `data/19rumoureval/process.py`: Script to set up the RumourEval2019 dataset
  - `data/17rumoureval`: Folder for the RumourEval2017 dataset
    - `data/17rumoureval/README.md`: README for setting up RumourEval2017 dataset
    - `data/17rumoureval/process.py`: Script to set up the RumourEval2017 dataset
  - `data/16semeval`: Folder for the Semeval 2016 dataset
    - `data/16semeval/README.md`: README for setting up Semeval 2016 dataset
    - `data/16semeval/process.py`: Script to set up the Semeval 2016 dataset


### 1. Setting up the codebase and the dependencies.

- Clone this repository
- Follow the instructions from the [`Dependencies`](#dependencies) Section above to install the dependencies.
- If you are interested in logging your runs, Set up your wandb - `wandb login`.

### 2. Setting up the datasets.
The dataset is already in the data folder. You can also find the pre-processing notebook in PIm Manifest folder as well.

### 3. Training the models.

After following the above steps, move to the basepath for this repository - `cd bias-stance` and recreate the experiments by executing `python3 train.py [ARGS]` where `[ARGS]` are the following:

Required Args:
- dataset_name: The name of dataset to run the experiment on. Possible values are ["16se", "wtwt", "enc", "17re", "19re", "mt1", "mt2"]; Example Usage: `--dataset_name=wtwt`; Type: `str`; This is a required argument.
- target_merger: When dataset is wtwt, this argument is required to tell the target merger. Example Usage: `--target_merger=CVS_AET`; Type: `str`; Valid Arguments: ['CVS_AET', 'ANTM_CI', 'AET_HUM', 'CI_ESRX', 'DIS_FOX'] or not including the argument.
- test_mode: Indicates whether to evaluate on the test in the run; Example Usage: `--test_mode=False`; Type: `str`
- bert_type: A required argument to specify the bert weights to be loaded. Refer [HuggingFace](https://huggingface.co/models). Example Usage: `--bert_type=bert-base-cased`; Type: `str`

Optional Args:
- seed: The seed for the current run. Example Usage: `--seed=1`; Type: `int`
- cross_validation_num: A helper input for cross validation in wtwt and enc datasets. Example Usage: `--cross_valid_num=1`; Type: `int`
- batch_size: The batch size. Example Usage: `--batch_size=16`; Type: `int`
- lr: Learning Rate. Example Usage: `--lr=1e-5`; Type: `float`
- n_epochs: Number of epochs. Example Usage: `--n_epochs=5`; Type: `int`
- dummy_run: Include `--dummy_run` flag to perform a dummy run with a single trainign and validation batch.
- device: CPU or CUDA. Example Usage: `--device=cpu`; Type: `str`
- wandb: Include `--wandb` flag if you want your runs to be logged to wandb.
- notarget: Include `--notarget` flag if you want the model to be target oblivious.

### 4. Miscellaneous 
- The codebase has been written from scratch, but was inspired from many others: [1](https://github.com/jackroos/VL-BERT) [2](https://propaganda.qcri.org/fine-grained-propaganda-emnlp.html) [3](https://github.com/prajwal1210/Stance-Detection-in-Web-and-Social-Media)

- License: MIT


