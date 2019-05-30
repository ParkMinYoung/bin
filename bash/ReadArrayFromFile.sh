while IFS=$'\t' read -r column1 column2 column3 ; do
  printf "%b\n" "column1<${column1}>"
  printf "%b\n" "column2<${column2}>"
  printf "%b\n" "column3<${column3}>"
done < "folder"


while read A B; do echo $A $B ; done < MARKER
