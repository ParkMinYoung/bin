#!/bin/sh
for i in $@ ;do samtools view -H $i | tail -n 1;done
