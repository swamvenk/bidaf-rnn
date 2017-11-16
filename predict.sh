#!/usr/bin/env bash

echo "Loading a trained model and predicting answers"

python -m basic.cli --len_opt --cluster --load_step 7000

echo "Copying the predction json to workspace directory"

mv out/basic/00/answer/test-007000.json prediction.json
