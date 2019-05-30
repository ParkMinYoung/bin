#!/usr/bin/perl -w

#count gene reference information
#Delimiter : tab
#Columns : 5UTR, 3UTR, Exon, Intron, Intergnic, TSS
#Author : skullcap
#Date : 2011.04.29


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
	print "\n\nUsage : stat_chip-seq -h n -s n  \n\n";
	exit(0);
}

my $i = 0;
my @arrReadline;
my $strQuery = "";
my $n5UTRCount = 0;
my $n3UTRCount = 0;
my $nExonCount = 0;
my $nIntronCount = 0;
my $nIntergenicCount = 0;
my $nTotalCount = 0;
my $nTSSCount = 0;
my $strCenter = "";
my $strReadline = "";
my $nTxStart = 0;
my $nTxEnd = 0;
my $nCdsStart = 0;
my $nCdsEnd = 0;
my $nCheckSum = 0;
my @arrExonStarts;
my @arrExonEnds;
my $strCdsStartStat = "";
my $strCdsEndStat = "";
my $nExonCenterPos = 0;

for($i = 0; $i < $nHeaderNum; $i++){ $strHeader = <STDIN>; }
chomp($strHeader);

if($strHeader ne ""){
	print STDOUT "5UTR\t3UTR\tExon\tIntron\tIntergenic\tTotal\tTSS\n";
}

while(<STDIN>){
	$strReadline = $_;
	chomp($strReadline);

	if(@arrReadline = split/\t/,$strReadline){

		$strChrNum = $arrReadline[$nStartCol - 1];
		$strStartPos = $arrReadline[$nStartCol];
		$strEndPos = $arrReadline[$nStartCol + 1];
	
		$nCheckSum = 5;

		$strQuery = "select cdsStartStat, cdsEndStat, cdsStart, cdsEnd, chrom, name, name2, txStart, txEnd, exonStarts, exonEnds, strand from refgene where chrom = '$strChrNum' and txStart < $strEndPos and txEnd > $strStartPos";

		my $sth = $dbconn->prepare($strQuery);
		$sth->execute();

		while(my $row = $sth->fetchrow_hashref()){
			
			@arrExonStarts = split/,/,$row->{'exonStarts'};
			@arrExonEnds = split/,/,$row->{'exonEnds'};
			$nTxStart = $row->{'txStart'};
			$nTxEnd = $row->{'txEnd'};
			$nCdsStart = $row->{'cdsStart'};
			$nCdsEnd = $row->{'cdsEnd'};
			$strCdsStartStat = $row->{'cdsStartStat'};
			$strCdsEndStat = $row->{'cdsEndStat'};

			$nExonCenterPos = $strStartPos +(($strEndPos - $strStartPos) / 2);
			

			#Intergenic
			if(($nExonCenterPos < $nTxStart) || ($nExonCenterPos > $nTxEnd)){
				if($nCheckSum > 5){ $nCheckSum = 5 }	
				next;
			}
	
			#Exon & Intron
			for(my $i = 0; $i < $#arrExonStarts; $i++){

				#5UTR
				if(($nExonCenterPos < $nCdsStart) 
					&& ($nExonCenterPos > $arrExonStarts[$i]) 
					&& ($nExonCenterPos < $arrExonEnds[$i])
					&& ($strCdsStartStat eq "cmpl")){
					if($nCheckSum > 1){ $nCheckSum = 1 }
					next;
				}

				#3UTR
				if(($nExonCenterPos > $nCdsEnd) 
					&& ($nExonCenterPos > $arrExonStarts[$i]) 
					&& ($nExonCenterPos < $arrExonEnds[$i]) 
					&& ($strCdsEndStat eq "cmpl")){
					if($nCheckSum > 2){ $nCheckSum = 2 }
					next;
				}	

				if(($arrExonStarts[$i] <= $nExonCenterPos) && ($arrExonEnds[$i] >= $nExonCenterPos)){
					if($nCheckSum > 3){ $nCheckSum = 3 }
					next;
				}
			} 
			if($nCheckSum > 4){ $nCheckSum = 4 }

		}

		#print STDOUT "$strChrNum\t$nExonCenterPos\t$strStartPos\t$strEndPos\t$nTxStart\t$nTxEnd\t$nCdsStart\t$nCdsEnd\t$nCheckSum \n";
		if($nCheckSum == 1){
			$n5UTRCount++;
		}elsif($nCheckSum == 2){
			$n3UTRCount++;
		}elsif($nCheckSum == 3){
			$nExonCount++;
		}elsif($nCheckSum == 4){
			$nIntronCount++;
		}elsif($nCheckSum == 5){
			$nIntergenicCount++;
		}
		$sth->finish();
				

		$strQuery = "select bin from refgene where chrom = '$strChrNum' and (cdsStart - 500) < $strEndPos and (cdsStart + 500) > $strStartPos and cdsStartStat = 'cmpl' and cdsEndStat = 'cmpl'";
				
		my $stb = $dbconn->prepare($strQuery);
		$stb->execute();
		if($stb->rows > 0){ $nTSSCount++ };

		#if(($stb->rows == 0) && ($nCheckSum == 1)){ print "$strChrNum : $strStartPos - $strEndPos : $strChrNum : $nTxStart - $nTxEnd \n"; }

		$stb->finish();

		$nTotalCount++;
	}
}

print STDOUT "$n5UTRCount\t$n3UTRCount\t$nExonCount\t$nIntronCount\t$nIntergenicCount\t$nTotalCount\t$nTSSCount\n";
