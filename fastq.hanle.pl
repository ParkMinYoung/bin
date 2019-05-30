#!/usr/bin/perl

BEGIN{
#local $/ = "\@m";
$/ = "\@m";
}

my	$F_file_name = "try";		# input file name
#my	$F_file_name = @ARGV[0];		# input file name

open  my $F, '<', $F_file_name
or die  "$0 : failed to open  input file '$F_file_name' : $!\n";

while(my $l=<$F>){

 $l=~ 	/
 			^(.+?)(?{print "match: $1\n"})\n   	# id
 			(.+?)(?{print "match: $2\n"})\n	  	# seq
 			(\+)\n     	# delim
	 		(.+)\n$   	# qaulity
 		/xsg;

 ($id,$seq,$delim,$q)=($1,$2,$3,$4);
 $seq=~s/\n//g;
 $q=~s/\n//g;

 print "$id\n$seq\n$delim\n$q";


}
close  $F
or warn "$0 : failed to close input file '$F_file_name' : $!\n";

# oneliner
# perl -nle'BEGIN{$/="\@m"}/^(.+?)\n(.+?)\n(\+)\n(.+)\n$/xsg;($id,$seq,$delim,$q)=($1,$2,$3,$4);$seq=~s/\n//g;$q=~s/\n//g;print "@m$id\n$seq\n$delim\n$q"; ' $1
# perl -e 'BEGIN{$/="\@m"};use re "debug"; $_=~/^(.+?)\n(.+?)\n(\+)\n(.+)\n$/xsg;'
