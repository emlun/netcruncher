#!/bin/bash

./preprocess.sh $@
matlab -nosplash -nodesktop -r "run('crunch'); exit;"
