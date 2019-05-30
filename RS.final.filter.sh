#perl -F'\t' -MList::MoreUtils=natatime,uniq,all -asnle'@data=@F[20..$#F];
perl -F'\t' -MList::MoreUtils=natatime,uniq,all -asnle'@data=@F[23..$#F];
#print "@data";exit;
$sam_cnt=@data/5;
#print @data+0;
#print $sam_cnt;
$line=$_;
$it= natatime $sam_cnt, @data;
#print "@data";
@array=();
while(@vals=$it->()){ push @array,[@vals] }
@type = uniq @{$array[1]};
@depth= @{$array[2]};
@qscore= @{$array[3]};
#print "@depth : @qscore";

#print all { $d <= $_ } @depth;
#print "@depth : $d";
#map { print "[$_]" } @depth;
#exit;

if( ( all { $d <= $_ } @depth ) && ( all { $q <= $_ } @qscore ) ){

#map { print "[$_]" } @{$array[2]};
#map { print "[$_]" } @{$array[3]};
#exit;
		$geno= @type == 1 ? "Match" : "MisMatch";
		if($F[13]=~/\d+-\d+/){
			print "$_\tCDS indel-shift\t$geno"
		}elsif($F[13]=~/(.)\d+(.)/){
			$1 ne $2 ? 
			print "$_\tCDS non-syn\t$geno" :
			print "$_\tCDS syn\t$geno"
		}
		else{
			print "$_\tNon CDS\t$geno"
		}
}else{print "$_\tFilterOut"}' -- -d=10 -q=50 $1 

