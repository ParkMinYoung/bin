perl -F'\t' -MMin -ane'
next if /Sample/;

$F[2]=~s/`//; 
$F[2]=~s/-/\./g;

if($F[7]=~/Frame/){
		$type = "FRAMESIFT";
}elsif($F[7]=~/Splice/){
        $type = "SPLICE";
}elsif($F[7]=~/Missense/){
        $type = "MISSENSE";		
}elsif($F[7]=~/Nonsense/){
        $type = "NONSENSE";		
}

$h{$F[0]}{$F[2]}{$type}++;  

}{ 
for $sam( keys %h ){
   for $gene( keys %{$h{$sam}} ){
        $value = join ";", sort keys %{ $h{$sam}{$gene} };
		$onco{$sam}{$gene} = "$value";
    }
}

mmfss_blank("OncoPrint.input", %onco)
' $1
#' TargetAnnotation
#' InterestedSites

# 1 : ID
# 3 : Gene
# 8 : Annotation

