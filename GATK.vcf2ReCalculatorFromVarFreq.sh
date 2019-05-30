perl -F'\t' -MList::MoreUtils=firstidx -anle'
if(/^#/){
		print;
}elsif($F[8]=~/AD/){
			
		@info=@F[0..8];
		@data=@F[9..$#F];
		@l=split ":",$F[8];

		$in_GT=firstidx { $_ eq "GT" } @l;
		$in_AD=firstidx { $_ eq "AD" } @l;
#		$in_DP=firstidx { $_ eq "DP" } @l;
#		$in_GQ=firstidx { $_ eq "GQ" } @l;
#		$in_PL=firstidx { $_ eq "PL" } @l;

		for $i(@data) { 
			next if $i eq "./.";
			@elements=split ":", $i;
			($ref,$var)= split ",", $elements[$in_AD];
			$var_per= 
					$var == 0 ? 0 : $var/($ref+$var);
			
			if($var_per <  0.3){
				$elements[$in_GT]="0/0";
			}elsif($var_per >= 0.3 && $var_per < 0.9){
				$elements[$in_GT]="0/1";
			}elsif($var_per => 0.9){
				$elements[$in_GT]="1/1";
			}
			$i=join ":", @elements;
		}
		print join "\t", @info,@data;
}else{
		print
}' $@ 

