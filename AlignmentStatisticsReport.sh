#echo $@

perl -F'\t' -MMin -ane'
chomp;
$Mark = "Mark";

if($ARGV=~/.Dedupping(.Mark)?.bam.flagstats$/){
	
	$Mark = $1 ? "Mark" : "RMDup";
	
	if($_ =~ /^(\d+) \+ (\d+) in total/){
		
		# Num of Total Reads
		$h{QC_Pass_Reads}{$Mark} = $1;
		# Num of Filtered Reads
		$h{FilteredReads}{$Mark} = $1 - $2;
		# Pct of Filterd Reads 
		$h{FilteredReadsPct}{$Mark} = sprintf "%0.0f", ($1-$2)/$1*100;
		# Num of QC Fail Reads
		$h{QC_Fail_Reads}{$Mark} = $2;

	}elsif(/(\d+) \+ (\d+) duplicates/){

		# Num of Duplicates Reads
		$h{Duplicates}{$Mark} = $1;
		# Pct of Duplicates Reads
		$h{DuplicatesPct}{$Mark} =  sprintf "%0.2f", $1/$h{QC_Pass_Reads}{$Mark}*100;

	}elsif(/(\d+) \+ \d+ mapped \((\d+.\d+)\%/){

		# Num of Mapped Reads
		$h{MappedReads}{$Mark} = $1;
		# Pct of Mapped Reads
		$h{MappedReadsPct}{$Mark} = $2;

	}elsif(/(\d+) \+ \d+ paired in sequencing/){

		# Num of Mapped Reads in pairs
		$h{MappedReadsInPairs}{$Mark} = $1;
		# Pct of Mapped Reads in pairs
		$h{MappedReadsInPairsPct}{$Mark} = sprintf "%0.2f", $1/$h{QC_Pass_Reads}{$Mark}*100;

	}elsif(/(\d+) \+ \d+ properly paired \((\d+.\d+)\%/){

		# Num of Mapped Reads in proper pairs
		$h{MappedReadsInProperPairs}{$Mark} = $1;
		# Pct of Mapped Reads in proper pairs
		$h{MappedReadsInProperPairsPct}{$Mark} = $2;

	}elsif(/(\d+) \+ \d+ singletons \((\d+.\d+)\%/){
		# Num of Singleton Reads
		$h{SigletonReads}{$Mark} = $1;
		# Pct of Singleton Reads
		$h{SigletonReadsPct}{$Mark} = $2;
	}
}elsif($ARGV =~ /Mark.MarkDuplicatesMetrics$/){
	if(/^LIBRARY/){
		$flag++;
	}elsif($flag){

		# Num of Un Paired Duplicates Reads
		$h{"Duplicates.UnPaired_Dup"}{$Mark}= $F[4];
		# Num of Paired Duplicates Reads
		$h{"Duplicates.Paired_Dup"}{$Mark}= $F[5]*2; 
		# Num of UnPaired Read + 2*(Paired Duplicates Reads)
		$h{"Duplicates.Total_Dup"}{$Mark} = $F[4] + $F[5]*2;
		$flag=0;
	}
}elsif($ARGV =~ /DepthOfCoverage.report.sample_cumulative_coverage_counts$/){
	if(/^sample/){
		map { $F[$_]=~/_(\d+)/;$idx2dp{$_} = $1} 1..$#F;
	}else{
		# Num of Target Region bases
		$h{TargetBases}{$Mark}= $F[1];
		# Pct of UnCovered Region bases
		$h{UnCoverPct}{$Mark}= sprintf "%0.2f", ($F[1]-$F[2])/$F[1]*100;

		for ( 1 .. $#F ){
			$dp = $idx2dp{$_};
			$dp2cov{$dp} = sprintf "%0.2f", $F[$_]/$F[1]*100;
			$dp2base{$dp} = $F[$_];
		}
	}

	map { 
			$h{"X".$_}{$Mark} = $dp2cov{$_};
			$h{"XBases".$_}{$Mark} = $dp2base{$_};
	} qw/1 5 10 15 20 30 50 100/; 

}elsif($ARGV =~ /.Dedupping.bam.DepthOfCoverage.report.sample_summary$/ && /^Total/){
	
	# Num of Unique Aligned Reads"s bases
	$h{AlignedBases}{$Mark} = $F[1];
	# Mean Depth of Unique Aligned Reads
	$h{MeanAlignedBases}{$Mark} = $F[2];

}

}{ 
#	mmfss("flag",%h);
#Total bases   3101804739
#Regular bases 2864785220
# /home/adminrig/src/GATK/GATK.data/b37/Sequence/human_g1k_v37.stats

$b37_1k = 3101804739;
$b37_1k_regular = 2864785220;

print <<REPORT;
Reference Genome Size	$b37_1k

NumOfTotalReads	$h{QC_Pass_Reads}{Mark}
NumOfFilterdReads	$h{FilteredReads}{Mark}
PctOfFiltedReads	$h{FilteredReadsPct}{Mark}%

NumOfAlignedReads	$h{MappedReads}{Mark}
PctOfAlignedReads	$h{MappedReadsPct}{Mark}%
NumOfAlignedReadsInPairs	$h{MappedReadsInPairs}{Mark}
PctOfAlignedReadsInPairs	$h{MappedReadsInPairsPct}{Mark}%
NumOfAlignedReadsInProperPairs	$h{MappedReadsInProperPairs}{Mark}
PctOfAlignedReadsInProperPairs	$h{MappedReadsInProperPairsPct}{Mark}%
NumOfSingletonReads	$h{SigletonReads}{Mark}

NumOfDuplicatesReads	$h{Duplicates}{Mark}
NumOfPairDuplicatesReads	$h{"Duplicates.Paired_Dup"}{Mark}
NumOfUnPairedDuplicatesReads	$h{"Duplicates.UnPaired_Dup"}{Mark}
PctOfDuplicatesReads	$h{DuplicatesPct}{Mark}%

NumOfUniqueReads	$h{QC_Pass_Reads}{RMDup}
PctOfUniqueReads	@{[ (100-$h{DuplicatesPct}{Mark}) ]}%

NumOfUniqueAlignedReads	$h{MappedReads}{RMDup}
PctOfUniqueAlignedReads	$h{MappedReadsPct}{RMDup}%
NumOfUniqueAlignedBases	$h{AlignedBases}{Mark}
NumOfUniqueAlignedReadsInPairs	$h{MappedReadsInPairs}{RMDup}
PctOfUniqueAlignedReadsInPairs	$h{MappedReadsInPairsPct}{RMDup}%
NumOfUniqueAlignedReadsInProperPairs	$h{MappedReadsInProperPairs}{RMDup}
PctOfUniqueAlignedReadsInProperPairs	$h{MappedReadsInProperPairsPct}{RMDup}%
NumOfUniqueSingletonReads	$h{SigletonReads}{RMDup}

TargetRegion	$h{TargetBases}{Mark}
MeanDepthCoverage	$h{MeanAlignedBases}{Mark}
UnCoveredTargetRegion	$h{UnCoverPct}{Mark}%
PctOfTargetCoverage >= 1X	$h{X1}{Mark}%
PctOfTargetCoverage >= 5X	$h{X5}{Mark}%
PctOfTargetCoverage >= 10X	$h{X10}{Mark}%
PctOfTargetCoverage >= 15X	$h{X15}{Mark}%
PctOfTargetCoverage >= 20X	$h{X20}{Mark}%
PctOfTargetCoverage >= 30X	$h{X30}{Mark}%
REPORT

' $@ > $5.StatisticsReport 

# sh GetSeqReport.sh *flagstats *.bam.Mark.MarkDuplicatesMetrics *.sample_cumulative_coverage_counts *.sample_summary

#  Dedupping.bam.DepthOfCoverage.report.sample_summary file format

# sample_id       total   mean    granular_third_quartile granular_median granular_first_quartile %_bases_above_5 %_bases_above_10        %_bases_above_15        %_bases_above_20        %_bases_above_25        %_bases_above_30       
# DNALink.PE.SNP14-19     934528822       659.17  500     500     361     99.9    99.7    99.5    99.2    99.0    98.7    98.5    98.2    97.9    97.7    97.4    97.1    96.7    96.4    96.1    95.8    95.5    95.2    94.9    94.6
# Total   934528822       659.17  N/A     N/A     N/A



# DepthOfCoverage.report.sample_cumulative_coverage_counts file format

# sample gte_0 gte_1 gte_2 gte_3
# NSamples_1 1417729 1417252 1416906 1416392


## Mark.MarkDuplicatesMetrics file format
## LIBRARY UNPAIRED_READS_EXAMINED READ_PAIRS_EXAMINED     UNMAPPED_READS  UNPAIRED_READ_DUPLICATES        READ_PAIR_DUPLICATES    READ_PAIR_OPTICAL_DUPLICATES    PERCENT_DUPLICATION     ESTIMATED_LIBRARY_SIZE
##DNALink.PE      507597  19445834        76885   478534  12527864        0       0.64809 7471399



## flagstats file format	

##39476151 + 0 in total (QC-passed reads + QC-failed reads)
##25534262 + 0 duplicates
##39399266 + 0 mapped (99.81%:nan%)
##38978592 + 0 paired in sequencing
##19489296 + 0 read1
##19489296 + 0 read2
##38739180 + 0 properly paired (99.39%:nan%)
##38891669 + 0 with itself and mate mapped
##14458 + 0 singletons (0.04%:nan%)
##91488 + 0 with mate mapped to a different chr
##77118 + 0 with mate mapped to a different chr (mapQ>=5)

##13941889 + 0 in total (QC-passed reads + QC-failed reads)
##0 + 0 duplicates
##13865004 + 0 mapped (99.45%:nan%)
##13912829 + 0 paired in sequencing
##6955620 + 0 read1
##6957209 + 0 read2
##13746315 + 0 properly paired (98.80%:nan%)
##13835941 + 0 with itself and mate mapped
##4423 + 0 singletons (0.03%:nan%)
##51446 + 0 with mate mapped to a different chr
##38891 + 0 with mate mapped to a different chr (mapQ>=5)
##
