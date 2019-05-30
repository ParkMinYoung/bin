perl -F'\t' -MMin -ane'
chomp@F; 
$type="";

if($F[6]=~/Frame/){
    $type="FRAMESHIFT"
}elsif($F[6]=~/Missense/){
    $type="MISSENSE"
}elsif($F[6]=~/Nonsense/){
    $type="NONSENSE"
}elsif($F[6]=~/Splice/){
    $type="SPLICE"
}

if( $type ){
    $h{$F[2]}{$type}++;
    $h{Total}{Total}++;
    $h{Total}{$type}++;
}

}{
	mmfss("Sample2MuteCount", %h) ' MutationTable
