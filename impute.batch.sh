IMPUTE=/home/adminrig/Genome/1000Genomes/20130502/impute/impute_v2.3.2_x86_64_static/impute2

DIR=/home/adminrig/Genome/1000Genomes/20130502
REF_DIR=$DIR/1000GP_Phase3/1000GP_Phase3
WD=$DIR/KORV1.0.2014/
SHAPEIT=$WD/shapeit.1kg.phase3
OUT=$WD/impute2

if [ -f "config" ];then
    . config
fi

#genome2bed.sh | grep -v -e chrM -e chrX  -e chrY | \
cat ~/src/short_read_assembly/bin/genome2bed.impute.bed | grep -v -e chrM -e chrX  -e chrY | \
perl -F'\t' -asnle'
($chr, $start, $end, $len) = @F;
$map = "$ref_dir/genetic_map_${chr}_combined_b37.txt";
$hap = "$ref_dir/1000GP_Phase3_${chr}.hap.gz";
$legend = "$ref_dir/1000GP_Phase3_${chr}.legend.gz";
$known_hap = "$shapeit/${chr}_phased.haps";
$out = "$out_dir/${chr}_${start}_${end}";
print "$impute -use_prephased_g -m $map -h $hap -l $legend -known_haps_g $known_hap -int $start $end buffer 1000 Ne 14269 -o_gz -o $out -filt_rules_l \"EAS==0\" -allow_large_regions"
' -- -impute=$IMPUTE -ref_dir=$REF_DIR -dir=$DIR -out_dir=$OUT -shapeit=$SHAPEIT > impute.script.sh 
