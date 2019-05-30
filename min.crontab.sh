#* * * * * ls /home/adminrig/* > lslist.min
40 1 * * * /home/adminrig/workspace.shin/gwas/CELcopy.sh /home/adminrig/workspace.shin/gwas/Genowide6.0_96CEL | sh 
#41 1 * * * find /home/adminrig/workspace.shin/gwas/Genowide6.0_96CEL -type f -name *.CEL | xargs -i basename {} | rsync -avz --files-from=- /home/adminrig/workspace.shin/gwas/Genowide6.0_96CEL/ /home/adminrig/workspace.shin/gwas/Genowide6.0_96CEL.rsync >& /home/adminrig/workspace.shin/gwas/Genowide6.0_96CEL/Genowide6.0_96CEL.rsync.log 
* * * * * date >> min.date.log 

1 * * * * find  /home/adminrig/workspace.min/AFFX/211.174.205.5 -type f | grep CEL$ | grep -v 200ms |  grep BioBankPlus_SNUHDMEX | xargs -i basename {} | rsync -avz --files-from=- /home/adminrig/workspace.min/AFFX/211.174.205.5/  /home/adminrig/workspace.min/AFFX/Axiom_BioBankPlus_SNUHDMEX >> /home/adminrig/workspace.min/AFFX/Axiom_BioBankPlus_SNUHDMEX.log
1 * * * * find /home/adminrig/workspace.min/AFFX/211.174.205.19 -type f | grep CEL$ |  grep -v 200ms | grep BioBankPlus_SNUHDMEX | xargs -i basename {} | rsync -avz --files-from=- /home/adminrig/workspace.min/AFFX/211.174.205.19/ /home/adminrig/workspace.min/AFFX/Axiom_BioBankPlus_SNUHDMEX >> /home/adminrig/workspace.min/AFFX/Axiom_BioBankPlus_SNUHDMEX.log

20 * * * * find /home/adminrig/workspace.min/AFFX/211.174.205.5  -type f | grep CEL$ |  grep -v 200ms | grep "Axiom_KORV1" | xargs -i basename {} | rsync -avz --files-from=- /home/adminrig/workspace.min/AFFX/211.174.205.5/  /home/adminrig/workspace.min/AFFX/Axiom_KORV1.0 >> /home/adminrig/workspace.min/AFFX/Axiom_KORV1.0.log
20 * * * * find /home/adminrig/workspace.min/AFFX/211.174.205.19 -type f | grep CEL$ |  grep -v 200ms | grep "Axiom_KORV1" | xargs -i basename {} | rsync -avz --files-from=- /home/adminrig/workspace.min/AFFX/211.174.205.19/ /home/adminrig/workspace.min/AFFX/Axiom_KORV1.0 >> /home/adminrig/workspace.min/AFFX/Axiom_KORV1.0.log

30 * * * * /home/adminrig/workspace.min/AFFX/CEL.count.sh
30 * * * * /home/adminrig/workspace.min/AFFX/CEL.count.SNUHDMEX.sh

## AFFY ANALYSIS ##
1 * * * * /home/adminrig/src/short_read_assembly/bin/AffyChipAutoAnalysis.sh /home/adminrig/workspace.min/AFFX/Axiom_KORV1.0 >& /home/adminrig/workspace.min/AFFX/Axiom_KORV1.0/log
1 * * * * /home/adminrig/workspace.min/AFFX/Axiom_KORV1.0/summary.sh | tee ~/workspace.min/DNALink/AffyChip/Axiom_KORV1.0/CEL.status 

1 * * * * /home/adminrig/src/short_read_assembly/bin/AffyChipAutoAnalysis.sh /home/adminrig/workspace.min/AFFX/Axiom_BioBankPlus_SNUHDMEX >& /home/adminrig/workspace.min/AFFX/Axiom_BioBankPlus_SNUHDMEX/log
1 * * * * /home/adminrig/workspace.min/AFFX/Axiom_BioBankPlus_SNUHDMEX/summary.sh | tee ~//workspace.min/DNALink/AffyChip/Axiom_BioBankPlus_SNUHDMEX/CEL.status


## AFFY Scan
1 * * * * /home/adminrig/workspace.min/AFFX/Scanning.sh

## Mirror
20 * * * * sudo rsync -avzh /home/adminrig/workspace.min/DNALink /home/adminrig/workspace.min/211.174.205.50

#10 * * * * /home/adminrig/src/short_read_assembly/bin/AffyChipAutoAnalysis.sh /home/adminrig/workspace.shin/gwas/Genowide6.0_96CEL.rsync >& /home/adminrig/workspace.shin/gwas/Genowide6.0_96CEL.rsync/test
#35 * * * * /home/adminrig/src/short_read_assembly/bin/AffyChipAutoAnalysis.sh /home/adminrig/workspace.shin/gwas/Axiom_Exome319_ProjectTest >& /home/adminrig/workspace.shin/gwas/Axiom_Exome319_ProjectTest/log

#* * * * * cd /home/adminrig/workspace.shin/gwas/Genowide6.0_96CEL.rsync && ls *CEL > CEL.log 
