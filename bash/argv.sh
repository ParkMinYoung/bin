# http://jaduks.livejournal.com/7934.html

### set default value ###

tmpdir=/tmp
defvalue=1

DIR=${1:-$tmpdir}			    # Defaults to /tmp dir.
VALUE=${2:-$defvalue}           # Default value is 1.

echo $DIR
echo $VALUE

###########################################
# Now while running the script, specify values for both the arguments.
$ ./defvaue.sh /dev 23
/dev
23

# This time don't mention their values.
$ ./defvaue.sh
/tmp
1

