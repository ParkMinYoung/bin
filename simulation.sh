

for x in 0 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.0;

	do 
	for y in 0 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.0;
		do
		perl -F'\t' -asnle'
		next if $.==1; 
		if($F[7] >= $xcr && $F[10] >= $ycr){
			$match+=$F[1];
			$Total+=$F[5];
			$n++;
		} 
		}{ 
			if( $match && $Total ){
				$Rate=sprintf "%0.2f",$match/$Total*100
			}else{ 
				$Rate = sprintf "%0.2f", 0 
			}

			print join "\t", $xcr,$ycr, $n,$match,$Total,$Rate
		' -- -xcr=$x -ycr=$y Concordance.txt 
		
		done
done


## 0       probeset_id     chr10:4564553
## 1       Com_Match       7
## 2       Com_Mis 2
## 3       Com_Mis_Het     2
## 4       Com_Mis_Homo    0
## 5       Comparison      9
## 6       Concordance     77.78
## 7       XCR     1.00
## 8       XCall   9
## 9       XN      0
## 10      YCR     1.00
## 11      YCall   9
## 12      YN      0
## 13      total   9
## [2] : ################################################################################
## [2] : ################################################################################
## 
