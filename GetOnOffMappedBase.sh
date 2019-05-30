#!/bin/sh
for i in `find s_? | grep -e map$ -e ExactlyIn$`;do echo $i `GetBedLength.sh $i`;done | sed 's/ /\t/' > OnOffMappedBase.txt 
