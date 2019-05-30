# execute time : 2018-11-16 15:24:29 : show target size
grep size $(find /home/adminrig/Genome/TwistExome /home/adminrig/Genome/SureSelect/WES.Target/S* -type f | grep -v SSV |  grep size$ )


# execute time : 2018-11-16 15:24:41 : show target bed file list
find /home/adminrig/Genome/TwistExome /home/adminrig/Genome/SureSelect/WES.Target/S* -type f | grep -v SSV | grep NUM.bed$


