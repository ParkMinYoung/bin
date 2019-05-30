perl -F'\t' -MMin -MList::Util=sum -ane'
BEGIN{ $/=">>END_MODULE";} 

if(/Basic Statistics/){
	m{
		^>>Basic\ Statistics
		\t							# example :  pass or fail
		(\w+)\n						(?{$BasicStatistics=$1;})

		^\#Measure
		\t
		\w+
		\t
		\n
	
		^Filename					# example : 11_KSJ_CAGATC_L004_R1_001.fastq.gz
		\t
		(.+)?						(?{$Filename=$2;})
		\t
		\n
	
		^File\ type
		\t
		.+
		\n

		^Encoding
		\t
		.+
		\n
		
		^Total\ Sequences			# 29817795
		\t
		(\d+)						(?{$NumOfReads=$3;})
		\t
		\n

		^Filtered\ Sequences
		\t
		.+
		\n

		^Sequence\ length
		\t
		(\d+)						(?{$LenOfRead=$4;})
		\t
		\n

		^\%GC
		\t
		(\d+)						(?{$GC=$5;})
		\t
		\n

	}xm;
	#print $&

	$Filename = $1 if /Filename\t(.+)\t/;
	$LenOfRead = $1 if /Sequence length\t(.+)\t/;
	$GC = $1 if /\%GC\t(.+)\t/;



	$Filename =~ /(.+)_(\w{6,8})_L00(\d)+_(R\d)/;
	($id,$index,$lane,$read_num) = ($1,$2,$3,$4);
	
	$ID =$id;
	$id = "$id - $read_num";	
	$h{$id}{Filename} = $Filename;
	$h{$id}{ID} = $ID;
	$h{$id}{Lane} = $lane;
	$h{$id}{ReadNum} = $read_num;
	$h{$id}{Index} = $index;
	$h{$id}{NumOfReads} = $NumOfReads;
	$h{$id}{LenOfReads} = $LenOfRead;
	$h{$id}{NumOfBases} = $NumOfReads*$LenOfRead;
	$h{$id}{GC} = $GC;
	
	## Project table
	if(! $project{$ID}{Num} ){
		$c++;
		$project{$ID}{Num} = $c;
	}
	$project{$ID}{ID} = $ID;
	$project{$ID}{Type} = "Normal";
	$project{$ID}{Gender} = "unknown";
	$project{$ID}{Library} = "Paired End 2x$LenOfRead";
	$project{$ID}{InsertSize} = "180-280";
	$project{$ID}{Exp_Method} = "Agilent SureSelect V3 50Mb";
	
	$fastqc{$id}{BasicStatistics} = $BasicStatistics;

#mmfss("out",%h);
#mmfss("out1",%fastqc);

}elsif(/Per base sequence quality/){
	m{
		^>>Per\ base\ sequence\ quality
		\t							# pass or fail
		(\w+)						(?{$PerBaseSequenceQuality=$1;})
		\n

	}xm;


#print $&;
	
	@BaseQuality = ();
	while($_ =~/^\d+\t(\d+(\.\d+)?)/gm){
		push @BaseQuality, $1;
	}
	
	$h{$id}{MeanBaseQuality} = sprintf "%.2f", (sum @BaseQuality)/@BaseQuality;
	$fastqc{$id}{PerBaseSequenceQuality} = $PerBaseSequenceQuality;

#mmfss("out",%h);
#mmfss("out1",%fastqc);

}elsif(/Per sequence quality scores/){
	m{
		^>>Per\ sequence\ quality\ scores
		\t
		(\w+)							(?{$PerSequenceQualityScores=$1})
		\n

	}xm;

#print $&;

	@Q30 = ();
	@Q20 = ();
	@num = ();
	while($_ =~/^(\d+)\t(\d+(\.\d+)?)/gm){
		push @Q30, $2 if $1 >= 30;
		push @Q20, $2 if $1 >= 20;
		push @num, $2;
	}
	
	$h{$id}{Q30} = sprintf "%.2f", (sum @Q30) / (sum @num) * 100 ;
	$h{$id}{Q20} = sprintf "%.2f", (sum @Q20) / (sum @num) * 100;
	$fastqc{$id}{PerSequenceQualityScores} = $PerSequenceQualityScores;

}elsif(/Per base sequence content\t(\w+)/){
	$fastqc{$id}{PerBaseSequenceContent} = $1;
}elsif(/Per base GC content\t(\w+)/){
	$fastqc{$id}{PerBaseGCContent} = $1;
}elsif(/Per sequence GC content\t(\w+)/){
	$fastqc{$id}{PerSequenceGCContent} = $1;
}elsif(/Per base N content\t(\w+)/){
	$fastqc{$id}{PerBaseNContent} = $1;
}elsif(/Sequence Length Distribution\t(\w+)/){
	$fastqc{$id}{SequenceLengthDistribution} = $1;
}elsif(/Sequence Duplication Levels\t(\w+)/){
	$fastqc{$id}{SequenceDuplicationLevels} = $1;
	m{
		^>>Sequence\ Duplication\ Levels
		\t
		(\w+)								(?{$SequenceDuplicationLevels=$1})
		\n

		^\#Total\ Duplicate\ Percentage
		\t
		(.+)								(?{$dup=$2;})
		\n

	}xm;
		
	$h{$id}{Duplicates} = sprintf "%.2f", $dup;

#	print $&;

}elsif(/Overrepresented sequences\t(\w+)/){
	$fastqc{$id}{OverrepresentedSequences} = $1;
}elsif(/Kmer Content\t(\w+)/){
	$fastqc{$id}{KmerContent} = $1;
}

}{

		@project =
		  qw/Num
			ID
			Type
			Gender
			Library
			InsertSize
			Exp_Method/;

		@sample = 
		   qw/ID
			Lane
			Index
			LenOfReads
 		    ReadNum
		    NumOfReads
		    NumOfBases
		    Q20
		    Q30
		    MeanBaseQuality
		    GC
		    Duplicates
		    Filename/;

		@fastqc = 
			qw/BasicStatistics
			PerBaseSequenceQuality
			PerSequenceQualityScores
			PerBaseSequenceContent
			PerBaseGCContent
			PerSequenceGCContent
			PerBaseNContent
			SequenceLengthDistribution
			SequenceDuplicationLevels
			OverrepresentedSequences
			KmerContent/;


	mmfss_ctitle("ProjectInfo",\%project, \@project);
	mmfss_ctitle("SampleInfo",\%h, \@sample);
	mmfss_ctitle("FastqcInfo",\%fastqc, \@fastqc );

' `find ./ | grep fastqc_data.txt$ | grep -v trim`

