#!/usr/bin/perl -w

#add CpG Island Information
#Delimiter : tab
#Columns : CpG Island(Overlap) | CpG Island(Closest) | Cpg Distance
#Author : skullcap
#Date : 2011.04.28


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
my $strCpGOverlap = "";
my $strCpGClosest = "";
my $strCpGDistance = "";
my $strReadline = "";

for($i = 0; $i < $nHeaderNum; $i++){ $strHeader = <STDIN>; }
chomp($strHeader);

if($strHeader ne ""){
	print STDOUT "$strHeader\tCpG Island(Overlap)\tCpG Island(Closest)\tCpg Distance\n";
}

while(<STDIN>){
	$strReadline = $_;
	chomp($strReadline);

	if(@arrReadline = split/\t/,$strReadline){

		$strChrNum = $arrReadline[$nStartCol - 1];
		$strStartPos = $arrReadline[$nStartCol];
		$strEndPos = $arrReadline[$nStartCol + 1];
	
		$strCpGOverlap = "";
		$strCpGClosest = "";
		$strCpGDistance = "";

		$strQuery = "select name, length from cpgislandext where chrom = '$strChrNum' and chromStart < $strEndPos and chromEnd > $strStartPos";

		my $sth = $dbconn->prepare($strQuery);
		$sth->execute();
		while(my $row = $sth->fetchrow_hashref()){
			if($strCpGOverlap ne ""){
				$strCpGOverlap .= ",";
			}
			$strCpGOverlap = "$row->{'name'} : $row->{'length'}"; 
		}
		$sth->finish();
	
		if($strCpGOverlap eq ""){
			$strQuery = "select name, length, distance, '-' as direction from ( "
				  . "select name, length, chromStart - $strStartPos + 1 as distance from cpgislandext "
				  . "where chrom = '$strChrNum' and chromStart > $strStartPos "
				  . "order by chrom, chromStart asc limit 0, 1) A union "
				  . "select name, length, distance, '+' as direction from ( "
				  . "select name, length, $strEndPos - chromEnd as distance from cpgislandext "
				  . "where chrom = '$strChrNum' and chromEnd < $strEndPos "
				  . "order by chrom, chromEnd asc limit 0, 1) B "
				  . "order by distance asc limit 0, 1 ";
	
			my $stb = $dbconn->prepare($strQuery);
			$stb->execute();
			while(my $row = $stb->fetchrow_hashref()){
				$strCpGClosest = "$row->{'name'}\|$row->{'length'}";
				$strCpGDistance = "$row->{'direction'}$row->{'distance'}";
			}
			$stb->finish();
		}

		print STDOUT "$strReadline\t$strCpGOverlap\t$strCpGClosest\t$strCpGDistance\n";
	}
}
