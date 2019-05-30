#!/usr/bin/perl -w
# SeqQA.pl
# AUTHOR: Hans Vasquez-Gross
# LAST REVISED: July 2009
#
# The Bioinformatics Core at UC Davis Genome Center
# http://bioinformatics.ucdavis.edu
# Copyright (c) 2009 The Regents of University of California, Davis Campus.
# All rights reserved.

use strict;
use Data::Dumper;
use POSIX;
use Getopt::Std;

my $usage = "\nusage: $0 [-flags] <fasta file(s)> (must be all 1 type. ie all fasta NT, all fastq, all fasta fna)\n".
            "The script is able to detect if fasta or fastq files have been suplied. Depending on the flags, it produces different output.\n".
            "It will produce a histogram, a vector distribution, and a NT/AA distribution. For fastq files, you must use a flag to specify which version\n".
            "of fastq the file is formatted with.\n\n".
            "-i #          specify bin size for histogram (default 100)\n".
            "-d #          specify a size for cutting at the beginning & end of each sequence for analysis (Default 15)\n".
            "-t #          specify the number of k-mers to display in the distribution (Default 10)\n".
            "-l #          Y or N to specify Solexa/Illumina < 1.3 Fastq: Defaults N\n".
            "-s #          Y or N to specify Sanger Fastq: Defaults N\n".
            "-u #          Y or N to specify Illumina >= 1.3 Fastq: Defaults N\n".
            "-a #          Y or N to specify if the file(s) are FNA; Defaults to N\n\n";
our($opt_i, $opt_a, $opt_d, $opt_l, $opt_s, $opt_u, $opt_t); # histogram interval
getopts('i:a:d:l:s:u:t:') or die $usage;
if (!defined($opt_i) or !($opt_i =~ m/^[0-9]+$/)) {$opt_i = 100;}
if (!defined($opt_d) or !($opt_d =~ m/^[0-9]+$/)) {$opt_d = 15;}
if (!defined($opt_t) or !($opt_t =~ m/^[0-9]+$/)) {$opt_t = 10;}
if (!defined($opt_a)) {$opt_a = 'N';}
if (!defined($opt_l)) {$opt_l = 'N';}
if (!defined($opt_s)) {$opt_s = 'N';}
if (!defined($opt_u)) {$opt_u = 'N';}

