#sed -i  's/LABEL$/Group/' Summary.txt

# excute time : 2017-04-27 16:09:42 : make HQS CEL info
perl -F"\t" -anle'if($.>1){ $F[1]=$F[25]; $F[1]=~/(KID\d+)/; $F[14]=$1 } print join "\t", @F[1..24]' /home/adminrig/workspace.min/FTP/DNALink/knih2017/KORV1_1/FindedRealCELName > KORV1_1.HQS


# excute time : 2017-04-27 15:53:09 : Merge Dataset
AddRow.sh -o CELfile_Information.Summary.txt.new -f "CELfile_Information.Summary.txt KORV1_1.HQS" -l "EXP HQS" 



# excute time : 2017-04-27 15:54:53 : Add GT number
join.h.sh Summary.txt CELfile_Information.Summary.txt.new 2 14 "4,25" > Summary.txt.GT


