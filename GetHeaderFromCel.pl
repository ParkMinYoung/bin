#!/usr/bin/perl

## xxd $1 | cat -n | less 
$FILE=$ARGV[0];
$FILE=~s/(\s+|\(|\))/\\\1/g;

open(FILE, $ARGV[0]);
#		"Axiom_KORV1_008211_H12_NIH15G1409015.CEL");

binmode(FILE); 

#seek FILE, 1151*16, 0;
read(FILE, $buffer, 100*16, 0);
#$buffer = s/[\000-\011\013-\037\177-\377]//g;
foreach (split(//, $buffer)) { $A.=$_; }
$A=~s/[\000-\011\013-\037\177-\377]//g;
$md5sum=`md5sum $FILE`;
$md5sum =~ s/\s+/\t/;

if($A=~/-type(.+)/){
	print join "\t", $ARGV[0], $1, $md5sum
}elsif($A=~/(GenomeWideSNP_\d+)/){
	print join "\t", $ARGV[0], $1, $md5sum
}else{
	print join "\t", $ARGV[0], 0, $md5sum
}

#print $A;
#print join "\t", $ARGV[0], "$1\n" if $A=~/barcode,(\d+)/m;

close(FILE);



## open(FILE, $ARGV[0]);
## binmode(FILE); 
## read(FILE, $buffer, 100, 0);
## close(FILE);
## foreach (split(//, $buffer)) {
## 
##     printf("%02x ", ord($_));
##     print chr(ord($_)),"\n";
## 
## 
##     print "\n" if $_ eq "\n";
## 
## }
## 
## 
## 
## 
## use strict;
## open FILE, $ARGV[0];
## print $ARGV[0];
## 
## binmode FILE;
## my ($chunk, $buf, $n);
## seek FILE, 28, 0;
## while (($n=read FILE, $chunk, 16)) { $buf .= $chunk; }
## my @s=split(/\0\0/, $buf, 4);
## print "$s[0] $s[1] $s[2]\n";
## close (FILE);



