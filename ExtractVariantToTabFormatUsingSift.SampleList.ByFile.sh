#!/bin/bash

. ~/.bash_function

if [ -f "$1" ] && [ -f "$2" ];
then 
	
	VCF=$1
	ByFile=$2
	
	while read A B C
		do ExtractVariantToTabFormatUsingSift.SampleList.sh $VCF $A $(echo $B | tr "," " ") 
		
	done < $ByFile
	
else

cat << EOF

============================================================

${BLUE}ByFile format : more than two${NORM}

No Header Line

${RED}1. Group ID${NORM}
${RED}2. Sample IDs delimited comma${NORM}
${RED}3. nSample${NORM}


SP_012  SPNT_012,SPTT_012,SPX0_012,SPX1_012,SPX2_012    5
SP_041  SPNT_041,SPTT_041,SPX0_041,SPX1_041,SPX2_041    5
SP_056  SPNT_056,SPTT_056,SPX0_056,SPX1_056,SPX2_056    5
SP_060  SPNT_060,SPTT_060,SPX0_060,SPX1_060,SPX2_060    5
SP_079  SPNT_079,SPTT_079,SPX0_079,SPX1_079,SPX2_079    5
SP_091  SPNT_091,SPTT_091,SPX0_091,SPX1_091,SPX2_091    5
SP_095  SPNT_095,SPTT_095,SPX0_095,SPX1_095,SPX2_095    5
SP_100  SPNT_100,SPTT_100,SPX0_100,SPX1_100,SPX2_100    5


============================================================
EOF


	usage "VCF ByFile"

fi


