vcftools --vcf $1 --diff $2 --diff-site-discordance --diff-indv-discordance --diff-discordance-matrix --remove-indels --remove-filtered LowQual --minGQ 50 --minDP 10 --maxDP 10000 
# --indv 17 --indv  1122 --out out.prefix

