#!/bin/sh

source ~/.bash_function 



if [ -f "$1" ] ;then


perl -F'\t' -MMin -MPDL -asne'
chomp@F;
if($.==1){
	shift @F;
	for $i (@F){
		++$c;
		$i=~/(.+)Fastq\/(.+)\/(.+)_(\w{6})_(L00\d)_(R\d)_/;
		($batch,$id_dir,$id,$tag,$lane,$read)=($1,$2,$3,$4,$5,$6);

		map { $sample="$_-$read";push @{$h{$sample}}, $c } ($batch,$id_dir,$id,$tag,$lane,$read); 

	}
#	map { print "$_\t@{ [@{$h{$_}}+0] }\t@{$h{$_}}" } sort keys %h
}elsif(/^\d+/){
	$base=$F[0];
	
	for $group ( sort keys %h ){
		@index = @{$h{$group}};
		$data = pdl (@F[@index]); 
		$matrix{$base}{$group}= sprintf "%0.2f", avg($data);
	}
}

}{ mmfsn("$file-grouping",%matrix);

' -- -file="$1" "$1"

else
	usage "Per\ base\ sequence\ quality.txt"
fi

# probeset_id     /home/adminrig/workspace.min/HYUniv.56.A02/Fastq/101N/101N_ATCACG_L001_R1_001.fastq.gz.N_fastqc/fastqc_data.txt /home/adminrig/workspace.min/HYUniv.56.A02/Fastq/101N/101N_ATCACG_L001_R2_001.fastq.gz.N_fastqc/fastqc_data.txt
