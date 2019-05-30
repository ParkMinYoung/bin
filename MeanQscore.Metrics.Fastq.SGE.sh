#!/bin/sh

. ~/.bash_function
MeanScore=25

if [ -f "$1" ];then

perl -MIO::Zlib -snle'
@F= split "\t", $_;
map { $h{$_}++ } split ",", $F[1] if $F[0] < $MeanScore;
}{
	$fh=IO::Zlib->new($f,"r");
	while(<$fh>){
		
		chomp;
		$remainder  = $. % 4;
		if( $remainder == 0 ){
			$quotient  = int( $. / 4 );
			push @line, $_;
			
			print join "\n", @line if !$h{$quotient};
			@line = ();
		}else{
			push @line, $_;
		}
}	
' -- -MeanScore=$MeanScore -f=$2 $1 | gzip -c > $2.$MeanScore.fastq.gz

else
	echo "$0 CHET_37T5_CGATGT_L007_R1_001.fastq.gz.LinePerQScore.txt CHET_37T5_CGATGT_L007_R1_001.fastq.gz" 
	echo "Default Mean Quality Score : $MeanScore"
	usage "XXX.fastq.gz.LinePerQScore.txt XXX.fastq.gz" 
fi


