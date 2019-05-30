#!/bin/sh

fastqc $@ --extract -t 20 >& fastqc.log &
#fastqc *.fastq --extract -t 40 >& fastqc.log &

