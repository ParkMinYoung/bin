#!/bin/sh

. ~/.bash_function

if [ $# -eq 1 ];then


perl -sle'
BEGIN{
@file = qw/
snp138.sql
snp138.txt.gz
snp138CodingDbSnp.sql
snp138CodingDbSnp.txt.gz
snp138Common.sql
snp138Common.txt.gz
snp138ExceptionDesc.sql
snp138ExceptionDesc.txt.gz
snp138Flagged.sql
snp138Flagged.txt.gz
snp138Mult.sql
snp138Mult.txt.gz
snp138OrthoPt4Pa2Rm3.sql
snp138OrthoPt4Pa2Rm3.txt.gz
snp138Seq.sql
snp138Seq.txt.gz/;

$url = "http://hgdownload.soe.ucsc.edu/goldenPath/hg19/database";
}
map { s/138/$version/; print "$url/$_" } @file;

' -- -version=$1 > dbSNP$1.url  
wget -i dbSNP$1.url -b


else
	usage "138"
	
fi

