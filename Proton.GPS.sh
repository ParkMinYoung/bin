for i in `find | grep allele_counts.xls$ `
	do Proton.Hotspot2GPSgeno.sh $i
	cut -f11 $i.GPS.geno | sort | uniq -c
	perl -nle'if($.==1){print}elsif(/PASS/){print}' $i.GPS.geno > $i.GPS.geno.PASS
done
Proton.Hotspot2GPSgeno.Merge.sh `find | grep GPS.geno.PASS$`
perl -F'\t' -MList::MoreUtils=uniq -anle'if($.==1){print}else{@geno=uniq(split "", join "",@F[5..$#F]); print if @geno<=2}' GPS.geno > GPS.geno.tmp

mv GPS.geno GPS.geno.bak
mv GPS.geno.tmp GPS.geno

