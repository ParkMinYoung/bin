#!/bin/sh

for i in `find -maxdepth 1 -type d | grep s_ | sort`;do echo `date` $i && MakeRawDataStatus.sh $i;done

