#!/bin/bash
##
## DESCRIPTION:   Run GATK DepthOfCoverage tool
##                http://www.broadinstitute.org/gatk/gatkdocs/org_broadinstitute_sting_gatk_walkers_coverage_DepthOfCoverage.html
##                http://gatkforums.broadinstitute.org/discussion/40/using-depthofcoverage-to-find-out-how-much-sequence-data-you-have
## AUTHOR:        Jin Kim jjinking(at)gmail(dot)com
## CREATED:       2012-2013
## LAST MODIFIED: 2013.10.15
##
## USAGE:         gatk2.depthofcoverage.sh
##                                         ref.fa            # Reference fasta file used in alignment
##                                         outprefix         # Output prefix, i.e. samples, input.bam, etc.  Tool will automatically append 'depthofcov'
##                                         "options"         # Options for this tool in quotes i.e. "-nt 20 -L target.bed"
##                                         in1.bam           # Input bam file
##                                         [in2.bam [...]]   # Additional bam files
##
## OUTPUT:        Coverage summaries
##

# Load analysis config
source $NGS_ANALYSIS_CONFIG

# Check correct usage
usage_min 4 $# $0

# Process input params
REF=$1; shift
OUT=$1; shift
OPT=$1; shift
BAM=$@

# Check to make sure reference file exists
assert_file_exists_w_content $REF

# Set up input params
OUT=$OUT.depthofcov

# # If output file already exists and has content, then don't run
assert_file_not_exists_w_content $OUT.sample_summary


# Format list of input bam files
INPUTBAM=''
for bamfile in $BAM; do
  # Check if file exists
  assert_file_exists_w_content $bamfile
  INPUTBAM=$INPUTBAM' -I '$bamfile
done

# Run tool
#`javajar 512g` $GATK     \
/home/wes/src/JAVA/latest/bin/java -Xmx512g -Djava.io.tmpdir=./ -jar /home/wes/src/GATK/latest/GenomeAnalysisTK.jar \
  -T DepthOfCoverage    \
  -R $REF               \
     $OPT               \
     $INPUTBAM          \
  -o $OUT               \
  &> $OUT.log
echo "depthofcov.$OUT : "$?
exitcode=$?
if [ $exitcode = 0 ]; then
  > $OUT.depthofcov.$exitcode.txt
else
  > $OUT.depthofcov.fail.$exitcode.txt
fi

# Arguments for DepthOfCoverage:
#  -o,--out <out>                                                        An output file created by the walker.  Will 
#                                                                        overwrite contents if file exists
#  -mmq,--minMappingQuality <minMappingQuality>                          Minimum mapping quality of reads to count towards 
#                                                                        depth. Defaults to -1.
#  --maxMappingQuality <maxMappingQuality>                               Maximum mapping quality of reads to count towards 
#                                                                        depth. Defaults to 2^31-1 (Integer.MAX_VALUE).
#  -mbq,--minBaseQuality <minBaseQuality>                                Minimum quality of bases to count towards depth. 
#                                                                        Defaults to -1.
#  --maxBaseQuality <maxBaseQuality>                                     Maximum quality of bases to count towards depth. 
#                                                                        Defaults to 127 (Byte.MAX_VALUE).
#  --countType <countType>                                               How should overlapping reads from the same 
#                                                                        fragment be handled? (COUNT_READS|COUNT_FRAGMENTS|
#                                                                        COUNT_FRAGMENTS_REQUIRE_SAME_BASE)
#  -baseCounts,--printBaseCounts                                         Will add base counts to per-locus output.
#  -omitLocusTable,--omitLocusTable                                      Will not calculate the per-sample per-depth 
#                                                                        counts of loci, which should result in speedup
#  -omitIntervals,--omitIntervalStatistics                               Will omit the per-interval statistics section, 
#                                                                        which should result in speedup
#  -omitBaseOutput,--omitDepthOutputAtEachBase                           Will omit the output of the depth of coverage at 
#                                                                        each base, which should result in speedup
#  -geneList,--calculateCoverageOverGenes <calculateCoverageOverGenes>   Calculate the coverage statistics over this list 
#                                                                        of genes. Currently accepts RefSeq.
#  --outputFormat <outputFormat>                                         the format of the output file (e.g. csv, table, 
#                                                                        rtable); defaults to r-readable table
#  --includeRefNSites                                                    If provided, sites with reference N bases but 
#                                                                        with coverage from neighboring reads will be 
#                                                                        included in DoC calculations.
#  --printBinEndpointsAndExit                                            Prints the bin values and exits immediately. Use 
#                                                                        to calibrate what bins you want before running on 
#                                                                        data.
#  --start <start>                                                       Starting (left endpoint) for granular binning
#  --stop <stop>                                                         Ending (right endpoint) for granular binning
#  --nBins <nBins>                                                       Number of bins to use for granular binning
#  -omitSampleSummary,--omitPerSampleStats                               Omits the summary files per-sample. These 
#                                                                        statistics are still calculated, so this argument 
#                                                                        will not improve runtime.
#  -pt,--partitionType <partitionType>                                   Partition type for depth of coverage. Defaults to 
#                                                                        sample. Can be any combination of sample, 
#                                                                        readgroup, library.
#  -dels,--includeDeletions                                              Include information on deletions
#  --ignoreDeletionSites                                                 Ignore sites consisting only of deletions
#  -ct,--summaryCoverageThreshold <summaryCoverageThreshold>             for summary file outputs, report the % of bases 
#                                                                        coverd to >= this number. Defaults to 15; can 
#                                                                        take multiple arguments.
