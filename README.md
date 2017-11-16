# Bi-directional Attention Flow for Comprehension Q&A

- This the original implementation of [Bi-directional Attention Flow for Machine Comprehension][paper] (Seo et al., 2016).
- This github page is adapted from [AllenAi][https://github.com/allenai]
- This is tensorflow v1.1.0 comaptible version. This is not compatible with previous trained models.

## Requirements
#### General
- Python (developed on 3.5.2. Issues are there with Python 2!)
- unzip

#### Python Packages
- tensorflow (deep learning library, verified on 1.1.0)
- nltk (NLP tools, verified on 3.2.1)
- tqdm (progress bar, verified on 4.7.4)
- jinja2 (for visaulization; if you only train and test, not needed)

There is a file called `check_tensorflow.py` which checks if tensorflow is installed properly and if it works fine with GPU support. Please run it once to verify if the environment is set properly

## Execution

The execution steps are consolidated into two shell scripts `train.sh` and `predict.sh`. The individual steps are elaborated below.

### 1. Pre-processing
First, prepare data.
Please place the `train.json` and  `test.json` in `data/squad` directory
For GloVe and nltk (tokenizer) corpus `train.sh` will download GloVe files to `data/glove` and and nltk in `$HOME/nltk_data` before starting the training


Preprocess dataset (along with GloVe vectors) and save them in `$PWD/data/squad` (~5 minutes). `train.sh` does this using the following command:
```
python -m squad.prepro --source_dir data/squad --target_dir data/squad --glove_dir data/glove
```

### 2. Training
The model was trained with AWS p.x2large GPU computing instance.
The model requires at least 12GB of GPU RAM.
If your GPU RAM is smaller than 12GB, you can either decrease batch size by using `--batch_size` argument in the train statement below,
or you can use multi GPU.
The training converges at ~7k steps, and it took ~4s per step (i.e. ~12 hours).

Before training, it is recommended to first try the following code to verify everything is okay and memory is sufficient:
```
python -m basic.cli --mode train --noload --debug
```

Then to fully train, run:
```
python -m basic.cli --mode train --noload --len_opt --cluster --num_steps 7000
```

### 3. Test
To test, run:
```
python -m basic.cli --len_opt --cluster --load_step 7000
```

This command loads the model trained with 7000 steps begins testing on the test data.
After the process ends, it outputs a json file (`$PWD/out/basic/00/answer/test-####.json`,
where `####` is the step # that the model was saved).

## Multi-GPU Training & Testing
This model supports multi-GPU training and follows the parallelization paradigm described in [TensorFlow Tutorial][multi-gpu].
In short, if you want to use batch size of 60 (default) but if you have 3 GPUs with 4GB of RAM,
then you initialize each GPU with batch size of 20, and combine the gradients on CPU.
This can be easily done by running:
```
python -m basic.cli --mode train --noload --num_gpus 3 --batch_size 20
```

Similarly, you can speed up your testing by:
```
python -m basic.cli --num_gpus 3 --batch_size 20
```


[multi-gpu]: https://www.tensorflow.org/versions/r0.11/tutorials/deep_cnn/index.html#training-a-model-using-multiple-gpu-cards
[squad]: http://stanford-qa.com
[paper]: https://arxiv.org/abs/1611.01603
[worksheet]: https://worksheets.codalab.org/worksheets/0x37a9b8c44f6845c28866267ef941c89d/
[minjoon]: https://seominjoon.github.io
[minjoon-github]: https://github.com/seominjoon
[v0.2.1]: https://github.com/allenai/bi-att-flow/tree/v0.2.1
