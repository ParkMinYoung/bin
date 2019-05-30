var=$((var+1))
((var=var+1))
((var+=1))
((var++))



expr $( head -1 step1 | tr "\t" "\n" | wc -l ) - 40

echo $((  $( head -1 step1 | tr "\t" "\n" | wc -l ) - 40  )) 

echo $(( $(( $( head -1 step1 | tr "\t" "\n" | wc -l ) - 40  )) / 4  ))
 
 

