#!/bin/sh

# $1 = Network/RunFoldername
#      nas/101122_ILLUMINA-CD89F7_00010_FC_NEW09_CSPro

echo [`date`] file check start 

echo [`date`] In $1/Data/Intensities/\*.pos.txt file check
find $1/Data/Intensities -maxdepth 1 | grep pos.txt$ | perl -MMin -nle'/(s_\d)/;$h{$1}++; $h{PosTotal}++}{ h1c(%h)'

echo [`date`] In $1/Data/Intensities/BaseCalls/\*.filter file check
find $1/Data/Intensities/BaseCalls -maxdepth 1 | grep filter$ | perl -MMin -nle'/(s_\d)/;$h{$1}++; $h{FilterTotal}++}{ h1c(%h)'

echo [`date`] In $1/Data/Intensities/BaseCalls/L00\? file check
find $1/Data/Intensities/BaseCalls/L00? -type f | perl -MMin -nle'/(L00\d)/;$h{$1}++; $h{L00XTotal}++}{ h1c(%h)'


echo [`date`] file check end 
