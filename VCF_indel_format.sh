perl -F"\t" -anle'
if(@ARGV){ 
    $h{$F[0]}=$F[1] 
}else{ 
    $k=join ";", @F[0..4]; 
    if( $h{$k} ){ 
    	if ($F[3] eq "-" ){ 
    	    $F[3] = $h{$k}; 
    	    $F[4]=$h{$k}.$F[4];  
    	}else{
    	    $F[1]-- ; 
    	    $F[3] = $h{$k}.$F[3]; 
    	    $F[4]=$h{$k} 
    	} 
    }  
    print join "\t", @F  
}'  step3  step1  


