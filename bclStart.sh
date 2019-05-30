#!/bin/sh
setupBclToQseq.py -i $PWD -p $PWD/../ -o $PWD --in-place --overwrite $@ 
#setupBclToQseq.py -i $PWD -p $PWD/../ -o $PWD --in-place --overwrite --GERALD=/home/adminrig/SolexaData/101108_ILLUMINA-CD89F7_00008_FC_NEW07/Data/Intensities/BaseCalls/config.phix.R2.C156.PE.txt
make recursive -j 8 
