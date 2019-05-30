

perl -F'\t' -MMin -MFile::Basename -ane'
chomp@F;
($f,$d)=fileparse($ARGV);
$f=~/(.+)_\w{6,8}_L\d+/;
$id=$d.$1;
#$id=$1;

if($ARGV =~ /deduplicated_splitting/){
	$F[0] = "$F[0] : dedup";
}


if(@F>1){

   if(/^(Total number of alignments analysed in)/){
       $F[0]=$1;
   }

   push @{ $id{$id} }, $F[0];
   $h{$id}{$F[0]} = $F[1];

}elsif( /^(Total count of deduplicated leftover sequences:)\s+(.+)/ ){

	$F[0]=$1;
	push @{ $id{$id} }, $F[0];
	$h{$id}{$F[0]} = $2;

}

}{ 

@ids = keys %id;
@col = @{ $id{$ids[0]} };
mmfss_ctitle("bismark.output", \%h, \@col)' `find  | grep report.txt$ | grep -v -e CpG |  sort -r`

MatrixTransform.NotReorder.sh bismark.output.txt 
mv -f bismark.output.txt.Transform.NotReorder bismark.output

