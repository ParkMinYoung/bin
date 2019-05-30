for I in {1..10}; do echo $I; done 

for I in 1 2 3 4 5 6 7 8 9 10; do echo $I; done

for I in $(seq 1 10); do echo $I; done

for ((I=1; I <= 10 ; I++)); do echo $I; done

numbered hostnames padded with zeros:
for ((I=1; I <= 29 ; I++)); do 
echo `printf "node%02d\n" $I`; 
done


http://idolinux.blogspot.kr/2008/09/bash-for-loop-sequence.html

