#!/usr/bin/perl

## xxd $1 | cat -n | less 
$FILE=$ARGV[0];
$FILE=~s/(\s+|\(|\))/\\\1/g;

open(FILE, $ARGV[0]);
#		"Axiom_KORV1_008211_H12_NIH15G1409015.CEL");

binmode(FILE); 

#seek FILE, 1151*16, 0;
read(FILE, $buffer, 1451*16, 0);
#$buffer = s/[\000-\011\013-\037\177-\377]//g;
foreach (split(//, $buffer)) { $A.=$_; }
$A=~s/[\000-\011\013-\037\177-\377]//g;
$md5sum=`md5sum $FILE`;
$access_time=`/home/adminrig/src/short_read_assembly/bin/GetLastAccess.sh $FILE | cut -f2`;
chomp($access_time);
$md5sum =~ s/\s+/\t/;



if($A=~/PlateScanGUIDF(\d{4})_(\d{2})_(\d{2})_(\d{2})_(\d{2})_(\d{2})_/){
	#PlateScanGUIDF2016_07_14_21_55_42_550769_E0101360
	#2016-09-18 04:11:57
	$created_date="$1-$2-$3 $4:$5:$6";
}

if($A=~/affymetrix-image-grid-status(.+)/){
	$grid_status=$1;
}

if($A=~/affymetrix-scanner-serialnumber(.+)/){
	$serial_num=$1;
}

if($A=~/affymetrix-plate-barcode,(.+)/){
	$barcode=$1;
}

if($A=~/affymetrix-plate-peg-wellposition(.+)/){
	$well=$1;
}

if($A=~/affymetrix-scanner-id PlateScanner (.+)/){
	$scanner=$1;
}

if($A=~/affymetrix-Hyb-Start-Time.(\d+)\/(\d+)\/(\d+) (\d+):(\d+):(\d+) (\w+)/){
	$hyb_start_time = get_time($_);	
}

if($A=~/affymetrix-Hyb-Stop-Time.(\d+)\/(\d+)\/(\d+) (\d+):(\d+):(\d+) (\w+)/){
	$hyb_stop_time = get_time($_);	
}

if($A=~/affymetrix-Fluidics-Date.(\d+)\/(\d+)\/(\d+) (\d+):(\d+):(\d+) (\w+)/){
	$hyb_fluidics_time = get_time($_);	
}


print join "\t", $ARGV[0], $created_date, $grid_status, $serial_num, $barcode, $well, $scanner, $hyb_start_time, $hyb_stop_time, $hyb_fluidics_time, $access_time, $md5sum;

#print $A;
#print join "\t", $ARGV[0], "$1\n" if $A=~/barcode,(\d+)/m;

close(FILE);

sub get_time(){
	
	/affymetrix-Hyb-Start-Time\( (\d+)\/(\d+)\/(\d+) (\d+):(\d+):(\d+) (\w+)/;
	# 7/13/2016 5:24:16 PM
	$date = "$3-$1-$2";
	($h,$m,$s,$pm) = ($4,$5,$6,$7);
	$h = $pm =~/PM/ ? $h+12 : $h;
	$time = "$h:$m:$s";

	return("$date $time");
}


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



