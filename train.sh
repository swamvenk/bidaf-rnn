#!/usr/bin/env bash

DATA_DIR=data

# Download GloVe
echo "Downloading GLoVE data"
GLOVE_DIR=$DATA_DIR/glove
mkdir $GLOVE_DIR
wget http://nlp.stanford.edu/data/glove.6B.zip -O $GLOVE_DIR/glove.6B.zip
unzip $GLOVE_DIR/glove.6B.zip -d $GLOVE_DIR

# Download NLTK (for tokenizer)
# Make sure that nltk is installed!
echo "Downloading NLTK tokenizer"
python -m nltk.downloader -d $HOME/nltk_data punkt

echo "Running data preprocessing"
python -m squad.prepro --source_dir data/squad --target_dir data/squad --glove_dir data/glove

echo "Training the model"
python -m basic.cli --mode train --noload --len_opt --cluster --num_steps 7000
