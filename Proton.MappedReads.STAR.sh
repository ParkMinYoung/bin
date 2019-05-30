
perl -MMin -ne'
if($ARGV=~/_001.fastq.log$/ && /Processed reads:\s+(\d+)/){
    $total = $1;
    $ARGV =~ /(\w+)_AAAA/;
    $id=$1;
    $h{$id}{total}=$total;
}elsif($ARGV =~ /starLog.final.out$/){
    if(/ Number of input reads \|\s+(\d+)/){
        $h{$id}{"1st.input"} = $1;
        $h{$id}{"1st.input.%"} = sprintf "%.2f", $1/$h{$id}{total}*100;
    }elsif(/Uniquely mapped reads number \|\s+(\d+)/){
        $h{$id}{"1st.mapped"} = $1;
        $h{$id}{"1st.mapped.%"} = sprintf "%.2f", $1/$h{$id}{total}*100;
    }elsif(/Number of reads mapped to multiple loci \|\s+(\d+)/){
        $h{$id}{"1st.mapped"} += $1;
        $h{$id}{"1st.mapped.%"} = sprintf "%.2f", $1/$h{$id}{total}*100;
        $h{$id}{"1st.mapped.multiple"} = $1;
        $h{$id}{"1st.mapped.multiple.%"} = sprintf "%.2f", $1/$h{$id}{total}*100;
    }
}elsif($ARGV =~ /unmapped_remap.bam.flagstats$/){
    if(/(\d+) \+ 0 in total/){
        $h{$id}{"2nd.mapped"} = $1;
        $h{$id}{"2nd.mapped.%"} = sprintf "%.2f", $1/$h{$id}{total}*100;
    }
}
}{

$h{$id}{"total.mapped"} = $h{$id}{"1st.mapped"} + $h{$id}{"2nd.mapped"};
$h{$id}{"total.mapped.%"} = sprintf "%.2f",  $h{$id}{"total.mapped"} / $h{$id}{total}*100;
mmfss("$id.MappedReads", %h)' $(FileOrder.sh "2,1,3" `find | egrep "(R1_001.fastq.log|unmapped_remap.bam.flagstats|.starLog.final.out)"$ | sort`)


