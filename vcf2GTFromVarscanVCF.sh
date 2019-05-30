perl -F'\t' -MMin -asne'
	chomp @F;
	
	next if /^##/;
	@data = @F[ 9 .. $#F ];  

	if( /^#CHR/ ){
		@sam = @data;
		next;
	}

	$loc = "$F[0]-$F[1]";
	$h{$loc}{"0REF"}=$F[3];
	$h{$loc}{"1ALT"}=$F[4];

	while($F[7]=~/(\w+)=(\d+)/g){
		$h{$loc}{"2$1"}=$2;
	}

	
	$ln = $_;
	for ( 0 .. $#data ){
		if( $data[$_] =~ /^\.\/\./ ){
			# no call
			$h{$loc}{$sam[$_]}="-"
		}elsif(  $data[$_] =~ /(^\d+\/\d+):\d+:\d+:\d+:(\d+):(\d+)/ ){
			# $1 : 1/1 genotype
			# $2 : RD  reference DP
			# $3 : AD  alternative DP
			($geno,$RD,$AD) = ($1,$2,$3);
			
			if( $geno =~ /1|2/ ){
				# alternative allele count
				$h{$loc}{$sam[$_]}="$RD | $AD";
				print STDERR join "\t", @F[0,1], $sam[$_], $geno, $AD/($RD+$AD),$RD, "$AD\n";
			}else{
				# reference allele count
				$h{$loc}{$sam[$_]}="$RD | $AD";
				$freq = $AD ?  $AD/($RD+$AD) : 0;
				#print STDERR join "\t", @F[0,1], $sam[$_], $geno,$freq,$RD, "$AD\n";
			}

		}else{
			die "err $ln"
		}
	}

}{
	mmfss("$f.AD", %h)
' -- -f=$1 $1 2> $1.PerSample.AD



#7       55211075        .       C       T       .       str10   ADP=71;WT=108;HET=0;HOM=1;NC=154        GT:GQ:SDP:DP:RD:AD:FREQ:PVAL:RBQ:ABQ:RDF:RDR:ADF:ADR    0/0:27:248:146:146:0:0%:1E0:27:0:127:19
#7       55211180        .       G       A       .       PASS    ADP=48;WT=77;HET=1;HOM=0;NC=185 GT:GQ:SDP:DP:RD:AD:FREQ:PVAL:RBQ:ABQ:RDF:RDR:ADF:ADR    ./.:.:43        ./.:.:0 ./.:.:0 ./.:.:0 ./.:.:0 
#7       55211182        .       G       A       .       PASS    ADP=73;WT=89;HET=1;HOM=0;NC=173 GT:GQ:SDP:DP:RD:AD:FREQ:PVAL:RBQ:ABQ:RDF:RDR:ADF:ADR    0/0:41:255:219:219:0:0%:1E0:26:0:0:219:0:0      
#7       55214348        .       C       T       .       PASS    ADP=93;WT=74;HET=36;HOM=29;NC=124       GT:GQ:SDP:DP:RD:AD:FREQ:PVAL:RBQ:ABQ:RDF:RDR:ADF:ADR    0/0:25:247:134:134:0:0%:1E0:26:0:134:0:0
#7       55214443        .       G       A       .       PASS    ADP=75;WT=112;HET=10;HOM=3;NC=138       GT:GQ:SDP:DP:RD:AD:FREQ:PVAL:RBQ:ABQ:RDF:RDR:ADF:ADR    0/0:27:252:146:146:0:0%:1E0:26:0:0:146:0
#7       55214458        .       C       T       .       PASS    ADP=115;WT=128;HET=1;HOM=0;NC=134       GT:GQ:SDP:DP:RD:AD:FREQ:PVAL:RBQ:ABQ:RDF:RDR:ADF:ADR    0/0:35:267:190:190:0:0%:1E0:26:0:0:190:0

