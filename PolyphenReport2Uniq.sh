#!/bin/sh

perl -F'\t' -MList::Util=max -anle'

if( $. == 1 ){
	print join "\t", qw/Chr.bp Geno GeneSymbol Ref UCSC/, $_;
	next;
}elsif( !/^#/ ){

	$F[17] =~s/^# //;
	($chr_bp,$geno,$uc,$gene,$ref) = split /\|/, $F[17];
	$k = "$chr_bp\t$geno";

	push @{$h{$k}{$F[13]}}, join "\t", $chr_bp,$geno,$gene,$ref,$uc,$_;
}

}{

	for $i ( sort keys %h ){
		$value = max( keys %{$h{$i}} );
		print $h{$i}{$value}->[0];
	}
' $1 
##0       #o_acc                  Q8IYS5-3            
##1       o_pos   229
##2       o_aa1   Y
##3       o_aa2   S
##4       rsid            ?
##5       acc             Q8IYS5-3  
##6       pos     229
##7       aa1     Y
##8       aa2     S
##9       nt1     A
##10      nt2     C
##11      prediction      benign
##12      pph2_class      neutral
##13      pph2_prob       0.032
##14      Transv  1
##15      CodPos  1
##16      CpG     0
##17      # chr19:54598604|TG|uc002qcy.2-|OSCAR|NP_570127 # chr19:54598604|TG|uc002qcy.2-|OSCAR|NP_570127
##[2] : ################################################################################
##[2] : ################################################################################
##File : [pph2-full.txt.tab.report]
##
