#!/bin/bash

. ~/.bash_function


### setting default
REF_default=/home/adminrig/workspace.min/MethylSeq/Reference/human_g1k_v37.fasta


## setting args 
REF=${1:-/home/adminrig/workspace.min/MethylSeq/Reference/human_g1k_v37.fasta}
GENOME=${2:-/home/adminrig/workspace.min/MethylSeq/Reference/human_g1k_v37.fasta.genome}
BED=${3:-/home/adminrig/Genome/SureSelect/Methyl-Seq/SureSelect.MethylSeq.84M.bed}


if [ -f "$REF" ] && [ -f "$GENOME" ] && [ -f "$BED" ];then


		## make fasta.fai
		[ ! -f "$REF.fai" ] && samtools faidx $REF
		[ ! -f "$GENOME" ]  && cut -f1,2 $REF.fai  > $GENOME


		find ./ -maxdepth 1 -mindepth 1 -type d | sort | grep "\/" | egrep -vi "(tmp|dmr|DepthCoverage|FastqcZip|GeneBody|MethylSeq.AnalysisReport.pdf_files|figure.png|HTML|submit)" | sed 's/\.\///' > SampleList
		samplelist=$(find ./ -maxdepth 1 -mindepth 1 -type d | sort | grep "\/" | egrep -vi "(tmp|dmr|DepthCoverage|FastqcZip|GeneBody|MethylSeq.AnalysisReport.pdf_files|figure|HTML|submit)" | sed 's/\.\///')


		### BamSort
		MethylSeq.BamSort.sh


		### make MethylKit RDS
		ssh -q -x 211.174.205.69 "cd $PWD && Rscript $src/R/Report/MethylSeq/MethylKit.makeRDS.R"
		ssq -q -x 211.174.205.73 "cd $PWD && Rscript $src/R/Report/MethylSeq/Bsseq.makeRDS.R"
		#ssh -q -x 211.174.205.69 "cd $PWD && Rscript $src/R/MethylKit.makeRDS.CHH.R"
		#ssh -q -x 211.174.205.69 "cd $PWD && Rscript $src/R/MethylKit.makeRDS.CHG.R"




		 
		### Make Methylseq Coverage Data 
		 
		for i in $(find $samplelist | grep deduplicated.bam$ | sort); 
		do 
		  qsub_wrapper.sh meth_step1 utl.q 36 none n $src/MethylSeq.step1.sh $i $REF $BED
		done 
		
		### for 69 server 
		# parallel --joblog .DepthOfCoverage.log --bar -k -j2 $src/MethylSeq.step1.sh {} $REF $BED ::: $(find $samplelist | grep deduplicated.bam$ | sort)


		 
		waiting meth_step1
		

		### Make bigwig file
		for i in $(find $samplelist | grep -i bedgraph.gz$)
			do
			qsub_wrapper.sh meth_bigwig utl.q 5 none n $src/Methylseq.bedGraph2bw.sh $i

		done





		### make Report

		# excute time : 2017-10-31 13:42:44 : report
		for i in $samplelist; do bismark2html.sh $i ; done


		# excute time : 2017-10-31 13:48:03 : Alignment Summary html
		/home/adminrig/src/bismark/Bismark-master/bismark2summary -o Overall_Summary --title "Methylseq Result" `find | grep pe.bam$ | sort | grep -v tmp `



		mkdir HTML && for i in $samplelist; do \mv -f $i.* HTML; done
		\mv -f Overall_Summary.* HTML




		### make Fastqc Summary


		# cp fastqc zip file to dir
		mkdir FastqcZip && cp `find $samplelist -type f | grep zip$` FastqcZip





		### make DepthCov Summary

		mkdir DepthCoverage

		AddRow.w.sh DepthCoverage/CoverageByDepth '(.+)\/DepthCov/' ID $(find $samplelist -type f | grep Coverage.DepthCov$) | grep AddRow | sh 
		AddRow.w.sh DepthCoverage/CoverageSummary '(.+)\/DepthCov/' ID $(find $samplelist -type f | grep Coverage.depth$) | grep AddRow | sh 
		AddRow.wn.sh DepthCoverage/CoverageMeanDepth '.\/(.+?)\/' ID $(find | grep bam.Coverage.mean$)   | grep ^Add | sh
		sed -i '1 i\chr\tstart\tend\tMeanDP\tID' DepthCoverage/CoverageMeanDepth

		# spent many times
		#for i in $(find $samplelist -type f  -name "*CX_report.txt") ;  do  (cd $(dirname $i) && perl -F'\t' -anle'BEGIN{print join "\t", qw/chr strand meth unmeth context/} print join "\t", @F[0,2..5]'  $(basename $PWD)_*bismark_bt2_pe.deduplicated.CX_report.txt > $(basename $PWD ).raw) ; done



		### make GeneBody rawdata 
		mkdir Genebody_rawdata
		cd Genebody_rawdata

		parallel --verbose --tag Methylseq.GeneBody_rawdata.sh {} $(dirname $(pwd)) :::: ../SampleList
		cd ..


		### make GeneBody folder
		Methylseq.GeneBody.sh $PWD/Genebody_rawdata/


		### make submit folder
		mkdir submit && ln $( find $samplelist | grep -e bismark.cov.gz$ -e deduplicated.bam$ ) submit



else

	usage "REF GENOME BED"

fi



