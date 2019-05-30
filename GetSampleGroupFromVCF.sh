
# vcf.sample.sh HomAlt_check.vcf | grep _100 | egrep -v "(X1|X2|X3|TT|BL)" | xargs -n 1 -i echo GEN[{}].GT | tr "\n" " "
 vcf.sample.sh HomAlt_check.analysisready.pass.vcf | grep _$1 | egrep -v "(X1|X2|X3|TT|BL)" | xargs -n 1 -i echo GEN[{}].GT | tr "\n" " "

