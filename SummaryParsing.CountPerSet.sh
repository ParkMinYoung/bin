perl -F'\t' -MMin -ane'next if $F[0]!~/^Axiom/; $F[2]=~/(DL\d{3})(\d{3})/; $h{$2}{$1}++; $h{$2}{Total}++; $h{Total}{$1}++; $h{Total}{Total}++  }{ mmfss("Summary.Batch", %h)' $1
#Summary.txt

TAB2XLSX.sh Summary.Batch.txt
