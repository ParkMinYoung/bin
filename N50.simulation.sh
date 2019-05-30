CONTIG=$1
for i in 0 100 200 300 400 500
	do
	DIR=over.$i
	mkdir $DIR
	(
		cd $DIR
		ln -s ../$CONTIG ./
		abyss.contig.fa.overN.sh $CONTIG $i
	)
done

abyss-fac.summary.sh `find over* -type f | grep over | grep fa$ | sort`
contig.len.batch.sh `find over* -type f | grep over | grep fa$ | sort`



# drwxrwxr-x 2 adminrig adminrig    0 Sep 29 16:31 over500
# drwxrwxr-x 2 adminrig adminrig    0 Sep 29 16:31 over400
# drwxrwxr-x 2 adminrig adminrig    0 Sep 29 16:31 over300
# drwxrwxr-x 2 adminrig adminrig    0 Sep 29 16:31 over200
# drwxrwxr-x 2 adminrig adminrig    0 Sep 29 16:31 over100
# -rw-rw-r-- 1 adminrig adminrig 1.2G Sep 29 16:12 batch.31-contigs.fa.over100.fa.500-300.fa.Modify.fa
# -rw-rw-r-- 1 adminrig adminrig 1.2G Sep 29 16:12 batch.31-contigs.fa.over100.fa.500-300.fa
# -rw-rw-r-- 1 adminrig adminrig 541M Sep 29 16:12 batch.31-contigs.fa.over100.fa
# -rw-rw-r-- 1 adminrig adminrig  103 Sep 29 09:23 contig.len.dist.txt
# -rw-rw-r-- 1 adminrig adminrig   65 Sep 29 09:23 batch.31-contigs.fa.len
# -rw-rw-r-- 1 adminrig adminrig  151 Sep 29 09:22 fac.summary.txt
# -rw-rw-r-- 1 adminrig adminrig  655 Sep 29 09:22 batch.31-contigs.fa.fac
# -rw-rw-r-- 1 adminrig adminrig 2.3G Sep 28 21:13 batch.31-contigs.dot
# -rw-rw-r-- 1 adminrig adminrig 115K Sep 28 21:07 batch.31.log
# -rw-rw-r-- 1 adminrig adminrig 1.5G Sep 28 21:06 batch.31-contigs.fa
# -rw-rw-r-- 1 adminrig adminrig 897M Sep 28 21:00 batch.31-5.adj
# -rw-rw-r-- 1 adminrig adminrig  17M Sep 28 20:59 batch.31-5.path
# -rw-rw-r-- 1 adminrig adminrig 6.1M Sep 28 20:59 batch.31-5.fa
# 