if( ( $#ARGV + 1 ) < 1 ) {
	die $usage;
}
my $opt_q;

# Read in sequences from one or more fasta files
my @data_files;
for(my $i = 0; $i < ($#ARGV + 1); $i++){
	$data_files[$i] = $ARGV[$i];
}
my $Id;
my $Idq;
my $nextline;
my %seq;
my %qual;

#automatic fasta or fastq detection
foreach my $file (@data_files){
  open(FASTA, $file) or die "Can't open file $file\n";
  while (<FASTA>) {
    #if FASTA format
    if (/^>(.+)\s/)  {
      $Id = $1;
      my $nextline = <FASTA>;
      if ($nextline =~ /^(.+)$/) {
        $seq{$Id} .= $1 if $Id;
        $opt_q = 'N';
      }
      ##if Fastq format
    } elsif(/^@(.+)\s/) {
      $Id = $1;
      my $nextline = <FASTA>;
      if($nextline =~ /^(\S+)$/) {
        $seq{$Id} .= $1 if $Id;
        my $nextline = <FASTA>;
        if($nextline =~ /^\+(.*)\s/) {
          my $nextline = <FASTA>;
          if($nextline =~ /^(\S+)$/) {
            $qual{$Id} .= $1 if $Id;
            $opt_q = 'Y';
          }
        }
      }
    }
  }
  close (FASTA);
}

#executes sub processing depending on flags
if($opt_q eq 'N') {
  if($opt_a eq 'N') {
    &dna_processing;
  }

  if($opt_a eq 'Y') {
    &prot_processing;
  }
} else {
  &fastq_processing;
}


###########################################
##### Sub Processing Routines follow ######
###########################################
sub fastq_processing {
  my @phreds;
  print "Fastq Processing\n";
  foreach my $id (keys %seq) {
    my $i = 1;
    my @phred1seq;

    #for debugging: prints the id, sequence, and quality
    #print "$id\n";
    #print "$seq{$id}\n";
    #print "$qual{$id}\n";

    my @bases = split(//, $qual{$id});
    my $numelem = scalar @bases;

    #different phred score calculations depending on fastq version
    foreach my $byte (@bases) {
      if($opt_l eq 'Y') {
        my $phred = 10 * log(1 + 10 ** ((ord($byte) - 64) / 10.0)) / log(10);
        push (@phred1seq, $phred);
      }
      if($opt_s eq 'Y') {
        my $phred = ord($byte) - 33;
        push (@phred1seq, $phred);
      }
      if($opt_u eq 'Y') {
        my $phred = ord($byte) - 64;
        push (@phred1seq, $phred);
      }
    }
    push @phreds, [ @phred1seq ];
  }
  fastq_dist(\@phreds);
}

sub fastq_dist {
  my @AoA = shift;
  my @phredmeans;
  my %phredtotal;
  my $i;
  my $text;
  if($opt_l eq 'Y') {
    $text = "Solexa/Illumina < 1.3 scoring";
  } elsif ($opt_s eq 'Y') {
    $text = "Sanger scoring";
  } elsif ($opt_u eq 'Y') {
    $text = "Illumina >= 1.3 scoring";
  }
  print "Base Position\tMean Phred - $text\n";

  #loops through the Array of Arrays
  foreach my $arrayref (@AoA) {
    my $seqs = scalar @$arrayref."\n";
    my $lrgstpos = 0;
    ##get's the number of phred values per sequence
    foreach my $element ( @$arrayref ) {
      my $numpos = scalar @$element;
      if($lrgstpos < $numpos) {
        $lrgstpos = $numpos;
      }
    }

    #loops through the total number of postions and gets the mean for each
    for my $i (0 .. ($lrgstpos - 1)) {
      my $mean = fastq_phredbypos(@AoA, $i);
      my $pos = $i + 1;
      print "$pos\t\t";
      printf "%.2f\t", $mean;
      my $histogram = "|" x $mean;
      print $histogram."\n";
    }
    print "\n";
  }
  &dna_processing();
}

sub fastq_phredbypos {
  my @array = shift;
  my $pos = shift;
  my $total = 0;
  my $seqs = 0;

  #loops through the AoA depending on the passed in paramter for the base position in question and returns the mean
  #only adds if the position was defined and increments the number of sequences that have a quality at that base position
  foreach my $arrayref (@array) {
    foreach my $element ( @$arrayref) {
      if(defined(@$element[$pos])) {
        $total += @$element[$pos];
        $seqs++;
      }
    }
  }
  return ($total / $seqs);
}

sub dna_processing {
# Count the number of sequences in the file and create a histogram of the distribution
my $n = 0;
my $int;
my $totalLength = 0;
my $gcCount = 0;
my %len= ();
my %hash20s = ();
my %hash20e = ();
my @seqLengths;
my @seq20s;
my $byte;
my $totA = 0, my $totG = 0, my $totC = 0, my $totT = 0, my $totN = 0, my $totX = 0; my $totWrong = 0, my $totAGCT;
foreach my $id (keys %seq) {
  my %DNA = ();
  my %wrongchar = ();
  push @seqLengths, length($seq{$id}); # record length for N50 calc's
  $n++;
  $int = floor( length($seq{$id})/$opt_i );
  $totalLength += length($seq{$id});
  $gcCount += ($seq{$id} =~ tr/gGcC/gGcC/);
  if( !defined($len{$int}) ) {
    $len{$int} = 1;
  } else {
    $len{$int}++;
  }

  #verify characters
  my $seqi = $seq{$id};
  $seqi = uc($seqi);
  my @bases = split(//, $seqi);

  foreach $byte (@bases) {
    if($byte =~ m/(\011|\012|[\101-\132]|[\141-\172])/){
      if($byte =~ m/(A|C|G|T|N|X)/) {
        $DNA{$byte}++;
      } else {
        $wrongchar{$byte}++;
      }
    } else {
      $wrongchar{$byte}++;
    }
  } #foreach

  #for distribution - testing at cut opt_d
  my $seq20;
  if($seqi =~ m/(.{$opt_d})/) {
    $seq20 = $1;
  }
  ++$hash20s{$seq20};

  if($seqi =~ m/(.{$opt_d}$)/) {
    $seq20 = $1;
  }
  ++$hash20e{$seq20};


  if(defined($DNA{'A'})) {
    $totA += $DNA{'A'};
  }
  if(defined($DNA{'G'})) {
    $totG += $DNA{'G'};
  }
  if(defined($DNA{'C'})) {
    $totC += $DNA{'C'};
  }
  if(defined($DNA{'T'})) {
    $totT += $DNA{'T'};
  }
  if(defined($DNA{'N'})){
    $totN += $DNA{'N'};
  }
  if(defined($DNA{'X'})){
    $totX += $DNA{'X'};
  }
  if(%wrongchar) {
    $totWrong += keys %wrongchar;
  }

  if(keys %wrongchar) {
    print "Incorrect Base in $id: ", sort(keys %wrongchar), "\n";
  }
  else {
    #print "unique chars are: ", sort(keys %DNA), "\n";
  }
} #foreach

#for variable cut distribution
print "$opt_d base start uniq distribution\n";
my $countd = 0;
for (sort { $hash20s{$b} <=> $hash20s{$a} } keys %hash20s) { 
  if($countd < $opt_t) {
    print "$hash20s{$_} $_\n";
  }
  $countd++;
}
print "\n$opt_d base end uniq distribution\n";
$countd = 0;
for (sort { $hash20e{$b} <=> $hash20e{$a} } keys %hash20e) { 
  if($countd < $opt_t) {
    print "$hash20e{$_} $_\n";
  }
  $countd++;
}

# Calculate N25, N50, and N75 and counts
my $N25; my $N50; my $N75;
my $N25count=0; my $N50count=0; my $N75count=0;
my $frac_covered = $totalLength;
@seqLengths = reverse sort { $a <=> $b } @seqLengths; # sort length in descending order

$N25 = $seqLengths[0];
while ($frac_covered > $totalLength*3/4) {
  $N25 = shift(@seqLengths);
  $N25count++; $N50count++; $N75count++;
  $frac_covered -= $N25;
}
$N50 = $N25;
while ($frac_covered > $totalLength/2) {
  $N50 = shift(@seqLengths);
  $N50count++; $N75count++;
  $frac_covered -= $N50;
}
$N75 = $N50;
while ($frac_covered > $totalLength/4) {
  $N75 = shift(@seqLengths);
  $N75count++;
  $frac_covered -= $N75;
}

# Print out the results
print "\n";
my @ints = sort { $a <=> $b } keys(%len);
for(my $i=$ints[0]; $i <= $ints[-1]; $i++) { 
  $len{$i} = 0 if(!defined($len{$i}));
  printf "%d:%d \t$len{$i}\n", ( ($i*$opt_i), ($i*$opt_i+$opt_i-1) );
}
#print "\nTotal length of sequences:\t$totalLength bp\n";
print "\nTotal number of sequences:\t$n\n";
# not sure if these right wrt N25 and N75 ..
print "N25 stats:\t\t\t25% of total sequence length is contained in the ".$N25count." sequences >= ".$N25." bp\n";
print "N50 stats:\t\t\t50% of total sequence length is contained in the ".$N50count." sequences >= ".$N50." bp\n";
print "N75 stats:\t\t\t75% of total sequence length is contained in the ".$N75count." sequences >= ".$N75." bp\n";

#GCAT stats
$totAGCT = $totA + $totG + $totC + $totT;
print "\nBase\t\t\tCount\t\t%Composition\n";
print "A\t\t\t$totA\t\t";
printf "%.2f\n", ($totA/$totalLength * 100);
print "G\t\t\t$totG\t\t";
printf "%.2f\n", ($totG/$totalLength * 100);
print "C\t\t\t$totC\t\t";
printf "%.2f\n", ($totC/$totalLength * 100);
print "T\t\t\t$totT\t\t";
printf "%.2f\n\n", ($totT/$totalLength * 100);

if($totN > 0 || $totX > 0)  {
  print "Subtotal:\t\t$totAGCT\n";
  print "N\t\t\t$totN\t\t";
  printf "%.2f\n", ($totN/$totalLength * 100);
  print "X\t\t\t$totX\t\t";
  printf "%.2f\n", ($totX/$totalLength * 100);
}

if($totWrong > 0) {
  print "Wrong Characters\t".$totWrong."\n";
}

print "Total:\t\t\t$totalLength\n";

#print "Total GC:\t\t".($totG + $totC)."\n";
printf "GC %%:\t\t\t%.2f\n", (($totG + $totC)/$totalLength * 100);
printf "Purines AG%%:\t\t%.2f\n", (($totA + $totG)/$totalLength * 100);
printf "Pyrimidines CT%%:\t%.2f\n", (($totC + $totT)/$totalLength *100);
} #sub dna_processing


sub prot_processing {
# Count the number of sequences in the file and create a histogram of the distribution
my $n = 0;
my $int;
my $totalLength = 0;
my %len= ();
my @seqLengths;
my $byte;
foreach my $id (keys %seq) {
  my %DNA = ();
  my %wrongchar = ();
  push @seqLengths, length($seq{$id}); # record length for N50 calc's
  $n++;
  $int = floor( length($seq{$id})/$opt_i );
  $totalLength += length($seq{$id});
  if( !defined($len{$int}) ) {
    $len{$int} = 1;
  } else {
    $len{$int}++;
  }
  #verify characters;
  foreach $byte (split //, $seq{$id}) {
    if($byte =~ m/(A|C|D|E|F|G|H|I|K|L|M|N|P|Q|R|S|T|V|W|Y|n)/) {
      $DNA{$byte}++;
    } else {
      $wrongchar{$byte}++;
    }
  }

  if(%wrongchar) {
    print "Incorrect NT in $id: ", sort(keys %wrongchar), "\n";
  } else {
#          print "unique chars are: ", sort(keys %DNA), "\n";
  }
}

# Calculate N25, N50, and N75 and counts
my $N25; my $N50; my $N75;
my $N25count=0; my $N50count=0; my $N75count=0;
my $frac_covered = $totalLength;
@seqLengths = reverse sort { $a <=> $b } @seqLengths; # sort length in descending order

$N25 = $seqLengths[0];
while ($frac_covered > $totalLength*3/4) {
  $N25 = shift(@seqLengths);
  $N25count++; $N50count++; $N75count++;
  $frac_covered -= $N25;
}
$N50 = $N25;
while ($frac_covered > $totalLength/2) {
  $N50 = shift(@seqLengths);
  $N50count++; $N75count++;
  $frac_covered -= $N50;
}
$N75 = $N50;
while ($frac_covered > $totalLength/4) {
  $N75 = shift(@seqLengths);
  $N75count++;
  $frac_covered -= $N75;
}

# Print out the results
print "\n";
my @ints = sort { $a <=> $b } keys(%len);
for(my $i=$ints[0]; $i <= $ints[-1]; $i++) {
  $len{$i} = 0 if(!defined($len{$i}));
  printf "%d:%d \t$len{$i}\n", ( ($i*$opt_i), ($i*$opt_i+$opt_i-1) );
}
print "\nTotal length of sequence:\t$totalLength bp\n";
print "Total number of sequences:\t$n\n";
# not sure if these right wrt N25 and N75 ..
print "N25 stats:\t\t\t25% of total sequence length is contained in the ".$N25count." sequences >= ".$N25." bp\n";
print "N50 stats:\t\t\t50% of total sequence length is contained in the ".$N50count." sequences >= ".$N50." bp\n";
print "N75 stats:\t\t\t75% of total sequence length is contained in the ".$N75count." sequences >= ".$N75." bp\n";
} #sub rna_processing
