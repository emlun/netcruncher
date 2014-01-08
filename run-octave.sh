#!/bin/bash

./preprocess.sh $@
octave run_octave.m
