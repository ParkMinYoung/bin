## phase 3 vcf per chr(24 EA)

# convert vcf to plink using plink 1.9
for i in *vcf.gz; 
do  
/home/adminrig/src/PLINK/plink-1.09-x86_64/plink --vcf $i --make-bed --out $i.plink --allow-no-sex --threads 5
done


# remove <CN> marker
for i in *bim; do grep "<" $i | cut -f2 > $i.remove; done


# update plink file using precise step file
for i in *bim.remove
do 
		F=${i%.bim.remove}
		/home/adminrig/src/PLINK/plink-1.09-x86_64/plink --bfile $F --exclude $i --make-bed --out $i.QC --allow-no-sex --threads 5
done

# bim ifle update 
perl -F'\t' -i.bak -aple'if($F[1] eq "."){ $F[1] = join ":", @F[0,3,4,5]; $_=join "\t", @F}else{$F[1] = join ":", @F[1,0,3,4,5]; $_=join "\t", @F }' *.remove.QC.bim


# plink merge(do it in 69 server)
plinkMerge.sh $PWD


