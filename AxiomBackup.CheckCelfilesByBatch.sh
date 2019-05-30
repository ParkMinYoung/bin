for i in `cut -f1 /home/adminrig/workspace.min/AFFX/BackupDB.211.174.205.*` 
	do 
	echo -ne $i : ; (cd Axiom_KORV1.0 && ls $i*.CEL | wc -l ) 
done
