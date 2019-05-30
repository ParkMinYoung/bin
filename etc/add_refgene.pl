#!/usr/bin/perl -w

#add gene reference  Information
#Delimiter : tab
#Columns : mRNA(Overlap Count), First, Center, Last, mRNA(Overlap), Strand, Chr, mRNA Start, mRNA End, mRNA length, mRNA(Closest), mRNA Distance, Transcript ID
#Author : skullcap
#Date : 2011.04.29
#Version : 1.1

use strict;
use warnings;
use Getopt::Std;
use DBI;
use DBD::mysql;

my $dsn = "dbi:mysql:ucsc_hg19:211.174.205.245:4000";
my $dbconn = DBI->connect($dsn, "bioinfo", "1111");

my $strChrNum = "";
my $strStartPos = "";
my $strEndPos = "";
my $nHeaderNum = 0;
my $nStartCol = 0;
my $strHeader = "";

my %opts=();
getopts("h:s:",\%opts);
if(defined $opts{h}){
	$nHeaderNum = $opts{h};
	$nStartCol = $opts{s};	
}else{
	print "\n\nUsage : add_cpgIslandExt -h n -s n > [output file]  \n\n";
	exit(0);
}

my $nLineCount = 0;
my $i = 0;
my @arrReadline;
my $strQuery = "";
my $strmRNAOverlapCount = 0;
my $strFirst = "";
my $strCenter = "";
my $strLast = "";
my $strmRNAOverlap = "";
my $strStrand = "";
my $strChr = "";
my $strmRNAStart = "";
my $strmRNAEnd = "";
my $strmRNALength = 0;
my $strReadline = "";
my @arrExonStarts;
my @arrExonEnds;
my $strTranscriptID = "";
my $strmRNAClosest = "";
my $strmRNADistance = "";

for($i = 0; $i < $nHeaderNum; $i++){ $strHeader = <STDIN>; }
chomp($strHeader);

if($strHeader ne ""){
	print STDOUT "$strHeader\tmRNA(Overlap Count)\tFirst\tCenter\tLast\tmRNA(Overlap)\tStrand\tChr\tmRNA Start\tmRNA End\tmRNA length\tmRNA(Closest)\tmRNA Distance\tTranscript ID\n";
}

