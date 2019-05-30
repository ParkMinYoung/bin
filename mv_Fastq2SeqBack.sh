#!/bin/sh
perl -le'$target="Fastq";$ENV{PWD}=~/(SolexaData\/)(.+)\/Data/;$dir="/home/adminrig/SolexaData/Sequence.backup/$2.$target";`mv $target $dir`'
