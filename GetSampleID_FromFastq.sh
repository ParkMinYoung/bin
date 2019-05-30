#!/bin/bash

echo $(echo $1 | perl -nle'/(.+)_(\w{6,8}|NoIndex)_L00\d_R/; print $1')

