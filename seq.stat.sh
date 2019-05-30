#!/bin/sh

FastqReadCount.sh $@ &
FastqSeqCount.sh $@ &
read.len.dist.sh $@ &
