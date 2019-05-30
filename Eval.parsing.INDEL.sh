perl -F'\s+' -MMin -ane'

$type  = $F[4];
if(/^CountVariants\s+dbsnp/){
	$count = $F[6];
	$nIn =   $F[13];
	$nDe =   $F[14];
	$nHet  = $F[19];
	$nHomo = $F[21];
	$hetHomRatio = $F[26];
	$indelRatio = $F[29];
	
	if( $type eq "all" ){
		$total = $count;
	}

#$h{$type}{count} = $count;

	$sum = $nHet + $nHomo;

	$Sumper = sprintf "%0.2f", $sum/$total*100;
	$Hetper = sprintf "%0.2f", $nHet/$total*100;
	$Homoper = sprintf "%0.2f", $nHomo/$total*100;
	
	$h{$type}{nHet} = "$nHet ($Hetper %)";

	$h{$type}{nHomo} = "$nHomo ($Homoper %)";
	$h{$type}{nTotal} = "$sum ($Sumper %)";
	$h{$type}{HetHomoRatio} = $hetHomRatio;

	$h{$type}{NInsertion} = $nIn ;
	$h{$type}{NDeletion} = $nDe ;
	$h{$type}{InsertionDeletionRatio} = $indelRatio ;

}elsif(/^TiTvVariantEvaluator\s+dbsnp/){
	$h{$type}{TiTvRatio} = $F[10];
}

}{ mmfss("Eval",%h)
' $1 
