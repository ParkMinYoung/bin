perl -F'\s+' -anle'
if(@ARGV){
    @F= split "\t", $_;
	$h{$F[1]} = $F[0];
}else{

	$id=$F[0];

	if( $h{$id} ){
		$id = $h{$id};
	}
	
	@F[0,1]=($id,$id);

	$_=join " ", @F;
	print;
}
' $1 $2
#2015.pair B.set.fam.bak 
