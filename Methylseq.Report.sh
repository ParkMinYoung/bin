#!/bin/bash


cp -f /home/adminrig/src/short_read_assembly/bin/R/Report/MethylSeq/*.Rmd ./

read -p 'Institute : like Chung-ang University : ' Inst
read -p 'Client : like ParkMinYoung(minmin@dnalink.com) : ' Name
read -p 'Service ID : like 20181203_cau_MyeongSuncheol_1 : ' ID
read -p '#Sample : Number of Sample : ' N

Name=$(echo $Name | sed -e 's/(/\\(/' -e 's/)/\\)/')
echo $Inst $Name $ID $N

#Methylseq.Service_RMD.sh "Chung-ang University" "MyeongSuncheol\(hyunjoo1121@gmail.com\)" 20181203_cau_MyeongSuncheol_1 4
Methylseq.Service_RMD.sh "$Inst" "$Name" "$ID" "$N"

run.RMD.sh MethylSeqReport.Rmd
