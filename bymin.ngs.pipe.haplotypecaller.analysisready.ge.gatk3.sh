#!/bin/bash
##
## DESCRIPTION:   Run GATK Haplotypecaller, generate analysis ready vcf, and annotate
## CREATED:       2016
## MODIFIED BY:   
##
## USAGE:        ngs.pipe.haplotypecaller.analysisready.ge.gatk3.sh 
##                                                                    outprefix                   # Output prefix, i.e. samples.haplocall
##                                                                    (HG|B3x)                    # Resource type
##                                                                    (WGS|target_region.bed)     # If not WGS, then target region bed or intervals file
##                                                                    in1.bam                     # Input bam file
##                                                                    [in2.bam [...]]             # Additional bam files
## OUTPUT:        outprefix.analysisready.vcf
##


### qsub_wrapper.sh HC_bymin utl.q 72 none n $src/bymin.ngs.pipe.haplotypecaller.analysisready.ge.gatk3.sh 491.HC.genotypeGVCF $B3x $B3x_SURESELECT_BED samplist samplist


# Load analysis config
source $NGS_ANALYSIS_CONFIG

# Check correct usage
usage_min 4 $# $0

# Process input params
OUT=$1; shift
RCT=$1; shift
TGT=$1; shift
BAM=$@

# Set resource vars
if [ $RCT = 'HG' ]; then
  REF=$HG_REF_GATK2
  HAP=$HG_HAPMAP_VCF_GATK2
  OMN=$HG_OMNI1000_VCF_GATK2
  DBS=$HG_DBSNP_VCF_GATK2
else
  REF=$B3x_REF_GATK2
  HAP=$B3x_HAPMAP_VCF_GATK2
  OMN=$B3x_OMNI1000_VCF_GATK2
  DBS=$B3x_DBSNP_VCF_GATK2
fi

# Check if target region is specified
if [ ! $TGT = 'WGS' ]; then
  assert_file_exists_w_content $TGT
  OPTION_TGT="-L $TGT"
fi

QSUB=qsub_wrapper.sh
PYTHON_NGS=$NGS_ANALYSIS_DIR/modules/util/python_ngs.sh

rm -rf vcflist.txt

# Variant Call
for bam in $BAM; do
  bam=`echo $bam | sed 's/\/$//'`
  SAMPLENAME=`echo $bam | cut -f1 -d.`
  echo $SAMPLENAME.g.vcf >> vcflist.txt
  $QSUB $OUT.HaplotCall                                                \
      $Q_HIGH                                                          \
      16                                                               \
      none                                                             \
      n                                                                \
      $NGS_ANALYSIS_DIR/modules/variant/gatk3.haplotypecaller.sh       \
        $REF                                                           \
        $SAMPLENAME                                                    \
        "--dbsnp $DBS $OPTION_TGT --emitRefConfidence GVCF"            \
        $bam
done

#Genotype GVCF
$QSUB $OUT.Genotype                                                    \
      $Q_HIGH                                                          \
      8                                                                \
      $OUT.HaplotCall                                                  \
      n                                                                \
      $NGS_ANALYSIS_DIR/modules/variant/gatk3.genotypegvcfs.sh         \
        $OUT                                                           \
        $REF                                                           \
        "--dbsnp $DBS -A MappingQualityRankSumTest"                    \
        `cat vcflist.txt`

# snp.model <- BuildErrorModelWithVQSR(raw.vcf, SNP)
$QSUB $OUT.VQSR.SNP                                                    \
      $Q_HIGH                                                          \
      4                                                                \
      $OUT.Genotype                                                    \
      n                                                                \
      $NGS_ANALYSIS_DIR/modules/variant/gatk3.variantrecalibrator.sh   \
        $OUT.vcf                                                       \
        $RCT                                                           \
        SNP

# indel.model <- BuildErrorModelWithVQSR(raw.vcf, INDEL)
$QSUB $OUT.VQSR.INDEL                                                  \
      $Q_HIGH                                                          \
      4                                                                \
      $OUT.Genotype                                                    \
      n                                                                \
      $NGS_ANALYSIS_DIR/modules/variant/gatk3.variantrecalibrator.sh   \
        $OUT.vcf                                                       \
        $RCT                                                           \
        INDEL

# recalibratedSNPs.rawIndels.vcf <- ApplyRecalibration(raw.vcf, snp.model, SNP)
$QSUB $OUT.VQSR.apply.SNP                                             \
      $Q_HIGH                                                         \
      4                                                               \
      $OUT.VQSR.SNP                                                   \
      n                                                               \
      $NGS_ANALYSIS_DIR/modules/variant/gatk3.applyrecalibration.sh   \
        $REF                                                          \
        $OUT.vcf                                                      \
        $OUT.vcf.recal.SNP                                            \
        $OUT.vcf.recal.SNP.tranches                                   \
        SNP                                                           \
        99.9

# Dummy processes to make sure both indel_recal and snp_applyrecal finishes before indel_applyrecal
$QSUB $OUT.VQSR.waitb4.INDEL                                          \
      $Q_LOW                                                          \
      1                                                               \
      $OUT.VQSR.INDEL                                                 \
      n                                                               \
      $NGS_ANALYSIS_DIR/modules/util/hello_world.sh
$QSUB $OUT.VQSR.waitb4.SNP                                            \
      $Q_LOW                                                          \
      1                                                               \
      $OUT.VQSR.apply.SNP                                             \
      n                                                               \
      $NGS_ANALYSIS_DIR/modules/util/hello_world.sh

# analysisReady.vcf <- ApplyRecalibration(recalibratedSNPs.rawIndels.vcf, indel.model, INDEL)
$QSUB $OUT.VQSR.apply.INDEL                                           \
      $Q_HIGH                                                         \
      4                                                               \
      $OUT.VQSR.waitb4.*                                              \
      n                                                               \
      $NGS_ANALYSIS_DIR/modules/variant/gatk3.applyrecalibration.sh   \
        $REF                                                          \
        $OUT.recalSNP.vcf                                             \
        $OUT.vcf.recal.INDEL                                          \
        $OUT.vcf.recal.INDEL.tranches                                 \
        INDEL                                                         \
        99.9

# Rename vcf file
$QSUB $OUT.rename                                                     \
      $Q_LOW                                                          \
      1                                                               \
      $OUT.VQSR.apply.INDEL                                           \
      n                                                               \
      $NGS_ANALYSIS_DIR/modules/util/bash_wrapper.sh                  \
        ln -sf $OUT.recalSNP.recalINDEL.vcf $OUT.analysisready.vcf

# Quality filter
$QSUB $OUT.qfilter                                                    \
      $Q_MID                                                          \
      1                                                               \
      $OUT.rename                                                     \
      n                                                               \
      $PYTHON_NGS $NGS_ANALYSIS_DIR/modules/variant/vcf_filter.py     \
                      $OUT.analysisready.vcf                          \
                      --col-filter PASS                               \
                      -o $OUT.analysisready.pass.vcf

# annotation
qsub_wrapper.sh EFF_bymin utl.q 4 $OUT.qfilter n $NGS_ANALYSIS_DIR/pipelines/ngs.pipe.snpeff.snpsift.sh $OUT.analysisready.pass.vcf


