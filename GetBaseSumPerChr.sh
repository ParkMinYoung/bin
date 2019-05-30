#!/bin/sh
perl -F'\t' -MMin -anle'$h{$F[0]}+=$F[2]-$F[1]+1;$h{Total}+=$F[2]-$F[1]+1}{h1c(%h)' $1
