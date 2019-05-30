#!/bin/sh

. ~/.bash_function

if [ -f "$1" ];then
	perl -F'\t' -MList::MoreUtils=apply -anle'
	BEGIN{ $flag=1;$N=5 }

	if(/^Probe Set ID/){
		$ARGV=~/genotype_(\w+)\.txt/;
		$chr=$1;
		if($flag){
			$oper = @F/$N;
			@mult = apply { $_ *= $N } 1 .. @F/$N;
			$col = @F;
			unshift @mult,0,-3,$col,-2;
			$F[$col]="chr";
			print join "\t", @F[@mult];
			$flag=0;
		}
	}elsif(/^S-/){
		$F[$col]=$chr;
		print join "\t",map { $_ ? $_ : "NN" } @F[@mult];	
	}
	' $@ > Affymetrix.CytoScan.HD.Genotype 
else
	echo "Affymetrix.CytoScanHD.Array.Genotype.parsing.sh 10sample.cytoscanHD.genotype_*"
	usage "xxx.geno.cyhd yyy.geno.cyhd xxx.geno.cyhd ..."
fi

# # Annotation DB Used: C:\ProgramData\Affymetrix\Chromosome Analysis Suite\Library\CytoScanHD_Array.na32.annot.db
# # Array Type Name: CytoScan HD Array
# # Array Type Internal Name: CytoScanHD_Array
# # Export GUID: 0fa59818-ab99-4b1f-8e22-06050565e88a
# # Array Annotation Database NetAffx Build: 32
# # UCSC Genomic Version: hg19
# # NCBI Genomic Version: 37
# # dbSNP Version: 132
# # CHP File 1: C:\Users\minmin3\Documents\DX10_(CytoScanHD_Array).geno.cyhd.cychp (NA32)
# # CHP File 2: C:\Users\minmin3\Documents\DX1_(CytoScanHD_Array).geno.cyhd.cychp (NA32)
# # CHP File 3: C:\Users\minmin3\Documents\DX2_(CytoScanHD_Array).geno.cyhd.cychp (NA32)
# # CHP File 4: C:\Users\minmin3\Documents\DX3_(CytoScanHD_Array).geno.cyhd.cychp (NA32)
# # CHP File 5: C:\Users\minmin3\Documents\DX4_(CytoScanHD_Array).geno.cyhd.cychp (NA32)
# # CHP File 6: C:\Users\minmin3\Documents\DX5_(CytoScanHD_Array).geno.cyhd.cychp (NA32)
# # CHP File 7: C:\Users\minmin3\Documents\DX6_(CytoScanHD_Array).geno.cyhd.cychp (NA32)
# # CHP File 8: C:\Users\minmin3\Documents\DX7_(CytoScanHD_Array).geno.cyhd.cychp (NA32)
# # CHP File 9: C:\Users\minmin3\Documents\DX8_(CytoScanHD_Array).geno.cyhd.cychp (NA32)
# # CHP File 10: C:\Users\minmin3\Documents\DX9_(CytoScanHD_Array).geno.cyhd.cychp (NA32)
# # Input Chromosome: All
# # Output Chromosome: 10
# Probe Set ID    DX10_(CytoScanHD_Array).geno.cyhd Call Codes    DX10_(CytoScanHD_Array).geno.cyhd Confidence    DX10_(CytoScanHD_Array).geno.cyhd Signal A      DX10_(CytoScanHD_Array).geno.cyhd Signal B      DX10_(CytoScanHD_Array).
# S-3HLZB BB      0.0     301.55777       2460.5483       GG      AB      0.0     1350.5131       1629.5176       CG      AB      0.0     1135.0405       1340.8293       CG      BB      0.0     352.9301        3089.9163       GG      
# S-3FXHM AA      1.3322676E-13   4346.7515       986.3978        TT      AA      0.0     4055.6248       778.5073        TT      AA      1.7741364E-13   3953.8103       901.57385       TT      AA      1.3402346E-10   3877.5005       
# S-3UOYE NoCall  0.05453834      3738.0024       4612.9414               NoCall  0.054061696     3633.015        3789.17         BB      4.4465243E-4    3039.4822       4328.4746       GG      BB      3.3181352E-6    2419.83 3980.550
# S-4SVJW AA      2.4065316E-9    1790.9426       430.23923       CC      AB      1.7827295E-11   942.0237        640.9774        CT      AA      6.997296E-10    1401.863        327.19733       CC      AA      2.0055943E-5    1045.866
# S-4AOTI AA      7.749357E-14    2469.388        623.60455       GG      AB      0.0     1482.6246       1103.7297       GT      AA      9.769963E-15    1882.4343       460.27222       GG      AA      1.2263524E-12   1637.424        
# S-3YCCD AA      0.0     629.1008        172.14235       TT      AB      4.52971E-14     363.51813       752.244 TG      AB      5.2979843E-13   348.9179        756.5547        TG      AA      0.0     663.2376        167.85434       
# S-3JFIK BB      4.7704752E-8    939.6491        3001.4539       GG      AB      2.2199753E-10   1090.9921       1739.9799       AG      BB      2.0310642E-11   806.5758        2957.4006       GG      BB      4.440892E-16    739.0917
# S-3NJRD AA      3.7122572E-10   1635.9092       826.4435        AA      BB      0.0     421.929 1884.9238       GG      AB      3.419487E-14    816.6564        1260.1299       AG      AA      1.3419853E-4    1196.7128       792.1396
# S-4GAIN AA      0.0     2830.6343       684.7167        AA      AB      0.0     2135.2817       2208.8486       AG      AB      0.0     2033.591        1979.6332       AG      AA      0.0     3141.6023       920.71344       AA      
# S-4PVWY AB      0.0028785497    2179.7473       2684.1252       CG      AA      4.2946928E-7    3437.6714       2591.2856       CC      NoCall  0.1658675       1970.7284       3096.1904               NoCall  0.1528843       1926.887
# S-3XTHQ BB      0.0     286.8896        1466.4523   
