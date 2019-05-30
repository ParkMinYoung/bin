zcat $1 | fastx_quality_stats -i - -o $1.BaseStats -Q33 
