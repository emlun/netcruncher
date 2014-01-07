#!/bin/bash

./preprocess.sh $@
octave crunch.m
