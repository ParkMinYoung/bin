# excute time : 2017-06-21 09:47:24 : link
ln -s ../FinalQC.??? ./


# excute time : 2017-06-21 09:48:01 : get r2 Analysis result
plink2 --bfile FinalQC --r2  --ld-window-r2 0.8 --show-tags all --tag-kb 500 --tag-r2 0.8 --out r2 --allow-no-sex --threads 10 
plink2 --bfile FinalQC --r2  --ld-window-r2 0.8 --show-tags all --tag-kb 250 --tag-r2 0.8 --out r2 --allow-no-sex --threads 10 


# excute time : 2017-06-21 10:07:11 : space to tab
PlinkOut2Tab.sh r2.tags.list 
grep -v  NONE$ r2.tags.list.tab | hsort - -nr -k4,4 | lesss





# r square = 1
plink2 --bfile FinalQC --r2  --ld-window-r2 1 --show-tags all --tag-kb 250 --tag-r2 1 --out r2.1 --allow-no-sex --threads 10 
PlinkOut2Tab.sh r2.1.tags.list 
grep -v  NONE$ r2.1.tags.list.tab | hsort - -nr -k4,4 | lesss
