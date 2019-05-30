while getopts "a:b:h" opt
do
    case $opt in
        a) arg_a=$OPTARG
          echo "Arg A: $arg_a"
          ;;
        b) arg_b=$OPTARG
          echo "Arg B: $arg_b"
          echo "$arg_b"
          ;;
        h) help ;;
        ?) help ;;
    esac
done

# 
shift $(( $OPTIND - 1))
file=$1
echo "$file"


