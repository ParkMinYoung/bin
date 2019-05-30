
# execute time : 2019-01-11 21:15:17 : 
find $(dirname $(dirname $PWD) ) | grep cov.gz$ | grep -v submit > list


# execute time : 2019-01-11 21:20:21 : make DMR Cov file
Methylseq.DMR_Make_Cov_files.sh list Pairs 


# execute time : 2019-01-11 21:20:21 : run 
parallel --bar -j 1 -k --joblog err.log Methylseq.DMR.pipeline.sh {1} {2} ::: *.cov ::: TAIR10.30


# execute time : 2019-02-11 15:46:18 : run
#parallel --bar -j 4 --joblog err.log $PWD/Methylseq.DMR.pipeline.sh {1} {2} ::: *.cov ::: TAIR10.30  


# execute time : 2019-02-11 15:42:56 : Make DMRs
AddRow.w.sh DMRs '\/(.+)\/DMRs' Pairs $(find | grep DMRs$) -x 1 | grep Add | sh 


# execute time : 2019-02-11 16:39:41 : remove # string in the header line 
sed -i -n -e '1s/^# //'p -e '2,$'p DMRs


# execute time : 2019-02-12 10:19:12 : 
cp /home/adminrig/src/short_read_assembly/bin/R/Report/MethylSeq/DMR/DMR_Analysis_Summary.Rmd ./
run.RMD.sh DMR_Analysis_Summary.Rmd 


# execute time : 2019-02-12 11:22:29 : 
mkdir Result


# execute time : 2019-02-12 13:04:42 : hard link
parallel ln  {} Result/{= 's/.\/(.+)\/.+/\1/' =}.xlsx ::: $(find | grep xlsx$)


# execute time : 2019-02-12 14:13:14 : 
cp DMR_Analysis_Summary.nb.html Result/