while(<STDIN>){
	$strReadline = $_;
	chomp($strReadline);

	if(@arrReadline = split/\t/,$strReadline){

		$strChrNum = $arrReadline[$nStartCol - 1];
		$strStartPos = $arrReadline[$nStartCol];
		$strEndPos = $arrReadline[$nStartCol + 1];
	
		$strmRNAOverlapCount = 0;
		$strFirst = "";
		$strCenter = "";
		$strLast = "";
		$strmRNAOverlap = "";
		$strStrand = "";
		$strChr = "";
		$strmRNAStart = "";
		$strmRNAEnd = "";
		$strmRNALength = 0;
		$strmRNAClosest = "";
		$strmRNADistance = "";
		$strTranscriptID = "";

		$strQuery = "select chrom, name, name2, txStart, txEnd, exonStarts, exonEnds, strand from refgene where chrom = '$strChrNum' and txStart < $strEndPos and txEnd > $strStartPos";

		my $sth = $dbconn->prepare($strQuery);
		$sth->execute();

		$strmRNAOverlapCount = $sth->rows;

		while(my $row = $sth->fetchrow_hashref()){
			
			$strmRNAOverlap = $row->{'name2'};
			$strStrand = $row->{'strand'};
			@arrExonStarts = split/,/,$row->{'exonStarts'};
			@arrExonEnds = split/,/,$row->{'exonEnds'};
			$strChr = $row->{'chrom'};
			$strmRNAStart = $row->{'txStart'};
			$strmRNAEnd = $row->{'txEnd'};
			$strmRNALength = $row->{'txEnd'} - $row->{'txStart'} + 1;
			$strTranscriptID = $row->{'name'};
			$strFirst = "";
			$strCenter = "";
			$strLast = "";

			my $nExonStartPos = 0;
			my $nExonCenterPos = 0;
			my $nExonEndPos = 0;

			if($strStrand eq "+"){
				$nExonStartPos = $strStartPos;
				$nExonCenterPos = $strStartPos + int(($strEndPos - $strStartPos) / 2);
				$nExonEndPos = $strEndPos;
				if($nExonStartPos < $strmRNAStart){ $strFirst = "Intergenic"; }
				if($nExonCenterPos < $strmRNAStart){ $strCenter = "Intergenic"; }
				if($nExonCenterPos > $strmRNAEnd){ $strCenter = "Intergenic"; }
				if($nExonEndPos > $strmRNAEnd){ $strLast = "Intergenic"; }
			
				#First check
				if($strFirst eq ""){
					for(my $i = 0; $i < $#arrExonStarts; $i++){
						if(($arrExonStarts[$i] <= $nExonStartPos) && ($arrExonEnds[$i] >= $nExonStartPos)){
							if($i == 0){ $strFirst = "First Exon"; }else{ $strFirst = "Exon"; }
						}
					}
					if($strFirst eq ""){ $strFirst = "Intron"; }
				}

				#Center check
				if($strCenter eq ""){
					for(my $i = 0; $i < $#arrExonStarts; $i++){
						if(($arrExonStarts[$i] <= $nExonCenterPos) && ($arrExonEnds[$i] >= $nExonCenterPos)){
							$strCenter = "Exon";
						}
					}
					if($strCenter eq ""){ $strCenter = "Intron"; }
				}

				#Last check
				if($strLast eq ""){
					for(my $i = 0; $i < $#arrExonStarts; $i++){
						if(($arrExonStarts[$i] <= $nExonEndPos) && ($arrExonEnds[$i] >= $nExonEndPos)){
							if($i == $#arrExonStarts - 1){ $strLast = "Last Exon"; }else{ $strLast = "Exon"; }
						}
					}
					if($strLast eq ""){ $strLast = "Intron"; }
				}
			
			}else{
				$nExonEndPos = $strStartPos;
				$nExonCenterPos = $strStartPos + int(($strEndPos - $strStartPos) / 2);
				$nExonStartPos = $strEndPos;
				if($nExonEndPos < $strmRNAStart){ $strLast = "Intergenic"; }
				if($nExonCenterPos < $strmRNAStart){ $strCenter = "Intergenic"; }
				if($nExonCenterPos > $strmRNAEnd){ $strCenter = "Intergenic"; }
				if($nExonStartPos > $strmRNAEnd){ $strFirst = "Intergenic"; }
			
				#First check
				if($strFirst eq ""){
					for(my $i = $#arrExonStarts - 1; $i >= 0; $i--){
						if(($arrExonStarts[$i] <= $nExonStartPos) && ($arrExonEnds[$i] >= $nExonStartPos)){
							if($i == $#arrExonStarts - 1){ $strFirst = "First Exon"; }else{ $strFirst = "Exon"; }
						}
					}
					if($strFirst eq ""){ $strFirst = "Intron"; }
				}

				#Center check
				if($strCenter eq ""){
					for(my $i = $#arrExonStarts - 1; $i >= 0; $i--){
						if(($arrExonStarts[$i] <= $nExonCenterPos) && ($arrExonEnds[$i] >= $nExonCenterPos)){
							$strCenter = "Exon";
						}
					}
					if($strCenter eq ""){ $strCenter = "Intron"; }
				}

				#Last check
				if($strLast eq ""){
					for(my $i = $#arrExonStarts - 1; $i >= 0; $i--){
						if(($arrExonStarts[$i] <= $nExonEndPos) && ($arrExonEnds[$i] >= $nExonEndPos)){
							if($i == 0){ $strLast = "Last Exon"; }else{ $strLast = "Exon"; }
						}
					}
					if($strLast eq ""){ $strLast = "Intron"; }
				}
			
			}

			print STDOUT "$strReadline\t$strmRNAOverlapCount\t$strFirst\t$strCenter\t$strLast\t$strmRNAOverlap\t$strStrand\t$strChr\t$strmRNAStart\t$strmRNAEnd\t$strmRNALength\t$strmRNAClosest\t$strmRNADistance\t$strTranscriptID\n";
		}
		$sth->finish();
		
		if($strmRNAOverlapCount == 0){
			$strQuery = "select name, name2, length, distance, '-' as direction from ( "
				  . "select name, name2, (txEnd - txStart + 1) as length, txStart - $strStartPos + 1 as distance from refgene "
				  . "where chrom = '$strChrNum' and txStart > $strStartPos "
				  . "order by chrom, txStart asc limit 0, 1) A union "
				  . "select name, name2, length, distance, '+' as direction from ( "
				  . "select name, name2, (txEnd - txStart + 1) as length, $strEndPos - txEnd as distance from refgene "
				  . "where chrom = '$strChrNum' and txEnd < $strEndPos "
				  . "order by chrom, txEnd asc limit 0, 1) B "
				  . "order by distance asc limit 0, 1 ";
	
			my $stb = $dbconn->prepare($strQuery);
			$stb->execute();
			while(my $row = $stb->fetchrow_hashref()){
				$strmRNAClosest = "$row->{'name2'}\|$row->{'length'}";
				$strmRNADistance = "$row->{'direction'}$row->{'distance'}";
				$strTranscriptID = $row->{'name'};
			}
			$stb->finish();

			print STDOUT "$strReadline\t$strmRNAOverlapCount\t$strFirst\t$strCenter\t$strLast\t$strmRNAOverlap\t$strStrand\t$strChr\t$strmRNAStart\t$strmRNAEnd\t$strmRNALength\t$strmRNAClosest\t$strmRNADistance\t$strTranscriptID\n";

		}
	}
}
