#cd tier
for i in `find_d 1 | grep snp.IGV`;do (cd $i && mkdir P H F);done


find snuh* -maxdepth 1 -type f | grep png$ | perl -MFile::Basename -nle'/(snuh\d+)/; $f=fileparse($_); print "$1.$f"' > png
mkdir png.dir

 find snuh* -type f | grep png$ | perl -MFile::Basename -nle'/(snuh\d+)/; $f=fileparse($_); print "ln $_ png.dir/$1.$f"' > png.ln
 sh png.ln

cd png.dir
ls *png | perl -nle's/\.png//; print "insert into frequency (assayid, pvalue, remarks, qcr, path) values (\"$_\", \"0\", \"\", \"\", \"\")"' |  tr "\"" "\'" > png.sql

