#!/usr/bin/perl

use Getopt::Long;
GetOptions ("input=s" => \$input,
				"output=s" => \$output,
				"fraction=i" => \$fraction,
				"length=i" => \$length,
				"numreads=i" => \$numreads);

$usage = "Usage: $0\n--input <fastq in> (required)\n--output <fastq out> (required)\n--fraction <num> where 1/num is the fraction of records you want\n--length <length>, number of fastq records in input, typically line count divided by 4 (required)\n--numreads <number of reads>, number of records you want to end up with\nOnly choose one of --fraction and --numreads\n\n";

if (!defined $input || !defined $output || !defined $length || (!defined $fraction && !defined $numreads)) {
	print $usage;
	exit();
}

if (defined $numreads && defined $fraction) {
	print $usage;
	exit();
}

if (defined $fraction && $fraction > $length) {
	print STDERR "Fraction ($fraction) cannot be greater than length ($length)\n";
	exit();
}

if (defined $numreads && $numreads > $length) {
    print STDERR "Numreads ($numreads) cannot be greater than length ($length)\n";
    exit();
}

if (defined $numreads) {
	$fraction = $length / $numreads;
}

open (INFILE, "<$input");
open (OUTFILE, ">$output");

$count=0;
$numrec=0;
while ($line1=<INFILE>) {
	$line2=<INFILE>;
	$line3=<INFILE>;
	$line4=<INFILE>;

	if ($count % $fraction == 0) {
		print OUTFILE "$line1$line2$line3$line4";
		#print STDERR "Count: $count                 \r";
		$numrec++;
	}

	$count++;
	if (defined $numreads && $numrec == $numreads) {last;}
}

print STDERR "\n";

close (INFILE);
close (OUTFILE);

