cd /home/adminrig/src/short_read_assembly 


DIR=/backup04/workspace.min/LastDir

backup_src=$(date +%Y%m%d).bin.tgz
backup_rmd=$(date +%Y%m%d).rmd.tgz

tar Rczf $backup_src bin
# cp $backup /home/adminrig/src/short_read_assembly/bin
tar cvzfh $backup_rmd /home/adminrig/workspace.min/DNALink/Project/

cp -f $backup_src $backup_rmd $DIR

export GIT_SSL_NO_VERIFY=true
cd bin  
git add *
git status
git commit -m "$(date). update"
git push -u origin master

