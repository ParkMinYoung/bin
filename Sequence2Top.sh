#!/bin/sh
perl -le'$target="Sequence";$ENV{PWD}=~/(SolexaData\/)(.+)\/Data/;$dir="/home/adminrig/SolexaData/Sequence.backup/$2.$target";`mv $target $dir`'
