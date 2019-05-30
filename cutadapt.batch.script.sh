#!/bin/sh
# for i in `find s_? | grep gz$ | sort`;do echo "cutadapt.sh $i &";done > cutadapt.script.sh
 for i in `find s_? | grep gz$ | sort`;do echo "cutadapt.sh $i &";done | sh  

