#!/bin/sh

DATA=/home/adminrig

H1=$DATA/SolexaData
H2=$DATA/SolexaData.2
H3=$DATA/SolexaData.3

find $H1/*_SN* $H2/*_SN* $H3/*_SN* -maxdepth 0 -type d | sort | xargs -i echo "$(basename {})/Data/Intensities/BaseCalls/"
