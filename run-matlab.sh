#!/bin/bash

./preprocess.sh $@
matlab -nosplash -nodesktop -r "run('run_matlab'); exit;"
