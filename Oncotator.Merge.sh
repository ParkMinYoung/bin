
# excute time : 2018-03-27 16:02:02 : 
AddRow.w.sh SomaticMutation '\/(.+).simple.txt' Analysis targetData/*simple.txt  | grep Add | sh


# excute time : 2018-03-27 16:03:25 : ID
tblmutate -e '$Analysis=~/(\w{2}_\d+)_/;$1' -l ID SomaticMutation > SomaticMutation.ID


# excute time : 2018-03-27 16:04:22 : Group
tblmutate -e '$Analysis=~/\d+_(.+)/;$1' -l Group SomaticMutation.ID > SomaticMutation.ID.Group


# excute time : 2018-03-27 16:17:47 : Gene list
ln -s /home/adminrig/workspace.min/DNALink.PDX/GeneSetList/GeneList ./


# excute time : 2018-03-27 16:20:00 : extract in GOI
extract.h.sh GeneList 1 SomaticMutation.ID.Group 2 > SomaticMutation.ID.Group.Genelist 


# excute time : 2018-03-27 16:37:57 : make input by each sample
for i in $(  tail -n +2 SomaticMutation.ID.Group.Genelist | cut -f41 | uniq  ); do grep -w $i SomaticMutation.ID.Group.Genelist | perl -F'\t' -MMin -anle'BEGIN{print join "\t", qw/gene type/} $type = uc(oncotator_anno_string_to_4Class($F[6]));$h{$F[1]}{$type}++ if $type; }{ show_hash( convert_hash2_to_hash1_by_delim(\%h,";") ) ' > $i.tmp   ; done 


# excute time : 2018-03-27 16:40:19 : merge
AddRow.w.sh merge '(.+).tmp' ID *.tmp | grep Add | sh 


# excute time : 2018-03-27 16:40:31 : remove *.tmp
rm -rf *.tmp



