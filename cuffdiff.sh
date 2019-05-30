#!/bin/sh

REF=/home/adminrig/Genome/BOWTIE_INDEX/susScr2.fa
GTF=/home/adminrig/Genome/BOWTIE_INDEX/GTF/Sus_scrofa.Sscrofa9.64.gtf

cuffdiff 										\
--output-dir cuffdiff.output.`date +%Y%m%d`		\
--frag-bias-correct $REF						\
--multi-read-correct 							\
--num-threads 10								\
--library-type fr-unstranded 					\
--total-hits-norm								\
--poisson-dispersion 							\
--no-update-check 								\
--emit-count-tables 							\
$GTF 											\
$@ >& cuffdiff.`date +%Y%m%d`.log

## cuffdiff: /usr/lib64/libz.so.1: no version information available (required by cuffdiff)
## cuffdiff v1.1.0 (2699)
## -----------------------------
## Usage:   cuffdiff [options] <transcripts.gtf> <sample1_hits.sam> <sample2_hits.sam> [... sampleN_hits.sam]
##    Supply replicate SAMs as comma separated lists for each condition: sample1_rep1.sam,sample1_rep2.sam,...sample1_repM.sam
## General Options:
##   -o/--output-dir              write all output files to this directory              [ default:     ./ ]
##   --seed                       value of random number generator seed                 [ default:      0 ]
##   -T/--time-series             treat samples as a time-series                        [ default:  FALSE ]
##   -c/--min-alignment-count     minimum number of alignments in a locus for testing   [ default:   10 ]
##   --FDR                        False discovery rate used in testing                  [ default:   0.05 ]
##   -M/--mask-file               ignore all alignment within transcripts in this file  [ default:   NULL ]
##   -b/--frag-bias-correct       use bias correction - reference fasta required        [ default:   NULL ]
##   -u/--multi-read-correct      use 'rescue method' for multi-reads (more accurate)   [ default:  FALSE ]
##   -N/--upper-quartile-norm     use upper-quartile normalization                      [ default:  FALSE ]
##   -L/--labels                  comma-separated list of condition labels
##   -p/--num-threads             number of threads used during quantification          [ default:      1 ]
## 
## Advanced Options:
##   --library-type               Library prep used for input reads                     [ default:  below ]
##   -m/--frag-len-mean           average fragment length (unpaired reads only)         [ default:    200 ]
##   -s/--frag-len-std-dev        fragment length std deviation (unpaired reads only)   [ default:     80 ]
##   --num-importance-samples     number of importance samples for MAP restimation      [ default:   1000 ]
##   --num-bootstrap-samples      Number of bootstrap replications                      [ default:     20 ]
##   --bootstrap-fraction         Fraction of fragments in each bootstrap sample        [ default:    1.0 ]
##   --max-mle-iterations         maximum iterations allowed for MLE calculation        [ default:   5000 ]
##   --compatible-hits-norm       count hits compatible with reference RNAs only        [ default:   TRUE ]
##   --total-hits-norm            count all hits for normalization                      [ default:  FALSE ]
##   --poisson-dispersion         Don't fit fragment counts for overdispersion          [ default:  FALSE ]
##   -v/--verbose                 log-friendly verbose processing (no progress bar)     [ default:  FALSE ]
##   -q/--quiet                   log-friendly quiet processing (no progress bar)       [ default:  FALSE ]
##   --no-update-check            do not contact server to check for update availability[ default:  FALSE ]
##   --emit-count-tables          print count tables used to fit overdispersion         [ default:  FALSE ]
##   --max-bundle-frags           maximum fragments allowed in a bundle before skipping [ default: 500000 ]
## 
## Supported library types:
##         ff-firststrand
##         ff-secondstrand
##         ff-unstranded
##         fr-firststrand
##         fr-secondstrand
##         fr-unstranded (default)
##         transfrags
