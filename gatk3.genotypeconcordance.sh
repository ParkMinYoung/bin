#!/bin/bash
##
## DESCRIPTION:   Run GATK HaplotypeCaller
##                http://www.broadinstitute.org/gatk/gatkdocs/org_broadinstitute_sting_gatk_walkers_haplotypecaller_HaplotypeCaller.html
## AUTHOR:        
## CREATED:       2014
## LAST MODIFIED: 
##
## USAGE:         GATK.Haplotypecaller.sh
##                                        ref.fa            # Reference fasta file used in alignment
##                                         "options"         # Options for this tool in quotes i.e. "--dbsnp dbSNP137.vcf -stand_call_conf [50.0] -stand_emit_conf 10.0 -L targets.interval_list"
##                                         outprefix         # Output prefix
##                                         in1.bam           # Input bam file
##                                         [in2.bam [...]]   # Additional bam files
##
## OUTPUT:        outprefix.HC.raw.variants.vcf
##

# Load analysis config
source $NGS_ANALYSIS_CONFIG

# Check correct usage
usage_min 4 $# $0

# Process input params
REF=$1; shift
EVAL=$1; shift
COMP=$1; shift
OUT=$1; shift
option=$1

# Format output filenames
# OUTPUTFILE=$NAME.HC.raw.variants.g.vcf

# Format list of input bam files
# INPUTBAM=''
# for bamfile in $INPUT; do
# 	# Check if file exists
#     assert_file_exists_w_content $bamfile
# 	INPUTBAM=$INPUTBAM' -I '$bamfile
# done

# Run tool
`javajar 64g` $GATK3          \
     -T GenotypeConcordance  \
     -R $REF                 \
     -eval $EVAL             \
     -comp $COMP             \
     -o $OUT                 \
     $option &> $OUT.log


#gatk3.genotypeconcordance.sh /home/wes/src/wes-analysis/resource/combined.fasta Human_kit.Mouse.vcf Mouse_kit.Mouse.vcf WGS.ConcordantRate "--printInterestingSites WGS.unmatch"
#gatk3.genotypeconcordance.sh /home/wes/src/wes-analysis/resource/combined.fasta Human_kit.Mouse.vcf Mouse_kit.Mouse.vcf WES.ConcordantRate "--printInterestingSites WES.unmatch  -L Mouse.WES.chrM.bed "

perl -F'\s\s+' -anle'if(/Sample\s+Non-Reference Sensitivity/){$flag=1; print join "\t", @F}elsif($flag){print join "\t", @F; $flag=0}'  $OUT > $OUT.tab
  
