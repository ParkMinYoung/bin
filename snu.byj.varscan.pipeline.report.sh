#!/bin/bash

source /home/jin/src/ngs-analysis/ngs.config.sh

TIERS_DIR=$1  # i.e. /home/adminrig/workspace.min/IonTorrent/IonProton/bin/Ion.Input/Auto_user_DL0-23-20131119-Amp.Customized.60genes.430k.set7_45_054/Analysis/tier

ls $TIERS_DIR/*snp*/P/*.png \
  | cut -f12- -d'/' | cut -f 1,5,6 -d'.' | cut -f1 -d'-' | sed 's/\./\t/g' \
| python -c "from ngs import noawk;
noawk.ex(lambda row: noawk.writer.writerow([row[0],row[1],int(row[2])+1]));
" > selected.snps.pass

ls $TIERS_DIR/*snp*/P/*.png \
   $TIERS_DIR/*snp*/H/*.png \
  | cut -f12- -d'/' | cut -f 1,5,6 -d'.' | cut -f1 -d'-' | sed 's/\./\t/g' \
| python -c "from ngs import noawk;
noawk.ex(lambda row: noawk.writer.writerow([row[0],row[1],int(row[2])+1]));
" | sort -u > selected.snps.hold

#--------------------------------------------------------------------------------------------------------------------------------------------------
# Run annotation pipeline

SELECTED_SNPS_FILES="selected.snps.pass selected.snps.hold"
for selected_snps_file in $SELECTED_SNPS_FILES; do
  echo "Running annotation on $selected_snps_file -----------------------------------------------------------"
  varscan_dir=varscan.`echo $selected_snps_file | cut -f3 -d'.'`
  mkdir $varscan_dir
  cd $varscan_dir
  ln -s ../varscan.filter/*varscan.snp ../varscan.filter/*varscan.indel .
  cd ..
  for sample in `cut -f1 $selected_snps_file | sort -u`; do
    varscan_file=$varscan_dir/$sample.varscan.snp
    cat <(head -n 1 $varscan_file) <(grep -f <(grep "^$sample" $selected_snps_file | cut -f2,3) $varscan_file) > $varscan_file.selected
  done
  # Run varscan pipeline without filtering
  /home/adminrig/workspace.jin/SNU.BYJ.proton.varscan.20131125.autoscript/scripts/ngs.pipe.somatic.varscan.ge.nofilter.selected.sh \
    $varscan_dir \
    bamlist \
    $HG_REF \
    0.05 \
    0.8 \
    8 \
    8 \
    0.9 \
    0.25 \
    0.05 \
    0.20 \
    3 \
    1 \
    0.17 \
    0.05 \
    0.07
done

sleep 300

# Wait for varscan annotation pipeline to finish
qsub_wrapper.sh snu.byj.wait4annot \
                $Q_HIGH \
                1 \
                annovar* \
                y \
                hello_world.sh

#####################################################################################################################################################
# Add additional fields and generate summaries
for selected_snps_file in $SELECTED_SNPS_FILES; do
  # GENERATE SUMMARIES ===================================================================================================================================
  echo "Generating summaries on $selected_snps_file -----------------------------------------------------------"
  VARSCAN_DIR=varscan.`echo $selected_snps_file | cut -f3 -d'.'`
  for sample in `cut -f1 $selected_snps_file | sort -u`; do
    python_ngs.sh annovar_csv.py varscan_summary -t gene         $VARSCAN_DIR/$sample.varscan.snp.*genome_summary.csv -o $VARSCAN_DIR/$sample.somatic.summary.gene &
    python_ngs.sh annovar_csv.py varscan_summary -t pos_detailed $VARSCAN_DIR/$sample.varscan.snp.*genome_summary.csv -o $VARSCAN_DIR/$sample.somatic.summary.pos.detailed &
    python_ngs.sh annovar_csv.py varscan_summary -t pos_simple   $VARSCAN_DIR/$sample.varscan.snp.*genome_summary.csv -o $VARSCAN_DIR/$sample.somatic.summary.pos.simple &
    wait
  done

  # ADD SOMATIC P-VALUE =================================================================================================================================
  echo "Adding somatic p-values"
  for file in `ls $VARSCAN_DIR/*detailed`; do
    sample=`echo $file | cut -f2 -d'/' | cut -f1 -d'.'`
    cat <(echo -e "chrom\tpos\tsomatic-pval") \
        <(cut -f 1,2,20 $VARSCAN_DIR/$sample.varscan.snp.fpfilter.pass.somaticfilter.procsom.dp.annovar.in) \
        > foo
    python_ngs.sh data_join.py \
  			-t left \
  			$file \
  			foo \
  			-a 21 22 \
  			-b 0 1 \
  			--header1 \
  			--header2 \
  			> $file.pval
    if [ $? -eq 1 ]; then
      echo "Error adding smoatic p-value to file: " $file
    fi
    rm -f foo
  done
  
  # Add Pharmacogenomic info ==============================================================================================================================
  echo "Adding pharmacogenomic information"
  PHARM_GKB=/home/adminrig/workspace.min/SMC.KimJinKuk.20121130/2st/somatic.analysis.20121225/oncogene_pharmGKB.txt
  for file in `ls $VARSCAN_DIR/*gene`; do
    python_ngs.sh data_join.py -t left --header1 --header2 $file $PHARM_GKB > $file.pharmGKB &
    wait
  done

  # Reorder the columns and format ========================================================================================================================
  echo "Reordering the columns"
  SCRIPTS_DIR=/home/adminrig/workspace.jin/SMC.Proton.OncoseqPanel.varscan.test.20130821/scripts
  for sample in `cut -f1 $selected_snps_file | sort -u`; do
    $PYTHON $SCRIPTS_DIR/format_result_cols_pos.py \
             $VARSCAN_DIR/$sample.somatic.summary.pos.detailed.pval \
             $PHARM_GKB \
             > $VARSCAN_DIR/$sample.somatic.summary.pos.detailed.pval.formatcols &
  
    $PYTHON $SCRIPTS_DIR/format_result_cols_gene.py \
            $VARSCAN_DIR/$sample.somatic.summary.gene.pharmGKB \
             > $VARSCAN_DIR/$sample.somatic.summary.gene.pharmGKB.formatcols &
    wait
  done

  # Add COSMIC data =======================================================================================================================================
  # Append COSMIC ID column to positional summary, and create another COSMIC summary file (additional sheet in excel) for the matched COSMIC variants
  echo "Adding COSMIC column"
  cosmicfile=/home/adminrig/workspace.jin/SMC.PGM.OncoseqPanel.PairBAM/COSMIC.chr.txt
  for sample in `cut -f1 $selected_snps_file | sort -u`; do
    posfile=$VARSCAN_DIR/$sample.somatic.summary.pos.detailed.pval.formatcols
    python_ngs.sh data_join.py \
  			-t left \
  			$posfile \
  			$cosmicfile \
  			-a 4 5 6 \
  			-b 17 18 19 \
  			--header1 \
  			--header2 \
  			| cut -f-31,42 | python_ngs.sh data_merge_rows.py -k 31 -d > $posfile.COSMIC &
    python_ngs.sh data_join.py \
    			-t inner \
  			$posfile \
  			$cosmicfile \
  			-a 4 5 6 \
  			-b 17 18 19 \
  			--header1 \
  			--header2 \
  			| cut -f 32- | sort -u > $posfile.COSMIC.records &
    wait
    #python_ngs.sh grep_w_column.py <(sed 1d $posfile.COSMIC | cut -f32 | sed 's/,/\n/g' | sort -u | sed '/^$/d') $cosmicfile -k 10 | sort -u > $posfile.COSMIC.records
  done
  
  # Match columns of mutation categories  ======================================================================================================================
  # (Consistent number of columns for easier report generation - even if a mutation category contains zero variants, still output it)  
  echo "Matching columns of mutation categories"
  for sample in `cut -f1 $selected_snps_file | sort -u`; do
    echo $sample
    $PYTHON $SCRIPTS_DIR/match_cols_pkg.py $VARSCAN_DIR/$sample.somatic.summary.gene.pharmGKB.formatcols > $VARSCAN_DIR/$sample.somatic.summary.gene.pharmGKB.formatcols.matchedcols
  done

  #-------------------------------------------------------------------------------------------------
  # Filter files for 60 hotspot genes
  echo "Filtering genes for hotspot genes"
  scriptsdir3=/home/adminrig/workspace.jin/SNU.BYJ.proton.varscan.20130912
  for sample in `cut -f1 $selected_snps_file | sort -u`; do
    posfile=$VARSCAN_DIR/$sample.somatic.summary.pos.detailed.pval.formatcols.COSMIC
    genesfile=$VARSCAN_DIR/$sample.somatic.summary.gene.pharmGKB.formatcols
    matchedcolsfile=$VARSCAN_DIR/$sample.somatic.summary.gene.pharmGKB.formatcols.matchedcols
    cosmicrecfile=$VARSCAN_DIR/$sample.somatic.summary.pos.detailed.pval.formatcols.COSMIC.records
    $PYTHON $scriptsdir3/filter_60genes.py $posfile 0 $posfile.genes60 &
    $PYTHON $scriptsdir3/filter_60genes.py $genesfile 0 $genesfile.genes60 &
    $PYTHON $scriptsdir3/filter_60genes.py $matchedcolsfile 0 $matchedcolsfile.genes60 &
    $PYTHON $scriptsdir3/filter_60genes.py $cosmicrecfile 20 $cosmicrecfile.genes60 &
    wait
  done

  # Create excel files for each sample ====================================================================================================================  
  for sample in `cut -f1 $selected_snps_file | sort -u`; do
    echo $sample -------------------------------------------------------
    python_ngs.sh excel_tool.py insert                                         \
  		  $VARSCAN_DIR/$sample.somatic.summary.pos.detailed.pval.formatcols.COSMIC.genes60   \
  		  $VARSCAN_DIR/$sample.somatic.summary.gene.pharmGKB.formatcols.genes60         \
  		  $VARSCAN_DIR/$sample.somatic.summary.pos.detailed.pval.formatcols.COSMIC.records.genes60   \
                    $VARSCAN_DIR/$sample.somatic.variant.report                \
                    -n position.cosmic gene.pharmGKB COSMIC.records
  done
done
wait

#====================================================================================================================  
echo "Listing files to use"
# List files to use
VARSCAN_DIR=varscan.pass
ls $VARSCAN_DIR/*somatic.summary.pos.detailed.pval.formatcols.COSMIC.genes60  \
   $VARSCAN_DIR/*somatic.summary.gene.pharmGKB.formatcols.matchedcols.genes60 \
   $VARSCAN_DIR/*somatic.summary.pos.detailed.pval.formatcols.COSMIC.records.genes60 | grep -f <(cut -f1 selected.snps.pass) > varscan.pass.files2use

VARSCAN_DIR=varscan.hold
ls $VARSCAN_DIR/*somatic.summary.pos.detailed.pval.formatcols.COSMIC.genes60  \
   $VARSCAN_DIR/*somatic.summary.gene.pharmGKB.formatcols.matchedcols.genes60 \
   $VARSCAN_DIR/*somatic.summary.pos.detailed.pval.formatcols.COSMIC.records.genes60 | grep -f <(cut -f1 selected.snps.hold) > varscan.hold.files2use

echo "Gathering files to use"
mkdir varscan.report.files2use.pass varscan.report.files2use.hold
for file in `cat varscan.pass.files2use`; do
  cp $file varscan.report.files2use.pass
done
for file in `cat varscan.hold.files2use`; do
  cp $file varscan.report.files2use.hold
done

echo "Gathering excel files"
mkdir -p excel_reports/hold excel_reports/pass
mv `ls varscan.hold/*xlsx | grep -f <(cut -f1 selected.snps.hold) -` excel_reports/hold/
mv `ls varscan.pass/*xlsx | grep -f <(cut -f1 selected.snps.pass) -` excel_reports/pass/

# Create fake excel files for samples that had no variants found
empty_excel_file=/home/adminrig/workspace.jin/SNU.BYJ.proton.varscan.20131125.autoscript/somatic.variant.report.xlsx
for sid in `cut -f1 bamlist`; do
  excel_file=excel_reports/pass/$sid.somatic.variant.report.xlsx
  if [ ! -s $excel_file ]; then
    cp $empty_excel_file  $excel_file
  fi
  excel_file=excel_reports/hold/$sid.somatic.variant.report.xlsx
  if [ ! -s $excel_file ]; then
    cp $empty_excel_file  $excel_file
  fi
done

echo "Running skullcap scripts"
cd varscan.report.files2use.hold
bash /home/adminrig/workspace.jin/SNU.BYJ.proton.varscan.20131011/script.skullcap.sh
cd ../varscan.report.files2use.pass
bash /home/adminrig/workspace.jin/SNU.BYJ.proton.varscan.20131011/script.skullcap.sh
cd ..

echo "Rounding somatic p-values"
# Change somatic p-value formats
file1=varscan.report.files2use.hold/genes.all
file2=varscan.report.files2use.hold/genes.all.txt
file3=varscan.report.files2use.pass/genes.all
file4=varscan.report.files2use.pass/genes.all.txt
files="$file1 $file2 $file3 $file4"
for file in $files; do
cat $file | $PYTHON -c "import csv,sys; r=csv.reader(sys.stdin,delimiter='\t'); w=csv.writer(sys.stdout,delimiter='\t',lineterminator='\n'); w.writerows([row[:12]+[float('%.4e' % float(row[12]))] + row[13:] for row in r])" > $file.e
done

