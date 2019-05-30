#!/bin/bash

. ~/.bash_function

if [ -f "$1" ] & [ -f "$2" ];then

	paste $1 $2 | \
			perl -F'\t' -MMin -anle'
			sub v_join{ return (join "," , @_) }; 
			if($.==1){
					print join "\t",  @F[0..2],qw/Match DP GQ REF ALT ALT_F GT GenoMatch GenoMatchDetail/
			}else{
					if( "$F[3]$F[13]" =~ /\.\/\./ ){
						$Match="F"
					}else{
						$Match=$F[3] eq $F[13] ? "Y" : "N"
					}

					$DP=v_join(@F[4,14]);  
					$GQ=v_join(@F[6,16]); 
					$ALT=v_join(@F[8,18]);
					$REF=v_join(@F[9,19]); 
					$ALT_F=v_join(@F[7,17]); 
					$GT=v_join(@F[3,13]); 

					$GenoMatchType = GenoMatchType($F[3], $F[13]);
					$GenoMatchType_d = GenoMatchType_detail($F[3],$F[13]);

					print join "\t", @F[0..2],$Match,$DP,$GQ,$REF,$ALT,$ALT_F, $GT, $GenoMatchType, $GenoMatchType_d
			}' >  $1---$2

else

	usage "A B [from Extract.GT.DP.AD.GQ.FromVCF.sh]"

fi


