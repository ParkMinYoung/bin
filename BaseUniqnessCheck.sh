#!/bin/sh

perl -MMin -ne'if($.%4==2){ $h{substr $_,0,5}{"$ARGV.start"}++;chomp;$h{substr $_,-5,5}{"$ARGV.end"}++ }  }{ mmfss("BaseUniqnessCheck",%h)' $@ 
