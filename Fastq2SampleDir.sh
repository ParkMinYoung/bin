#!/bin/sh

#ls $@ | perl -nle'/(.+)_(\w{8}|NoIndex)_L00\d_R/;mkdir $1 if ! -d $1;`mv $_ $1`'
ls *.fastq.gz | perl -nle'/(.+)_(\w{6,8}|NoIndex)_L00\d_R/;mkdir $1 if ! -d $1;`mv $_ $1`'
