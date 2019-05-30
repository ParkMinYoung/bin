perl -F'\t' -MMin -ane'chomp @F;
@data=@F[5..($#F-3)];
$sam=@data/5;
$s=5+$sam*2;
$e=$s+$sam-1;
#print "$sam\t$s\t$e";
#exit;
if($.==1){
	@id=@F;
	#print "@id";
}else{ 
	map {
			$h{Total }{$id[$_]}++; 
			$h{$F[$_]}{$id[$_]}++ 
	} ($s..$e) 
} 
}{mmfsn("depth.dist",%h)' $1
