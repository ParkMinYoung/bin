#!/bin/bash

. ~/.bash_function

RMD=/home/adminrig/src/short_read_assembly/bin/R/Report/MethylSeq/MethylSeq_02_00.service.Rmd

if [ $# -eq 4 ]; then


	sed "s/client_company/$1/" $RMD | \
	sed "s/name_email/$2/" | \
	sed "s/service_id/$3/" | \
	sed "s/count/$4/" > MethylSeq_02_00.service.Rmd

else	

cat << EOF

============================================================

${BLUE}1. Company    : CSUIUCF${NORM}
${BLUE}2. Name(mail) : LeeWooJe(ntinamu001@gmail.com)${NORM}
${BLUE}3. Service ID : 20180424_CSUIUCF_LWJ_Methyl_1${NORM}
${BLUE}4. Sample Num : 4${NORM}

============================================================
EOF



	usage "CSUIUCF LeeWooJe\(ntinamu001@gmail.com\) 20180424_CSUIUCF_LWJ_Methyl_1 4"

fi




