#!/bin/sh

. ~/.GATKrc
. ~/.bash_function

if [ -f "$1" ];then
	
		cp $1 $1.bak

		perl -F'\t' -anle'

		$ref_len = length($F[3]);
		$alt_len = length($F[4]);

		#deletion
		if($ref_len > 1 || $F[4] eq "-" ){
			$s = $F[1] - $ref_len - 1; 
			$type="deletion";
		#insertion
		}elsif($ alt_len > 1 || $F[3] eq "-" ) {
			$s = $F[1] - 1; 
			$type="insertion";
		#snp
		}else{
			$s = $F[1] - 1; 
			$type="snp";
		}
		
		$F[0] = "chr$F[0]" if $F[0] !~ /^chr/;

		print join "\t", $F[0], $s, $F[1], (join ";", $type,@F);


		' $1 > $1.bed


		fastaFromBed -fi $IonHG19 -bed $1.bed -fo $1.bed.fasta -tab

		
         perl -F'\t' -anle'
         if(@ARGV){
             $k="$F[0]:$F[1]-$F[2]";
             push @{$h{$k}}, $F[3];
         }else{
				$uniq_line{$_}++;
				next if $uniq_line{$_} >1;
				for $i ( @{ $h{$F[0]} } ){
						 @snp = split ";", $i;
						 if($snp[0] eq "deletion"){
							 $snp[4] = $F[1];
							 $snp[5] = substr $F[1], 0, 1;
	
							 $F[0]=~/:(\d+)-/;
							 $snp[2] = $1+1;
							 print join "\t", @snp[1..$#snp];

						 }elsif($snp[0] eq "insertion"){
							 $snp[4] = $F[1];
							 $snp[5] = "$F[1]$snp[5]";
							 print join "\t", @snp[1..$#snp];
						 }else{
							 print join "\t", @snp[1..$#snp];
						 }
				 }
		}' $1.bed $1.bed.fasta > $1


else 
	echo "2	234668880	rs3064744	-	AT"
	echo "1	100316616	rs113994127	AG	-"

	usage "tabfile"
fi


