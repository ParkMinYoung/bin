#! /bin/bash



### http://www.thegeekstuff.com/2010/06/bash-array-tutorial/




Unix[0]='Debian'
Unix[1]='Red hat'
Unix[2]='Ubuntu'
Unix[3]='Suse'


# Print index 1 
echo ${Unix[1]}


# Print the Whole Bash Array
echo ${Unix[@]}


# We can get the length of an array using the special parameter called $#.
echo ${#Unix[@]}


# Number of characters in the first element of the array.i.e Debian
echo ${#Unix} 

# ${#arrayname[n]} should give the length of the nth element in an array
echo ${#Unix[0]}


# The below example returns the elements in the 3rd index and fourth index. 
# Index always starts with zero.
Unix=('Debian' 'Red hat' 'Ubuntu' 'Suse' 'Fedora' 'UTS' 'OpenLinux');
echo ${Unix[@]:3:2}


# The below example extracts the first four characters from the 2nd indexed element of an array.
echo ${Unix[2]:0:4}

# it replaces the element in the 2nd index 'Ubuntu' with 'SCO Unix'. 
# But this example will not permanently replace the array content.
echo ${Unix[@]/Ubuntu/SCO Unix}


# In the array called Unix, the elements 'AIX' and 'HP-UX' are added in 7th and 8th index respectively.
Unix=("${Unix[@]}" "AIX" "HP-UX")
echo ${Unix[7]}

Unix=('Debian' 'Red hat' 'Ubuntu' 'Suse' 'Fedora' 'UTS' 'OpenLinux');

# The above script will just print null which is the value available in the 3rd index. 
unset Unix[3]
echo ${Unix[3]}


Unix=('Debian' 'Red hat' 'Ubuntu' 'Suse' 'Fedora' 'UTS' 'OpenLinux');
pos=3
Unix=(${Unix[@]:0:$pos} ${Unix[@]:$(($pos + 1))})
echo ${Unix[@]}
# Debian Red hat Ubuntu Fedora UTS OpenLinux



declare -a Unix=('Debian' 'Red hat' 'Ubuntu' 'Suse' 'Fedora');
declare -a patter=( ${Unix[@]/Red*/} )

# The below example removes the elements which has the patter Red*.
echo ${patter[@]}
# Debian Ubuntu Suse Fedora

# Copying an Array
# Expand the array elements and store that into a new array as shown below.

Linux=("${Unix[@]}")
echo ${Linux[@]}
# Debian Red hat Ubuntu Fedora UTS OpenLinux

Unix=('Debian' 'Red hat' 'Ubuntu' 'Suse' 'Fedora' 'UTS' 'OpenLinux');
Shell=('bash' 'csh' 'jsh' 'rsh' 'ksh' 'rc' 'tcsh');

UnixShell=("${Unix[@]}" "${Shell[@]}")
echo ${UnixShell[@]}
# Debian Red hat Ubuntu Suse Fedora UTS OpenLinux bash csh jsh rsh ksh rc tcsh
echo ${#UnixShell[@]}
# 14


# Deleting an Entire Array
UnixShell=("${Unix[@]}" "${Shell[@]}")
unset UnixShell
echo ${#UnixShell[@]}
# 


# Load Content of a File into an Array
filecontent=( `cat "logfile" `)

for t in "${filecontent[@]}"
do
	echo $t
done

or

readarray T < logfile 





























# make lines to array
A=(0)
readarray B < $BED
FILE_ITEM_ARRAY=("${A[@]}" "${B[@]}")

# make file list to array
files=( $(ls *.xlsx) )
echo $files  ## return only 1  
echo ${files[@]} ## return all
echo ${files[0]} ## return first
echo ${files[1]} ## return second



