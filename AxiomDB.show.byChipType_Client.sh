#!/bin/bash


#AxiomDB.show.byCEL.sh Axiom | cut -f1 | perl -MMin -nle' if( /Axiom_(.+)_(\d{3})\d{3}_\w{3}_/ ){ $h{$1}{$2}++ } }{ show_hash2(%h)' | sed '1 i\Type\tClient\tCount'
#AxiomDB.show.byCEL.sh Axiom | cut -f1 | perl -MMin -ne' if( /Axiom_(.+)_(\d{3})\d{3}_\w{3}_/ ){ $h{$2}{$1}++; $h{Total}{$1}++ } }{ show_matrix(%h)'

. ~/.bash_function

if [ $1 ];then
	AxiomDB.show.byCEL.sh Axiom | cut -f1 | perl -MMin -nle' if( /Axiom_(.+)_(\d{3})\d{3}_\w{3}_/ ){ $h{$1}{$2}++ } }{ show_hash2(%h)' |  ColCol2Matrix.sh 2 1 3 | TAB2FixedLen.sh

else
	AxiomDB.show.byCEL.sh Axiom | cut -f1 | perl -MMin -nle' if( /Axiom_(.+)_(\d{3})\d{3}_\w{3}_/ ){ $h{$1}{$2}++ } }{ show_hash2(%h)' |  ColCol2Matrix.sh 2 1 3 
fi

