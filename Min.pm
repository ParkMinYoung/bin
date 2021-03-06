package Min;
use Exporter;
use File::Glob;
use File::Basename;
use Tie::File;
use List::Util qw(first max maxstr min minstr reduce shuffle sum);
use Carp;
use POSIX qw(ceil floor);

@ISA = qw( Exporter );

@EXPORT = qw(
  average
  Stdev
  max_num
  min_num
  select_col_rm_redun
  array_redun_rm
  compare_A_and_B_file
  factorial
  Upcase
  file_concatenate
  file_divide_line_num
  redun_line_rm
  selected_col_make_key_for_group
  select_col_list_count
  diff_array_a
  common_array
  convert_file_format
  extract_key_cmp
  extract_key_num
  input_file_and_col
  input_file_and_col_default
  file_3_extract_info
  rm_end_blank
  A_cols_B_cols_output
  read_msg
  sum
  round_off
  rm_start_blank
  msg
  Seq
  File2Array
  File2hash
  Foreach_hash
  Foreach_array
  e
  make_dir
  getfilename
  Fasta_divide
  copy_file
  copy_file_FromTo
  rm_end_input
  File_want_col_sort
  Show_File
  get_time
  get_time_detail
  Array2Hash
  log_base
  Array_div_odd_even_index
  Array_div_odd_even_element
  cal_linker_length
  Array_start_double_howmany_tab
  seq2fasta_form
  Write_file
  calculate_promoter_between_gene
  confirm_2
  confirm_3
  show_array
  comma_count
  change_xy
  Key_value
  getFileExtension
  make_hash_from_file
  Chage
  read_matrix
  read_matrix_x
  make_col_function
  hash_tab_limited
  hash_tab_limited_cnt
  extract_want_col_from_f
  Merge
  Merge_custom
  fasta_f_read
  Extract_flanking_seq
  Input_STDIN_f
  Input_STDIN_t
  complementary
  trim_space
  IUPAC
  iupac2geno
  iupac2genotype
  fasta2hash
  mssql_connect
  divide_size
  show_column_sample_from_file
  csv_file_handle_key_value
  Foreach_hash2file
  make_2_hash
  make_2_hash_cnt
  make_3_hash
  make_array_with_delimit
  confirm_2_file
  confirm_3_file
  make_matrix_file
  make_matrix_file_new
  mmfss_ctitle
  mmfss_n
  mmfss
  mmfss_print
  mmfss_header
  mmfss_1
  mmfss_dot
  mmfss_blank
  mmfss_space2
  mmfns
  mmfsn
  mmfnn
  h2r
  sam_count_delimit_coma
  make_reverse_hash
  make_call_matrix
  File_line_check
  csv2txt
  show_array_array
  select_col_id_cnt
  select_two_col_id_cnt
  key_cnt
  select_col_count
  get_name
  matrix_call_num2AB
  sample_random_selection
  get_string_from_seq
  dp_f_info
  perl_script
  remote_test
  get_element
  convert_line
  Array2File
  compare_two_matrix
  read_matrix_qurated
  read_matrix_only_fail
  matrix_call_correction
  matrix2flat
  confirm_array_array
  txt2xls
  confirm_2_file_line
  show_file_list
  make_removed_col_file
  get_count_from_interval
  get_count_between
  Find_file_from_list
  mv_png
  get_filename_from_path
  make_own_dir
  HugeMatrixTransform
  Is_DefaultFile
  show_hash_array
  hash_tab_limited_linux
  h
  WriteMatrixToFile
  ReadMatrixToArray
  read_matrix_list_col_sum
  read_matrix_list_row_sum
  h1c
  h1n
  v1n
  v1np
  v1n2f
  hist
  histf
  histogram
  histogram_tab
  celname
  celname_substitute_id
  get_date
  ToHash
  snpeff3_6 
  timediff
  Month2Num
  ThisYear
  ThreeMonthStr_Day2YMD
  geno2chisqure
  geno2prob
  VCF2BED_0
  VCF2BED_1
  aa_hash
  snpsift_anno_string_to_4Class
  oncotator_anno_string_to_4Class
  show_hash
  show_hash2
  show_matrix
  convert_hash2_to_hash1_by_delim
  Alt_Freq
  percent
  round
  GenoMatchType
  GenoMatchType_detail
  random
  DMR_make_cov_file
  fastq2id
  args2list
  read_matrix_list_num
  read_matrix_list_string
  isSNVType
  );

# #         			 max						### 최대
# #          			 min 						### 최소
# #          			 average 					### 평균
# #          			 max_num 					### 배열의 몇번째가 최대
# # 	 			 min_num					### 배열의 몇번째가 최소
# #          			 select_col_rm_redun 				### 해당 파일과 컬럼의 번호를 받아서 해당 컬럼의 리스트의 중복성을 제거함.
# #          			 array_redun_rm 				### 배열의 중복 제거
# #          			 compare_A_and_B_file				### 두개의 파일을 받아서 선택 컬럼의 데이터의 중복, unique 구해서 옵션선택으로 파일 만듬
# #          			 factorial					### 입력된 숫자의 factorial 을 구한다.
# # 				 upcase						### 대상과 시작 숫자를 넣으면 대문자화
# #          			 file_concatenate				### 여러개의 파일을 하나의 파일화
# #          			 file_divide_line_num				### 하나의 파일을 입력 갯수로 분할
# #          			 redun_line_rm					### 입력된 파일의 라인 중복을 제거
# #          			 selected_col_make_key_for_group 		### 입력된 파일에서 입력된 컬럼 리스트를 통해서 중복성을 제거하고, 마지막 인수 컬럼을 리스트화
# #          			 select_col_list_count				### 입력된 파일에서 선택된 컬럼의 총 리스트 갯수
# #          			 diff_array_a					### 두개의 배열 레퍼런스를 받아서 첫 번째 배열에서만 존재하는 리스트 반환
# #          			 common_array					### 두개의 배열 레퍼런스를 받아서 공통된 리스트 반환
# # 				 convert_file_format				### 입력된 파일의 컬럼 배열을 사용자에 의해 재 정렬
# #          			 extract_key					### 해쉬의 ref 받아서 해당 키를 배열로 리턴

# #          			 file_3_extract_info				### mother : 6개의 필수 인수, 1,3,6 : 파일명
# #          			 input_file_and_col				### 2,4,6 기준 커럼과 출력 컬럼 선택
# #          			 input_file_and_col_default			### 파일과 커럼을 인수로 넣으면 3개의 해쉬 생성
# #          			 rm_end_blank					### 배열을 받고 해당 인자들의 마지막 빈 공간 제거
# #          			 A_cols_B_cols_output				### A 파일에서 컬럼 리스트를 선택, B 파일에서 그에 해당하는 컬럼을 선택하고, 마지막 인수로서 출력 컬럼 리스트를 넣는다.
# #          			 read_msg					### message
# #          			 sum						### sum
# #          			 round_off					### 반올림 (숫자, 자릿수)
# #          			 rm_start_blank					### 배열을 받고 해당 인자들의 첫 앞의 공간 제거
# #          			 msg						### messag (file, read or write)
# #          			 Seq						### 원하는 길이의 서열을 만들기
# #          			 File2Array					### To Save the Array contents of File
# #          			 File2hash					### 인수(file, key column, value column) return hash
# #          			 Foreach					### 결과 확인을 위한 방법 hash
# #          			 Foreach_array					### 결과 확인을 위한 방법 array
# #           			 e						### 결과 확인
# #          			 make_dir					### 인수(폴더이름)
# #          			 Fasta_divide					### 인수(file, 파일당 들어갈 갯수, 해당 폴더) 로 파일 나누기
# #          			 copy_file					### 인수(file, 라인수)
# #          			 copy_file_FromTo				### 인수(file, start line num, end line num, filename)
# #          			 rm_end_input					### 인수(target scala, pattern)
# #          			 File_want_col_sort				### 인수(file, col) => 정렬되지 않은 파일 원하는 col 로 정렬
# #          			 Show_File					### 인수(path, filename) 해당 파일에 대한 내용 보여주기
# #           			 get_time					### 시간
# #           			 get_time_detail					### 시간 detail
# #           			 get_cpu_time					### 실행 시간
# #           			 Array2Hash					### array 를 hash 로 만들어 리턴
# #           			 log_base					### 밑이 10 이고 대상이 100 인것 log_base(100,10) == 2
# #          			 Array_div_odd_even_index			### 인수(array) index 번호를 홀수로 나누어서 결과는 두개의 array 레퍼런스 리턴
# #          			 Array_div_odd_even_element			### 인수(array) element를 홀수로 나누어서 결과는 두개의 array 레퍼런스 리턴
# #          			 cal_linker_length				### 인수(두개의 배열 레펀런스) 앞에가 시작, 뒤에게 끝 서로의 길이 차이를 배열로 리턴
# #          			 Array_start_double_howmany_tab			### 인수(시작하기원하는 위치배수,그룹으로 묶길 원하는요소 갯수, 대상배열)
# #          			 seq2fasta_form					### 인수(서열을 가지는 배열)
# #          			 Write_file					### 인수(내용을가지는 스칼라, 파일이름)
# #          			 calculate_promoter_between_gene		### 인수(A gene promoter start,A end, B start, B end) 두개의 겹치는 길이 리턴
# #          			 confirm_2					### 인수( 알고자 하는 해쉬) 이것은 변수가 2개인 해쉬
# #          			 confirm_3					### 인수( 알고자 하는 해쉬) 이것은 변수가 3개인 해쉬
# #          			 show_array					### 인수( 알고자 하는 이중배열) 변수가 2개인 배열
# # 				 comma_count					### 인수( 콤마로 구분된 리스트 파일)
# #          			 change_xy					### 인수( 파일,결과파일이름) 파일의 컬럼과 로우를 바꿔준다.
# #          			 Key_value					### 인수( 파일, 하나의 컬럼, 하나의 값) 해쉬 리턴
# #          			 getFileExtension 				### 인수( 파일 ) 해당 파일의 확장자 리턴
# #          			 make_hash_from_file				### 인수( 파일 ) 파일의 라인을 해쉬화 해서 리턴
# #				 Chage						### 인수( 파일 )
# #				 getfilename					### 인수( 파일이름 ) 이름만 리턴
# #          			 read_matrix					### 인수( 파일이름) 매트릭스된 해쉬 리턴
# # 				 make_col_function				### hash_tab_limited 에서 사용
# # 				 hash_tab_limited				### 인수( 파일이름, 키 컬럼, 값컬럼 )
# # 				 hash_tab_limited_cnt				### 인수( 파일이름, 키 컬럼) return couting hash
# # 				 extract_want_col_from_f			### 인수( 파일이름, 추출하고 싶은 컬럼 리스트)
# # 				 Merge						### 인수( title line(num), 결과파이름, merge 할 파일 리스트)
# # 				 Merge_custom					### 인수( dir 이름, title line(num), 파일)		첫 파일의 헤드만 가져온다
# # 				 DB_query					### 인수( $dbh(접속),$query(query 문))
# # 				 fasta_f_read					### 인수( $file ) 하나의 서열을 가지는 파일
# # 				 Input_STDIN_f					### 인수(message) file return
# # 				 Input_STDIN_t					### 인수(message) text return
# # 				 complementary					### 인수(서열) 상보적으로 바꿘 서열 리턴
# # 				 trim_space					### 인수($)마지막 공백 제거
# # 				 IUPAC						### 인수(a/g) snp 받아서 iupac code 로 변환
# # 				 fasta2hash					### 인수(파일) 여러개의 서열을 가진 파스타 파일을 키:이름 값:seq 인 해쉬리턴
# # 				 mssql_connect					### mssql 에 접속
# # 				 DB_query					### 인수($dbh,커리) 결과 리턴
# # 				 divide_size					### 인수($, size) 사이즈로 잘린 길이의 배열리턴
# # 				 show_column_sample_from_file			### 인수(파일, 구분자) 파일을 임시로 보여준다
# # 				 csv_file_handle_key_value			### 인수(csv 파일, 키,값,옵션) 옵션 1--> 파일 만들기 없으면 해쉬 리턴
# # 				 Foreach_hash2file				### 인수 (파일이름,hash(1)) hash -> 파일로 만들기
# # 				 make_2_hash					### %db = make_db_hash(파일,첫키"2",두번째키"4,5",value"1") 해쉬리턴
# # 				 make_2_hash_cnt				### %db = make_db_hash(파일,첫키"2",두번째키"4,5") counting 해쉬리턴
# # 				 make_3_hash					### %db = make_db_hash(파일,첫키"2",두번째키"4,5",세번째키"6,7",value"1") 해쉬리턴  option = 'all' 은 라인 전체를 값으로 받음
# # 				 make_array_with_delimit			### 인수($,delimit 문자)  ex ("a-b-c","-") 리턴 배열
# # 				 confirm_2_file					### 인수(파일이름,%) 두개키 가진 해쉬를 파일로
# #  				 confirm_3_file					### 인수(파일이름,%) 세개키 가진 해쉬를 파일로
# # 				 make_matrix_file				### 인수(title hash, file name, matrix data hash) 파일 생성
# # 				 make_matrix_file_new				### 인수(파일이름, matrix hash)
# # 				 sam_count_delimit_coma				### 인수(%) 해쉬의 전체 값들은 ','로 구분되는데 이들읠 갯수(값들의 개수)를 리턴
# # 				 make_reverse_hash				### 인수(%) 키=특정이름, 값=(num)점수를 대상으로 하여 key=num(점수), 값=특정 이름로 바꾸어준다.
# #				 make_call_matrix				### 인수(파일,snpid column, sample column, call column) 해쉬 리턴
# # 				 File_line_check				### 인수(파일) 파일의 라인 수를 보여준다
# # 				 csv2txt					### 인수(파일) csv 파일 --> txt 파일로 변환
# # 				 show_array_array				### 인수(array 의 array)
# # 				 select_col_id_cnt				### 인수(파일,컬럼리스트) 선택된 컬럼에서 각각 string 이 몇개씩 나오는지 파일과 hash 리턴
# # 				 select_two_col_id_cnt				### 인수(파일,fir key list, sec key list) 파일 and hash 리턴
# # 				 key_cnt					### 인수(%) print key 갯수
# # 				 select_col_count				### 인수(파일, 컬럼 위치) 해당 컬럼의 아이디의 unique 카운트
# # 				 get_name					### 인수(파일) 해당 파일의 이름 리턴
# # 				 matrix_call_num2AB				### 인수(matrix 파일, 새로운결과파일이름)
# # 				 sample_random_selection			### 인수(선택 숫자, @리스트) $ return
# # 				 get_string_from_seq				### 인수($seq, $window_size, $sliding_size,$start,$end,$마커) 파스타 $ 리턴
# # 				 dp_f_info					### 인수($file, skip line)
# # 				 perl_script					### perl scipt information
# # 				 remote_test					### 인수(ip,timeout-num)
# # 				 get_element					### 인수($,구분자,몇번쨰 number) 만약 해당 구분자가 특수변수이면 \ 를 붙여준다
# # 				 convert_line					### 인수(@바꿀 표현형과 대상자(["",""],["",""]),@string)
# # 				 Array2File					### 인수(@, 파일이름)
# # 				 matrix_call_correction				### 인수(보정될 부분을 가지는 파일, 전체 매트릭스 파일)
# # 				 compare_two_matrix				### 인수(파일,파일) 두개의 파일은 매트릭스 파일이여야 한다. 다른 내용을 가진 내용 파일로 리턴
# # 				 read_matrix_qurated				### 인수(파일, 해쉬레퍼런스) 매트릭스 파일, 고쳐져야할 해쉬의 레퍼런스, 해쉬 리턴
# # 				 read_matrix_only_fail				### 인수(파일) 성별 이상의 매트릭스 파일에서 hetero call 1 만 저장해서 해쉬 리턴
# # 				 matrix2flat					### 매트릭스 파일을 sample marker call 형태로 바꿈 타이틀이 마커임 인수(파일)
# # 				 confirm_array_array				### 인수 @[][] 를 확인하기 위한 것
# # 				 txt2xls					### 인수(txt file, xls file) 확장자를 꼭 써준다.
# # 				 confirm_2_file_line				### 인수(결과파일이름, title reference array, hash) 파일 생성
# # 				 show_file_list					### 인수( 리스트 )
# # 				 make_removed_col_file				### 인수(파일,컬럼리스트) 해당 컬럼만 제거된 파일 작성
# # 				 get_count_from_interval			### 인수(
# # 				 get_count_between				### 인수
# # 				 Find_file_from_list				### 인수(찾을 파일 리스트 ref, 파일 리스트 ref)
# # 				 mv_png						### 인수(찾을 파일 리스트 ref, 파일 리스트 ref)
# # 				 get_filename_from_path				### 인수(전체경로를 가진 파일리스트 파일);
# # 				 make_own_dir					### 인수 없음. 해당 파일이름 리턴
# # 				 HugeMatrixTransform				### 인수(transformed(created) file name, read file name)
# # 				 Is_DefaultFile					### 인수(defaulted file name)
# # 				 show_hash_array				### 인수( hash array )

sub average {
    my $total;
    my (@list) = @_;
    foreach my $sum (@list) {
        $total += $sum;
    }

    #print "$total/($#_+1)";
    return $total / ( $#_ + 1 );
}

sub Stdev {
    my ( $avg, @list ) = @_;
    my $sum;
    foreach my $value (@list) {
        $sum += ( $value - $avg )**2;
    }
    return $sum / ( $#list + 1 );
}

sub max_num    ## 배열에서 가장 최대값과 몇번쨰인지 알수 있음.
{
    my ( $max, @array ) = @_;
    my $cnt++;
    my $max_num = $cnt;

    foreach my $i (@array) {
        $cnt++;
        if ( $max < $i ) {
            $max_num = $cnt;
            $max     = $i;
        }
    }

    return ( $max, $max_num );
}

sub min_num    ## 배열에서 가장 최대값과 몇번쨰인지 알수 있음.
{
    my ( $min, @array ) = @_;
    my $cnt++;
    my $min_num = $cnt;

    foreach my $i (@array) {
        $cnt++;
        if ( $min > $i ) {
            $min_num = $cnt;
            $min     = $i;
        }
    }

    return ( $min, $min_num );
}

## 해당 파일과 컬럼의 번호를 받아서 해당 컬럼의 리스트의 중복성을 제거함.
sub select_col_rm_redun {
    print "start col 1 부터\n구분자는 ','\n";

    my ( $file, $col_num ) = @_;
    $col_num--;

    open( F, $file )           || die "$!";
    open( W, ">output-$file" ) || die $!;
    while ( chomp( my $l = <F> ) ) {
        my @pt = split "	", $l;
        my $target = $pt[$col_num];

        my %hash = ();
        my @tmp = split ",", $target;
        foreach my $i (@tmp) {
            $hash{$i}++;
        }

        $replace = join ",", keys %hash;

        $l =~ s/$target/$replace/;

        print W "$l\n";
    }
}

## 배열의 중복 제거
sub array_redun_rm {
    my @array = @_;
    my %hash;

    foreach my $i (@array) {
        $hash{$i}++;
    }
    @array = sort ( keys %hash );
    return (@array);
}

sub compare_A_and_B_file {
    print
"파일 A 와 B를 비교합니다. 이는 A 와 B 의 컬럼을 선택함으로서 선택 컬럼의 데이터의 교집합과 차이의 갯수를 확인 가능하고 또한 마지막 인수가 존재하면 그러한 데이터를 파일로 만든다. 파일 용량이 적당히 작을때 좋음\n";
    my ( $file_A, $col_A, $file_B, $col_B, $file_flag ) = @_
      ; ### ("A.txt","1,2,3","B.txt","2,3,4",파일 만들기 옵션 선택) 마지막 인수는 1 : 교집합 내용만 2 : A 에만 있는 내용 3 : B 에만 있는 내용

    my %hash = ( 1 => "common.txt", 2 => "only_$file_A", 3 => "only_$file_B" );
    my %output = ( 1 => "공통 부분", 2 => "$file_A 내용", 3 => "$file_B 내용" );
    my %wr     = ( 1 => "C",         2 => "A",            3 => "B" );
    my $W;

    if ($file_flag) {
        print "파일 만들기 선택 내용 : $output{$file_flag}\n";
        $W = $wr{$file_flag};
        open $W, ">$hash{$file_flag}";
    }

    my ( $cnt_A, $cnt_B );
    my ( %A,     %B );
    $col_A =~ s/\s+//g;
    $col_B =~ s/\s+//g;
    my @A_col_list = split ",", $col_A;
    my @B_col_list = split ",", $col_B;

    open F, $file_A;
    while ( chomp( my $l = <F> ) ) {
        my @pt = split "	", $l;
        my $key;
        foreach my $i (@A_col_list) {
            $pt[ $i - 1 ] =~ s/\s+$//;
            $key .= "$pt[$i-1]	";
        }
        push @{ $A{$key} }, $l;
        $cnt_A++;    ## file A 에 대한 라인의 갯수
    }
    close F;

    open F, $file_B;
    while ( chomp( my $l = <F> ) ) {
        my @pt = split "	", $l;
        my $key;
        foreach my $i (@B_col_list) {
            $pt[ $i - 1 ] =~ s/\s+$//;
            $key .= "$pt[$i-1]	";
        }
        push @{ $B{$key} }, $l;
        $cnt_B++;    ## file B 에 대한 라인의 갯수
    }
    close F;

    my ( $common, $only_A, $only_B );
    foreach my $i ( keys %A ) {
        if ( $B{$i} ) {
            $common++;    ## 공통된 거 갯수
            if ( $W eq "C" ) {
                print $W "$i\n";    ## A,B 공통으로 있는거 라인 파일 만들기
            }
        }
        else {
            $only_A++;              ## A 에만 있는 거 갯수
            if ( $W eq "A" ) {
                foreach my $j ( sort @{ $A{$i} } ) {
                    print $W "$j\n";    ## A 에만 잇는거 라인 파일 만들기
                }
            }
        }
    }

    foreach my $i ( keys %B ) {
        if ( $A{$i} ) {
            next;
        }
        else {
            $only_B++;
            if ( $W eq "B" ) {
                foreach my $j ( sort @{ $B{$i} } ) {
                    print $W "$j\n";    ## A 에만 잇는거 라인 파일 만들기
                }
            }
        }
    }

    print "---------------------------------------------------------------\n";
    print "$file_A line : $cnt_A	only line : $only_A\n";
    print "$file_B line : $cnt_B	only line : $only_B\n";
    print "---------------------------------------------------------------\n";
    print "common line : $common\n";

}

sub factorial {
    my ($num) = @_;
    my $score = 1;
    if ( $num =~ /\d+/ ) {
        foreach my $i ( 1 .. $num ) {
            $score *= $i;
        }
    }
    elsif ( $num == 0 ) {
        $score = 1;
    }
    else {
        die "No num $!\n";
    }
    return $score;
}

sub Upcase {
    my ( $target, $num ) = @_;
    $target =~ s/^(\w{$num})/\U$1/;
    return $target;
}

sub file_concatenate {
    my (@file_list) = @_;
    my ( $F, $W ) = ( 'F', 'W' );

    open( $W, ">concatenate_result.txt" ) || die $!;
    foreach my $i ( sort { $a <=> $b } @file_list ) {
        print "$i file read\n";
        open( $F, $i ) || die $!;
        while ( $l = <F> ) {
            print $W "$l";
        }
        close $F;
    }
    close $W;
}

sub file_divide_line_num {
    my ( $file, $count ) = @_;    #파일 이름, 몇개로 나눌지)
    my $F = "F";

    foreach my $i ( 1 .. $count ) {
        my $W = "W$i";
        open $W, ">$i-$file";
    }

    open $F, $file;
    my @all_line = <$F>;
    close $F;

    my $how_much_line;
    if ( ( $#all_line + 1 ) % $count ) {
        $how_much_line = int( ( $#all_line + 1 ) / $count ) + 1;
    }
    else {
        $how_much_line = int( ( $#all_line + 1 ) / $count );
    }

    foreach my $i ( 1 .. $count ) {
        $W = "W$i";
        my $out = join "", splice( @all_line, 0, $how_much_line );
        print $W "$out";
        close $W;
    }
}

sub redun_line_rm {
    my ($file) = @_;
    my ( $F, $W ) = ( "F", "W" );
    my %temp;
    my $cnt;

    open $F, $file;
    while ( chomp( $l = <F> ) ) {
        $temp{$l}++;
    }
    close $F;

    open $W, ">redun_line_rm-$file";
    foreach my $i ( keys %temp ) {
        print $W "$i\n";
        if ( $temp{$i} >= 2 ) {
            $cnt++;
        }
    }
    close $W;
    print "중복된 라인은 제거하였으며, 중복된 것은 총 $cnt개 \n";
}

sub selected_col_make_key_for_group
{ ## 해당 파일의 컬럼을 선택해서 중복성을 알아보고 원하는컬럼을 선택해서 출력할수 있는 함수

# 	selected_col_make_key_for_group("knownGene.txt","2,3,4,5","1");
# 	sub_routine("해당파일", " ','로 구분된 컬럼 번호", "마지막으로 추가될 컬럼이며, 리스트 컬럼")

    my ( $file, $select_col, $out_form_col ) = @_;
    my ( $F, $W ) = ( "F", "W" );

    my @select = split ",", $select_col;
    my @keys;

    foreach my $i (@select) {
        push @keys, '$_[' . ( $i - 1 ) . ']';
    }
    my $key = join "	", @keys;

    my $key_code = 'if(@_){return "' . $key . '";}';

    my $sub_key = eval "sub { $key_code }";
    print "$key	$key_code\n";

    my %temp;
    my ( $cnt, $group );

    open $F, $file;
    while ( chomp( my $l = <F> ) ) {
        my @pt = split "	", $l;
        my $k = &$sub_key(@pt);

        $temp{$k}->{ $pt[ $out_form_col - 1 ] }++;    ## 해쉬의 해쉬
    }
    close $F;

    open $W, ">selected_col_make_key_for_group-$file";
    foreach my $i ( sort { $a cmp $b } keys %temp ) {
        $group++;
        my $imsi  = $temp{$i};
        my @array = sort { $a cmp $b } keys %{$imsi};
        my $scala = join ",", @array;
        print $W "group_$group	$i	$scala\n";
    }
    close $W;
}

sub select_col_list_count
## 파일의컬럼을 선택하고, 그 해당 컬럼의 리스트의 총합을 구한다.
## select_col_list_count("certain_miRNA-cluster.txt",6,",");
{

    my ( $file, $selected_col, $delimit ) = @_;
    my $total_count;
    my %hash;
    open F, $file;
    while ( chomp( my $l = <F> ) ) {
        my @pt = split "	", $l;

        map { $hash{$_}++ } ( split "$delimit", $pt[ $selected_col - 1 ] );
    }
    my @key   = keys %hash;
    my $value = $#key + 1;
    return $value;
}

sub diff_array_a    ## 두 배열의 레퍼런스를 받아서 a 배열에만 있는 리스트를 리턴
{
    my ( $a, $b ) = @_;
    my ( %hash, @remain_a );
    foreach my $i (@$b) {
        $hash{$i}++;
    }
    foreach my $i (@$a) {
        if ( !$hash{$i} ) {
            push @remain_a, $i;
        }
    }
    return @remain_a;
}

sub common_array    ## 두 개의 배열 ref 받아서 공통된 리스트를 반환
{
    my ( $a, $b ) = @_;
    my ( %hash, @common );
    foreach my $i (@$b) {
        $hash{$i}++;
    }
    foreach my $i (@$a) {
        if ( $hash{$i} ) {
            push @common, $i;
        }
    }
    return @common;
}

sub convert_file_format
## 해당 파일의 컬럼의 위치를 원하는 형태로 컬럼을 재배열을 한다.
## convert_file_format("파일",
## "원본의 컬럼을 1,2,3,4 라 할때 여기의 인수는 4,2,1,3 이라고 적었다면 이대로 형태로 변환 하지만 전체 컬럼의 숫자만큼 쓰지 않는다면 컬럼 숫자가 없는 것은 내용이 누락된다",
## "sort 하기 원하는 컬럼에 문자는 'chr 2' 숫자는 'num 2' 형태로 적으면 된다 "
## "여기 인수 'T'를 주면 앞의 원하는 컬럼을 만들고 나머지는 순서대로 다 붙는다"
# Usage : convert_file_format("certain_miRNA-cluster.txt","2,3","num 2","T", "result.txt");
{
    #### input handle ####
    my ( $file, $arrange_col, $sort_col, $remain, $result_file ) = @_;
    %sort_kind = ( 'chr' => 'cmp', 'num' => '<=>' );
    if ( !$result_file ) { $result_file = "convert_file_format.txt"; }

    my ( $sort_kind, $col );
    if ( $sort_col =~ /^((?:chr|num))\s+(\d+)/ ) {
        ( $sort_kind_symbol, $col ) = ( $sort_kind{$1}, $2 );
    }
    else { die "해당 sort 컬럼의 chr or num 과 컬럼 번호를 확인하세요\n"; }

    #### excute ####
    my ( $F, $W ) = ( "F", "W" );
    my @new_order = split ",", $arrange_col;
    my %hash;

    open( $F, $file ) || die $!;
    while ( chomp( $l = <$F> ) ) {
        my @pt = split "	", $l;
        my @temp;

        foreach my $i (@new_order) {
            push @temp, $pt[ $i - 1 ];
        }

        my $new_l = join "	", @temp;
        if ($remain) {
            my $remain = join "	", diff_array_a( \@pt, \@temp );
            $new_l .= "	$remain";
        }

        $hash{ $pt[ $col - 1 ] } .= "$new_l\n";
    }
    close $F;

    #### anymous sub start ####
    my $code = 'my %hash = @_;
	 my @lines;
	 foreach my $i(sort {$a ' . $sort_kind_symbol . ' $b} keys %hash)
	 {
		 push @lines,$hash{$i};
	 }
	 return @lines;
	';

    #  	print "$code\n"; #작성된 코드를 볼수 있다
    #### anymous sub end ####

    $sub = eval "sub { $code }";
    my $out = join "", &$sub(%hash);

    open $W, ">$result_file";
    print $W "$out\n";
    close $W;
}

sub extract_key_cmp    ## input hash의 ref 받음
{
    my ($hash) = @_;
    my @value;

    foreach my $i ( sort { $a cmp $b } keys %{$hash} ) {
        push @value, $i;
    }

    return @value;
}

sub extract_key_num    ## input hash의 ref 받음
{
    my ($hash) = @_;
    my @value;

    foreach my $i ( sort { $a <=> $b } keys %{$hash} ) {
        push @value, $i;
    }

    return @value;
}

sub input_file_and_col_default {

    # mother :sub file_3_extract_info
    my ( $f_1, $sel_col ) = @_;

    $sel_col =~ /\s+/;

    my @f_2_sel_col = map { '$_[' . ( $_ - 1 ) . ']' } ( split ",", $` ); ## 1,2
    my @f_3_sel_col = map { '$_[' . ( $_ - 1 ) . ']' } ( split ",", $' ); ## 3,4

    my $f_2_code = '"' . ( join "	", @f_2_sel_col ) . '"';
    my $f_3_code = '"' . ( join "	", @f_3_sel_col ) . '"';

    $sub_f2 = eval " sub { return $f_2_code; } ";
    $sub_f3 = eval " sub { return $f_3_code; } ";

    my ( %f1, %f2, %f3 );
    open F, $f_1;    ### f_1 file handle
    while ( chomp( $l = <F> ) ) {
        my @pt = split "	", $l;
        rm_end_blank(@pt);

        push @{ $f1{ &$sub_f2(@pt) } }, &$sub_f3(@pt);
        $f2{ &$sub_f2(@pt) }++;
        $f3{ &$sub_f3(@pt) }++;
    }
    close F;
    return ( \%f2, \%f3, \%f1 );
}

sub input_file_and_col {

    # mother :sub file_3_extract_info
    my ( $f_2, $col_2, $hash ) = @_;
    my %f = %{$hash};

    $col_2 =~ /\s+/;
    my @f_1_standard_posi =
      map { '$_[' . ( $_ - 1 ) . ']' } ( split ",", $` );    ## 1,2
    my @f_1_output_posi =
      map { '$_[' . ( $_ - 1 ) . ']' } ( split ",", $' );    ## 1,2

    $f_2_code = '"' . ( join "	", @f_1_standard_posi ) . '"';
    $f_3_code = '"' . ( join "	", @f_1_output_posi ) . '"';

    $sub_f2 = eval " sub { return $f_2_code; } ";
    $sub_f3 = eval " sub { return $f_3_code; } ";

    my %output;
    open F, $f_2;
    while ( chomp( $l = <F> ) )                              ### f_2 file handle
    {
        my @pt = split "	", $l;
        if ( $f{ &$sub_f2(@pt) } ) {
            $output{ &$sub_f2(@pt) } = &$sub_f3(@pt);        ## output hash

            # 			print &$sub_f2(@pt)."	".&$sub_f3(@pt)."\n";
        }
    }
    close F;
    return \%output;
}

sub file_3_extract_info    ### 3 개 파일을 인수로 받는다

  # daughter : sub input_file_and_col
  # daughter : sub input_file_and_col_default
{
    my ( $f_1, $sel_col, $f_2, $col_2, $f_3, $col_3 ) = @_;
    ## $f_1 파일 , $sel_col 두개의 컬럼 리스트를 선택 ex) "1,2 3,4"
    ## $f_2 파일 , $col_2 위의 1,2 값에 해당되는 값을 얻어오기 위해서 컬럼 번호 선택 ex) "2,3,4,7"
    ## $f_3 파일 , $col_3 위의 3,4 값에 해당되는 값을 얻어온다.위해서 컬럼 번호 선택 ex) "2,3,4,7"

    my ( $f2, $f3, $f1 ) = input_file_and_col_default( $f_1, $sel_col )
      ;    ## 3개의 해쉬 ref 를 리턴 받음 키는 선택된 컬럼 값은 ++
    my $output_f_2 = input_file_and_col( $f_2, $col_2, $f2 );
    my $output_f_3 =
      input_file_and_col( $f_3, $col_3, $f3 );   ## 하나의 해쉬 ref 를 리턴 받음

    open W, ">file_3_extract_info-$f_1";
    foreach my $i ( extract_key( \%{$f1} ) ) {
        foreach my $j ( @{ ${$f1}{$i} } ) {
            my ( $first, $second ) = ( $i, $j );
            print W "$i	${$output_f_2}{$i}	$j	${$output_f_3}{$j}\n";

        }
    }
    close W;
}

sub rm_end_blank {
    return map { $_ =~ s/\s+$// } @_;
}

sub A_cols_B_cols_output
### A 파일에서 컬럼 리스트를 선택, B 파일에서 그에 해당하는 컬럼을 선택하고, 마지막 인수로서 출력 컬럼 리스트를 넣는다.
### Usage : A_cols_B_cols_output ("file_3_extract_info-common.txt", "6,7", "knownGene_new.txt", "1,2", "1,2,3,4,5,6", "result.txt");
{
    my ( $A, $A_cols, $B, $B_cols, $out_form_cols, $result_file ) = @_;
    if ( !$result_file ) { $result_file = "A_cols_B_cols_output.txt"; }

    my @cols = ( '$A_cols', '$B_cols', '$out_form_cols' );
    foreach my $i (@cols) {
        $i =~ /\$(.+)_cols/;
        $select = $1;

        my $value = eval " $i ";
        my @column_list =
          map { '$_[' . ( $_ - 1 ) . ']' } ( split ",", $value );
        my $code = 'return "' . ( join "	", @column_list ) . '";';

        ${ "sub_" . $select . "_code" } =
          eval " sub { $code } ";  ## $sub_A_code, $sub_B_code, $sub_output_code
    }

    my %query;
    open( F, $A ) || die $!;
    while ( chomp( $l = <F> ) ) {
        @pt = split "	", $l;

        # 		@pt = rm_end_blank ( @pt );
        $query{ &$sub_A_code(@pt) }++;
    }
    close F;

    open( F, $B ) || die $!;
    open( W, ">$result_file" ) || die $!;
    while ( chomp( $l = <F> ) ) {
        @pt = split "	", $l;
        if ( $query{ &$sub_B_code(@pt) } ) {
            print W &$sub_out_form_code(@pt), "\n";
        }
    }
    close F;
    close W;

}

sub read_msg {
    my ($msg) = shift;
    print "#########################################################\n";
    print "read the file $msg complete\n";
    print "#########################################################\n\n";
}

sub round_off {
    my ( $num, $cut ) = @_;
    my ( $int, $sosu );
    my $a     = "0." . "0" x $cut . "5";
    my $value = $num + $a;
    while ($value) {
        if ( $value !~ /\.(\d{$cut})/ ) {
            $cut--;
        }
        elsif ( $value =~ /\.(\d{$cut})/ ) {
            ( $int, $sosu ) = ( $`, $& );
            last;
        }
    }
    return ( $int + $sosu );
}

sub rm_start_blank {
    return map { $_ =~ s/^\s+// } @_;
}

sub msg {
    my ( $file, $msg ) = @_;
    print "#########################################################\n";
    print "$msg the file $file complete\n";
    print "#########################################################\n\n";
}

sub Seq {
    my ( $end_num, $start_num ) = @_;
    my @a = @base = qw(A C G T);
    open W, ">$start_num-$end_num-seq.txt";
    while ( $end_num > 1 ) {
        my @b;
        my $cnt;
        foreach $i (@a) {
            foreach $j (@base) {
                $b[$cnt] = $i . $j;
                $cnt++;
            }

        }

        if ( length $b[0] >= $start_num ) {
            $result = join "\n", @b;
            print W "$result\n";
        }

        @a = @b;
        $end_num--;
    }
    close W;
}

sub File2Array {
    open my $F, $_[0] or die "$! not exist $_[0]\n";
    my @Array = <$F>;
    close $F;

    map { $_ =~ s/\n// } (@Array);
    return @Array;
}

sub File2hash {
    my ( $file, $col_key, $col_value ) = @_;

    if ( !$file || !$col_key ) { die "No input File and key column!"; }

    my @value = map { '$_[' . ( $_ - 1 ) . ']' } ( split /,/, $col_value );
    my $code = 'return "' . ( join "	", @value ) . '";';
    print "code : $code\n\n";
    my $sub = eval "sub { $code }";

    my @content = File2Array($file);
    my %hash;
    my $cnt;

    foreach my $i (@content) {
        chomp($i);
        $cnt++;
        my @pt = split /\t/, $i;

        if ($col_value) {
            my $sub_value = &$sub(@pt);
            $hash{ $pt[ $col_key - 1 ] } .= "$sub_value,";
        }
        elsif ( !$col_value ) {
            $hash{ $pt[ $col_key - 1 ] } = $cnt;
        }
    }
    return %hash;
}

sub Foreach_hash {
    my %hash = @_;

    foreach ( sort { $a <=> $b } keys %hash ) {
        print "$_	$hash{$_}\n";
    }
}

sub Foreach_array {
    foreach (@_) {
        print "$_\n";
    }
}

sub e {
    print STDERR "$_[0]\n";
}

sub make_dir {
    my ($exist) = ( shift || die "dir do not exist!\n" );

    unless ( -d $exist ) {
        mkdir($exist);
    }
}

sub Fasta_divide {
    my ($file)   = ( shift || die "File argument error!\n" );
    my ($num)    = ( shift || die "Num argument error!\n" );
    my ($folder) = ( shift || "Fasta_divide" );
    make_dir($folder);

    my $cnt        = 0;
    my $handle_cnt = 0;
    my $handle;

    open( FASTA_FILE, $file ) || die $!;
    while ( chomp( my $l = <FASTA_FILE> ) ) {
        if ( $l =~ />/ ) {
            if ( $cnt % $num == 0 ) {

                #print "$l\n";
                $handle_cnt++;
                $handle = "FASTA_FILE_W_$handle_cnt";
                close $handle;
                open( $handle, ">$folder/Fasta_$handle_cnt.txt" ) || die $!;
            }
            $cnt++;

            print $handle "$l\n";
        }
        elsif ( $l =~ /^\w+/ ) {
            print $handle "$l\n";
        }
    }
    close FASTA_FILE;
    close $handle;

}

sub copy_file {
    my ($file) = ( shift || die "File argument error!\n" );
    my ($line) = ( shift || die "Line argument error!\n" );
    my $cnt;
    my $result;

    open( COPY_FILE,   $file )         || die $!;
    open( COPY_FILE_W, ">$file.copy" ) || die $!;
    while ( chomp( my $l = <COPY_FILE> ) ) {
        $cnt++;
        if ( $cnt <= $line ) {
            print COPY_FILE_W $l, "\n";
        }
        else {
            last;
        }
    }
    close COPY_FILE;
    close COPY_FILE_W;
}

sub copy_file_FromTo {
    my ($file)  = ( shift || die "File argument error!\n" );
    my ($start) = ( shift || die "start Line argument error!\n" );
    my ($end)   = ( shift || die "end Line argument error!\n" );
    my ($name)  = ( shift || die "filename argument error!\n" );
    my $cnt;
    my $result;

    open( COPY_FILE,   $file )        || die $!;
    open( COPY_FILE_W, ">$name.txt" ) || die $!;
    while ( chomp( my $l = <COPY_FILE> ) ) {
        $cnt++;
        if ( $cnt >= $start && $cnt <= $end ) {
            print COPY_FILE_W $l, "\n";
        }
        elsif ( $cnt > $end ) { last; }
    }
    close COPY_FILE;
    close COPY_FILE_W;
}

sub rm_end_input {
    my ($target)  = ( shift || die "No insert Target\n" );
    my ($pattern) = ( shift || die "No insert pattern\n" );

    $target =~ s/$pattern$//;
    return $target;
}

sub File_want_col_sort    ### 대상 파일의 원하는 컬럼을 기준으로 다시 정렬
{
    my ($file) = ( shift || die "Target File insert~!\n" );
    my ($col)  = ( shift || die "Target column insert~!\n" );
    my ( %M, @pt );

    open( FILE_WANT_COL_SORT, $file ) || die $!;
    while ( chomp( my $l = <FILE_WANT_COL_SORT> ) ) {
        @pt = split /\t/, $l;
        push @{ $M{ $pt[ $col - 1 ] } }, $l;
    }
    close FILE_WANT_COL_SORT;

    return (%M);

    ### example ###

    # # %M = File_want_col_sort("sam.txt",1);

    # # foreach my $i (sort {$a <=> $b} keys %M)
    # # {
    # #
    # # 	foreach my $j ( @{$M{$i}} )
    # # 	{
    # # 		print "$j\n";
    # # 	}
    # # }
    ### example ###
}

sub Show_File {
    my ($path) = ( shift || die "input path error\n" );
    my ($file) = ( shift || die "input file name error\n" );

    foreach $i ( File2Array("$path/$file") ) {
        print "$i\n";
    }
}

sub get_time {
    my ( $sec, $min, $hour, $day, $mon, $year, $wday, $yday, $isdst ) =
      localtime(time);
    $year += 1900;    ## 1900 년 기준
    $day = "0" . $day if $day < 10;
    $mon++;
    $mon = "0$mon" if $mon < 10;
    return "$year-$mon-$day-$sec";
}

sub get_time_detail {
    my ( $sec, $min, $hour, $day, $mon, $year, $wday, $yday, $isdst ) =
      localtime(time);
    $year += 1900;    ## 1900 년 기준
    $day = "0" . $day if $day < 10;
    $mon++;
    $mon = "0$mon" if $mon < 10;
    return "$year$mon$day $hour:$min:$sec";
}

sub get_cpu_time {
    $start = (times)[0];
    foreach $i ( 0 .. 1000000 ) {
        $a = $i;
    }
    $end = (times)[0];
    printf "that took %.2f CPU seconds\n", $end - $start;
}

sub Array2Hash {
    ### desc ###
    ### array 를 hash 로 만들어 리턴
    my %hash;
    map { $hash{$_}++ } @_;
    return %hash;
}

sub log_base {
    my ( $target, $base ) = @_;
    return log($target) / log($base);
}

sub Array_div_odd_even_index {
    my ( @odd, @even );
    foreach my $i ( 0 .. $#_ ) {
        if ( $i % 2 == 0 ) {
            push @even, $_[$i];
        }
        else {
            push @odd, $_[$i];
        }
    }
    return ( \@even, \@odd );
}

sub Array_div_odd_even_element {
    my ( @odd, @even );
    foreach my $i ( 0 .. $#_ ) {
        if ( $_[$i] % 2 == 0 ) {
            push @even, $_[$i];
        }
        else {
            push @odd, $_[$i];
        }
    }
    return ( \@even, \@odd );
}

sub cal_linker_length {
    my ( $start, $end ) = @_;
    my @result;

    foreach my $i ( 1 .. $#$start ) {
        push @result, $$start[$i] - $$end[ $i - 1 ];
    }
    return @result;
}

sub Array_start_double_howmany_tab {
    my ( $start_double, $howmany, @target ) = @_;
    my $target_cnt = @target;

    #print "$start_double	$howmany	$target_cnt\n";

    my @result;
    my $cnt = 0;
    while ( $start_double * $cnt + $howmany - 1 <= $target_cnt ) {

        my @temp =
          @target[ $start_double * $cnt .. $start_double * $cnt +
          $howmany -
          1 ];

        #print "@temp\n";
        my $tmp = @temp;
        if ( $tmp == $howmany ) {
            push @result, join "	", @temp;
        }
        $cnt++;
    }
    return @result;
}

sub seq2fasta_form {
    my ( $line, $cnt );
    foreach my $i (@_) {
        chomp($i);
        $cnt++;
        $line .= ">$cnt\n$i\n";
    }
    return $line;
}

sub Write_file {
    my ($content)   = ( shift || die "No content\n" );
    my ($file_name) = ( shift || die "No filename\n" );

    open my $W, ">$file_name.txt" or die $!;
    print $W "$content";
    close $W;
}

sub calculate_promoter_between_gene {
    my ( $as, $ae, $bs, $be ) = @_;

    #print "$as,$ae,$bs,$be\n";
    my $length;

    if ( $as == $bs && $ae == $be ) {

        #$length = $ae-$as+1;		## same position -1 return
    }
    elsif ( $as > $bs && $as > $be ) {
        $length = 0;

        #print "bs out be out left\n";
    }
    elsif ( $as > $bs && $as <= $be && $ae > $be ) {
        $length = $be - $as + 1;

        #print "bs out left be in\n";
    }
    elsif ( $as <= $bs && $as <= $be && $ae > $bs && $ae > $be ) {
        $length = $be - $bs + 1;

        #print "bs in be in\n";
    }
    elsif ( $as <= $bs && $as <= $be && $ae > $bs && $ae <= $be ) {
        $length = $ae - $bs + 1;

        #print "bs in be out right\n";
    }
    elsif ( $as <= $bs && $as <= $be && $ae <= $bs && $ae <= $be ) {
        $length = 0;

        #print "bs out be out right\n";
    }
    return $length;
}

sub confirm_2 {
    my %tmp = @_;
    foreach my $i ( sort { $a cmp $b } keys %tmp ) {
        foreach my $j ( sort { $a cmp $b } keys %{ $tmp{$i} } ) {
            print "$i	$j	$tmp{$i}{$j}\n";
        }
    }
}

sub confirm_3 {
    my %tmp = @_;
    foreach my $i ( sort { $a cmp $b } keys %tmp ) {
        foreach my $j ( sort { $a cmp $b } keys %{ $tmp{$i} } ) {
            foreach my $k ( sort { $a cmp $b } keys %{ $tmp{$i}{$j} } ) {
                print "$i	$j	$k	$tmp{$i}{$j}{$k}\n";
            }
        }
    }
}

sub show_array {
    my @input = @_;
    foreach my $i ( 0 .. 8 ) {
        foreach my $j ( 0 .. 3 ) {
            print "$i	$j	$input[$i][$j]\n";
        }
    }
}

sub comma_count {
    my ($file) = @_;
    my %hash;

    open( COMMA, $file ) || die $!;
    while ( chomp( my $l = <COMMA> ) ) {
        my @pt = split ",", $l;
        foreach my $i (@pt) {
            $hash{$i}++;
        }
    }
    close COMMA;

    my $cnt = keys %hash;
    print "COMMA count : $cnt\n";
    return %hash;
}

sub change_xy {
    my ( $file, $result ) = @_;
    my ( @x, $cnt, $col, %M );
    print "\n\nconvert X --> Y\n";

    open( CHANGE_XY, $file ) || die $!;
    while ( chomp( my $l = <CHANGE_XY> ) ) {
        my @pt = split "	", $l;
        $cnt++;
        if ( $cnt == 1 ) {
            $col = @pt;
        }
        foreach my $i ( 1 .. $col ) {
            $M{$cnt}{$i} = $pt[ $i - 1 ];
        }
    }
    close CHANGE_XY;

    open( CHANGE_XY_W, ">$result.txt" ) || die $!;
    foreach my $i ( 1 .. $col ) {
        my @line;
        foreach my $j ( 1 .. $cnt ) {
            if ( $M{$j}{$i} eq "	" ) { $M{$j}{$i} = " "; }
            push @line, $M{$j}{$i};
        }
        my $line = join "	", @line;
        print CHANGE_XY_W "$line\n";
    }
    close CHANGE_XY_W;
}

sub Key_value {
    my ($file)  = ( shift || die "No File\n" );
    my ($key)   = ( shift || die "No Key column\n" );
    my ($value) = ( shift || die "No value column\n" );
    my %hash;

    foreach my $i ( File2Array($file) ) {
        chomp($i);
        @pt = split "	", $i;
        $hash{ $pt[ $key - 1 ] } = $pt[ $value - 1 ];
    }

    return %hash;
}

sub getFileExtension {
    my $pos = rindex $_[0], ".";
    return "" if $pos < 1;
    substr $_[0], $pos + 1;
}

sub make_hash_from_file {
    my %hash;
    open( F, $_[0] ) || die $!;
    while ( chomp( my $l = <F> ) ) {
        $hash{$l}++;
    }
    close F;
    return %hash;
}

sub Chage {
    my %chage = ( 0 => "AA", 2 => "BB", 1 => "AB", 5 => "FL" );
    open( CH_W, ">out.txt" ) || die $!;
    open( CH,   $_[0] )      || die $!;
    while ( chomp( $l = <CH> ) ) {
        $l =~ s/^\t/NN\t/;
        $l =~ s/\t$/\tNN/;

        $l =~ s/\t\t/\tNN\t/g;
        $l =~ s/\t\t/\tNN\t/g;

        my @pt = split /\t/, $l;

        my @new;
        foreach my $i (@pt) {
            if ( $chage{$i} ) {
                push @new, $chage{$i};
            }
            else {
                push @new, $i;
            }

        }

        my $line = join "	", @new;
        print CH_W "$line\n";
    }
    close CH;
    close CH_W;
}

sub getfilename {
    my ( $pos, $name );
    $pos = rindex $_[0], ".";
    $name = substr $_[0], 0, $pos;

    $pos = rindex $name, "/";
    $name = substr $_[0], $pos + 1, length($name);
    return $name;
}

sub read_matrix {
    e("Read matrix file : $_[0]");
    open my $F, $_[0]
      or die "Cannot read $_[0]\n";

    my ( $cnt, %M, @Marker, $read_cnt );

    while (<$F>) {
        chomp;
        $cnt++;
        my @pt = split "\t";

        if ( $. % 10000 == 0 ) { print STDERR get_time_detail(), "	number $.\n"; }

        @marker = @pt if $cnt == 1;
        if ( $cnt != 1 ) {
            my $sam = shift @pt;
            foreach my $i ( 0 .. $#pt ) {
                ### title 이 마커일때
                #$M{$sam}{$marker[$i+1]} = $pt[$i];

                ### title 이 샘플일때
                $M{ $marker[ $i + 1 ] }{$sam} = $pt[$i];

                $read_cnt++;
            }
        }

    }
    close F;

    print STDERR "read matrix list : $read_cnt\n";
    return %M;
}

sub read_matrix_x {
    open( my $F, $_[0] )
      or die $!;
    my ( %M, @Marker );

    while (<$F>) {
        chomp;
        my @pt  = split "\t";
        my $sam = shift @pt;

        @marker = @pt if $. == 1;

        if ( $. > 1 ) {
            map { $M{$sam}{ $marker[$_] } = $pt[$_] } 0 .. $#pt;
        }

    }
    close F;

    return %M;
}

sub make_col_function {
    my @keys;
    foreach my $i (@_) {
        push @keys, '$_[' . ( $i - 1 ) . ']';
    }
    my $key      = join "	", @keys;
    my $key_code = 'if(@_){return "' . $key . '";}';
    my $sub_key  = eval "sub { $key_code }";

    #print "$key	$key_code\n";
    return ($sub_key);
}

sub hash_tab_limited {
    my ( $file, $select_col, $out_form_col ) = @_;

    #print "$file,$select_col,$out_form_col\n";

    my @select = split ",", $select_col;
    my @values = split ",", $out_form_col;
    my @keys;

    my $sub_key = make_col_function(@select);
    my $sub_value =
      $out_form_col eq "all"
      ? undef
      : make_col_function(@values);
    my %temp;
    my ( $cnt, $group );

    open my $F, '<', $file
      or die "Cannot read $file $!\n";
    while (<$F>) {
        chomp;
        my @pt       = split /\t/;
        my $key_text = &$sub_key(@pt);
        my $value_text =
            $out_form_col eq "all"
          ? $_
          : &$sub_value(@pt);

        if ( $temp{$key_text} ) { $temp{$key_text} .= ",$value_text"; }
        else                    { $temp{$key_text} = $value_text; }
    }
    close $F;

    return %temp;
}

sub hash_tab_limited_cnt {
    my ( $file, $select_col ) = @_;
    print "$file,$select_col\n";
    my ($F) = ("F");

    my @select = split ",", $select_col;

    my $sub_key = make_col_function(@select);
    my %temp;

    open $F, $file;
    while ( chomp( my $l = <F> ) ) {
        my @pt = split "	", $l;
        my $key_text = &$sub_key(@pt);

        #print ">key: $key_text\n>value: $value_text\n";

        $temp{$key_text}++;
    }
    close $F;

    return %temp;
}

sub extract_want_col_from_f {
    my $f        = $_[0];                          # target file
    my @user_col = split ",", $_[1];               # user want column
    my $key      = make_col_function(@user_col);

    open( F, $f ) or die $!;
    open( W, ">$f.extracted_col" ) or die $!;
    while ( chomp( my $l = <F> ) ) {
        my @pt = split /\t/, $l;
        my $cols = &$key(@pt);
        print W "$cols\n";
    }
    close F;
    close W;
}

sub Merge {
    my ( $title, $result_name, @list ) = @_;
    open( MERGE, ">$result_name.txt" ) || die $!;

    foreach my $i (@list) {
        print "$i\n";
        my $cnt;
        open( F, $i ) || die $!;
        while ( chomp( my $l = <F> ) ) {
            next if ++$cnt == $title;

            print MERGE "$l\n";
        }
        close F;
    }

    close MERGE;
}

sub Merge_custom {
    my ( $common_title, $result_name, @file_list ) = @_;

    my $cnt;
    open( MERGE, ">$result_name.txt" ) || die $!;
    foreach my $i (@file_list) {
        print "$i\n";
        $cnt++;
        open( F, $i ) || die $!;
        while ( chomp( my $l = <F> ) ) {
            if ( $cnt > 1 && $. == $common_title ) {
                print "skip $. number\n$l\n";
                next;
            }

            print MERGE "$l\n";
        }
        close F;
    }

    close MERGE;
}

sub fasta_f_read {
    open( F, $_[0] ) || die $!;
    @seq = <F>;
    close F;
    shift @seq;
    $seq = join "", @seq;
    $seq =~ s/\n//g;
    return $seq;
}

sub Input_STDIN_f {
    print "\n[Question] $_[0] : ";
    my $input = <STDIN>;
    chomp($input);
    return $input;
}

sub Input_STDIN_t {
    print "\n[Question] $_[0] : ";
    my $input = <STDIN>;
    chomp($input);
    return $input;
}

sub complementary {
    $seq = shift;
    $seq =~ tr/ACGTacgtRYMKWSHDBV/TGCAtgcaYRKMWSDHVB/;
    $seq = reverse($seq);
    if ( $seq =~ /[\[|\]]/ ) { $seq =~ tr/\[\]/\]\[/; }
    return ($seq);
}

sub trim_space {
    $_[0] =~ s/\s+//g;
    return ( $_[0] );
}

sub IUPAC {


    my @tmp = split /\//, $_[0];
    @tmp = sort { $a cmp $b } @tmp;
    my $sort_input = join "", @tmp;

    my %iupac = (
        AG   => "R",
        CT   => "Y",
        AC   => "M",
        GT   => "K",
        AT   => "W",
        CG   => "S",
        CGT  => "B",
        AGT  => "D",
        ACT  => "H",
        ACG  => "V",
        ACGT => "N"
    );
    my $result = $iupac{$sort_input};
    $result = "X" if !$result;

    return ($result);
}

sub iupac2geno {
    my %allele = (
        R => "AG",
        Y => "CT",
        M => "AC",
        K => "GT",
        W => "AT",
        S => "CG",
        B => "CGT",
        D => "AGT",
        H => "ACT",
        V => "ACG",
        N => "ACGT"
    );
    return %allele;
}

sub iupac2genotype {
    my %allele = (
        R => "A/G",
        Y => "C/T",
        M => "A/C",
        K => "G/T",
        W => "A/T",
        S => "C/G",
        B => "C/G/T",
        D => "A/G/T",
        H => "A/C/T",
        V => "A/C/G",
        N => "A/C/G/T"
    );
    return %allele;
}

sub fasta2hash {
    open( F, $_[0] ) || die $!;
    my ( $id, %id2seq );
    while ( chomp( my $l = <F> ) ) {
        if ( $l =~ />/ ) {
            $id = $';
        }
        elsif ( $l =~ /\w+/ && $id ) {
            $id2seq{$id} .= $l;
        }
    }
    close F;

    return %id2seq;
}

sub mssql_connect {
    ######### DBN DB MSSQL Connect ############
    ######## database 접속
    my $DSN =
      'driver={SQL Server};Server=DBN;database=rs_db;uid=sa;pwd=dna@link;';
    my $dbh = DBI->connect("dbi:ODBC:$DSN") or die "$DBI::errstr\n";
    return $dbh;

}

sub DB_query {
    my ( $dbh, $qry ) = @_;
    my $sth = $dbh->prepare($qry);
    $sth->execute();
    return $sth;
}

sub divide_size {
    my ( $seq, $size ) = @_;
    my $len_seq   = length($seq);
    my $operation = int( $len_seq / $size );

    foreach my $i ( 0 .. $operation ) {
        my $sub_seq = substr( $seq, $i * $size, $size );
        push @seq, $sub_seq;
    }
    return @seq;
}

sub csv_file_handle_key_value {

    # $file_write --> option 파일로 만들고 싶으면 값을 넣는다.

    my ( $file, $key, $value, $file_write ) = @_;
    my $key_function   = make_col_function( split ",", $key );
    my $value_function = make_col_function( split ",", $value );
    my %result;    ## --> result hash

    open( F, $file ) || die $!;
    while ( chomp( my $l = <F> ) ) {
        $l =~ s/^\"//;    ## first ^" rm
        $l =~ s/\"$//;    ## last "$ rm
        @pt = split '","', $l;

        my $key   = &{$key_function}(@pt);
        my $value = &{$value_function}(@pt);

        #print "$key	$value\n";
        $result{$key} = $value;
    }
    close F;

    if ($file_write) { Foreach_hash2file( "name", %result ); }
    else             { return %result; }
}

sub Foreach_hash2file {
    my $name = shift;
    my %hash = @_;
    open( W, ">$name.txt" ) || die $!;
    foreach my $i ( sort { $a cmp $b } keys %hash ) {
        print W "$i	$hash{$i}\n";
    }
    close W;
}

sub show_column_sample_from_file {
    my $file    = shift;
    my $delimit = shift;
    open( F, $file ) || die $!;
    while ( chomp( my $l = <F> ) ) {
        my @pt = split $delimit, $l;
        map { print "$_	$pt[$_]\n" } ( 0 .. @pt );
        print "count : ", scalar(@pt), "\n";
        <STDIN>;
    }
    close F;
}

sub make_2_hash {
    my ( $db_f, $fir_key, $sec_key, $value ) = @_;

    my @fir_key = split ",", $fir_key;
    my @sec_key = split ",", $sec_key;
    my @value   = split ",", $value;

    my $fir_key_sub = make_col_function(@fir_key);
    my $sec_key_sub = make_col_function(@sec_key);
    my $value_sub   = make_col_function(@value);

    my %db;
    open( F, $db_f ) || die $!;
    while ( chomp( my $l = <F> ) ) {
        my @pt = split /\t/, $l;

        my $fir_key   = &{$fir_key_sub}(@pt);
        my $sec_key   = &{$sec_key_sub}(@pt);
        my $value_key = &{$value_sub}(@pt);

        if ( $value eq "all" ) { $value_key = $l; }

        # make db hash
        if ( $db{$fir_key}{$sec_key} ) {
            $db{$fir_key}{$sec_key} .= ",$value_key";
        }
        else { $db{$fir_key}{$sec_key} = $value_key; }
    }
    close F;
    return %db;
}

sub make_2_hash_cnt {
    my ( $db_f, $fir_key, $sec_key ) = @_;

    my @fir_key = split ",", $fir_key;
    my @sec_key = split ",", $sec_key;

    my $fir_key_sub = make_col_function(@fir_key);
    my $sec_key_sub = make_col_function(@sec_key);

    my %db;
    open( F, $db_f ) || die $!;
    while ( chomp( my $l = <F> ) ) {
        my @pt = split /\t/, $l;

        my $fir_key = &{$fir_key_sub}(@pt);
        my $sec_key = &{$sec_key_sub}(@pt);

        # make db hash
        $db{$fir_key}{$sec_key}++;
    }
    close F;
    return %db;
}

sub make_3_hash {
    e("excute function make_3_hash");
    my ( $db_f, $fir_key, $sec_key, $third_key, $value ) = @_;

    my @fir_key   = split ",", $fir_key;
    my @sec_key   = split ",", $sec_key;
    my @third_key = split ",", $third_key;
    my @value     = split ",", $value;

    my $fir_key_sub   = make_col_function(@fir_key);
    my $sec_key_sub   = make_col_function(@sec_key);
    my $third_key_sub = make_col_function(@third_key);
    my $value_sub     = make_col_function(@value);

    my %db;
    open( F, $db_f ) || die $!;
    while ( chomp( my $l = <F> ) ) {
        my @pt = split /\t/, $l;

        my $fir_key   = &{$fir_key_sub}(@pt);
        my $sec_key   = &{$sec_key_sub}(@pt);
        my $third_key = &{$third_key_sub}(@pt);
        my $value_key = &{$value_sub}(@pt);

        if ( $value eq "all" ) { $value_key = $l; }

        # make db hash
        if ( $db{$fir_key}{$sec_key}{$third_key} ) {
            $db{$fir_key}{$sec_key}{$third_key} .= ",$value_key";
        }
        else { $db{$fir_key}{$sec_key}{$third_key} = $value_key; }
    }
    close F;
    return %db;
}

sub make_array_with_delimit {
    my ( $value, $delimit ) = @_;
    my @result = split /$delimit/, $value;
    return @result;
}

sub confirm_2_file {
    my ( $name, %tmp ) = @_;
    open( W, ">$name.txt" ) || die $!;
    foreach my $i ( sort { $a cmp $b } keys %tmp ) {
        foreach my $j ( sort { $a <=> $b } keys %{ $tmp{$i} } ) {
            print W "$i	$j	$tmp{$i}{$j}\n";
        }
    }
    close W;
}

sub confirm_3_file {
    my ( $name, %tmp ) = @_;
    open( W, ">$name.txt" ) || die $!;
    foreach my $i ( sort { $a cmp $b } keys %tmp ) {
        foreach my $j ( sort { $a cmp $b } keys %{ $tmp{$i} } ) {
            foreach my $k ( sort { $a cmp $b } keys %{ $tmp{$i}{$j} } ) {
                print W "$i	$j	$k	$tmp{$i}{$j}{$k}\n";
            }
        }
    }
    close W;
}

sub make_matrix_file {
    ## (title hash ref, file name, matrix data hash)
    ## usage format
  #	%matrix = make_2_hash("call.txt",2(sample column),1(marker column),3(call));
  #	%Title = hash_tab_limited("call.txt",1(marker column),2);
  #	make_matrix_file(\%Title,"call_matrix",%matrix);

    my $ref_title = shift;
    my @title     = sort { $a cmp $b } keys %{$ref_title};
    my $title     = join "	", @title;

    my $file_name = shift;
    my %matrix    = @_;

    open( W, ">$file_name.txt" ) || die $!;
    print W "	$title\n";
    foreach my $i ( sort { $a cmp $b } keys %matrix ) {
        my @tmp;
        push @tmp, $i;
        foreach my $j (@title) {
            if ( $matrix{$i}{$j} || $matrix{$i}{$j} == 0 ) {
                push @tmp, $matrix{$i}{$j};
            }
            else { push @tmp, "FL"; }
        }
        my $line = join "	", @tmp;
        print W "$line\n";
    }
    close W;
}

sub make_matrix_file_new {
    my ( $file, %matrix ) = @_;
    print "make matrix file --> $file.txt\n";

    #my @title = sort {$a cmp $b} keys @{ $M{ shift keys %matrix  } };

    my %titles;
    for my $i ( keys %matrix ) {
        @titles{ keys %{ $matrix{$i} } } = undef;
    }

    my @title = sort { $a cmp $b } keys %titles;

    open my $W, '>', "$file.txt"
      or croak "Cannot write file $file $!";

    print $W join( "\t", "probeset_id", @title ), "\n";

    foreach my $i ( sort { $a cmp $b } keys %matrix ) {
        my @tmp;
        foreach my $j (@title) {

            #print "$i	$j	$matrix{$i}{$j}\n";

            push @tmp, defined $matrix{$i}{$j}
              ? $matrix{$i}{$j}
              : "NN";
        }
        print $W join( "\t", $i, @tmp ), "\n";
    }
    close $W;
}

sub mmfss_ctitle {
    my ( $file, $matrix, $title ) = @_;
    print "make matrix file --> $file.txt\n";
	
	%matrix = %{$matrix};
	my @title  = @{$title};
#map { print "$_\n" } @title;
    open my $W, '>', "$file.txt"
      or croak "Cannot write file $file $!";

    print $W join( "\t", "probeset_id", @title ), "\n";

    foreach my $i ( sort { $a cmp $b } keys %matrix ) {
        my @tmp;
        foreach my $j (@title) {
            push @tmp, defined $matrix{$i}{$j}
              ? $matrix{$i}{$j}
              : 0;
        }
        print $W join( "\t", $i, @tmp ), "\n";
    }
    close $W;
}

sub mmfss_n {
    my ( $file, %matrix ) = @_;
    print "make matrix file --> $file.txt\n";

    my %titles;
    for my $i ( keys %matrix ) {
        @titles{ keys %{ $matrix{$i} } } = undef;
    }

    my @title = sort { $a cmp $b } keys %titles;

    open my $W, '>', "$file.txt"
      or croak "Cannot write file $file $!";

    print $W join( "\t", "probeset_id", @title );

    foreach my $i ( sort { $a cmp $b } keys %matrix ) {
        my @tmp;
        foreach my $j (@title) {
            push @tmp, defined $matrix{$i}{$j}
              ? $matrix{$i}{$j}
              : 0;
        }
        print $W join( "\t", $i, @tmp );
    }
    close $W;
}


sub mmfss {
    my ( $file, %matrix ) = @_;
	#print "make matrix file --> $file.txt\n";

    my %titles;
    for my $i ( keys %matrix ) {
        @titles{ keys %{ $matrix{$i} } } = undef;
    }

    my @title = sort { $a cmp $b } keys %titles;

    open my $W, '>', "$file.txt"
      or croak "Cannot write file $file $!";

    print $W join( "\t", "probeset_id", @title ), "\n";

    foreach my $i ( sort { $a cmp $b } keys %matrix ) {
        my @tmp;
        foreach my $j (@title) {
            push @tmp, defined $matrix{$i}{$j}
              ? $matrix{$i}{$j}
              : 0;
        }
        print $W join( "\t", $i, @tmp ), "\n";
    }
    close $W;
}


sub mmfss_print {
    my ( %matrix ) = @_;
	#print "make matrix file --> $file.txt\n";

    my %titles;
    for my $i ( keys %matrix ) {
        @titles{ keys %{ $matrix{$i} } } = undef;
    }

    my @title = sort { $a cmp $b } keys %titles;

    print join( "\t", "probeset_id", @title ), "\n";

    foreach my $i ( sort { $a cmp $b } keys %matrix ) {
        my @tmp;
        foreach my $j (@title) {
            push @tmp, defined $matrix{$i}{$j}
              ? $matrix{$i}{$j}
              : 0;
        }
        print join( "\t", $i, @tmp ), "\n";
    }
}

sub mmfss_header {
    my ( $file, $header,%matrix ) = @_;
	#print "make matrix file --> $file.txt\n";

    my %titles;
    for my $i ( keys %matrix ) {
        @titles{ keys %{ $matrix{$i} } } = undef;
    }

    my @title = sort { $a cmp $b } keys %titles;

    open my $W, '>', "$file.txt"
      or croak "Cannot write file $file $!";

    print $W join( "\t", $header, @title ), "\n";

    foreach my $i ( sort { $a cmp $b } keys %matrix ) {
        my @tmp;
        foreach my $j (@title) {
            push @tmp, defined $matrix{$i}{$j}
              ? $matrix{$i}{$j}
              : 0;
        }
        print $W join( "\t", $i, @tmp ), "\n";
    }
    close $W;
}

sub mmfss_1 {
    my ( $file, %matrix ) = @_;
    print "make matrix file --> $file.txt\n";

    my %titles;
    for my $i ( keys %matrix ) {
        @titles{ keys %{ $matrix{$i} } } = undef;
    }

    my @title = sort { $a cmp $b } keys %titles;

    open my $W, '>', "$file.txt"
      or croak "Cannot write file $file $!";

    print $W join( "\t", "probeset_id", @title ), "\n";

    foreach my $i ( sort { $a cmp $b } keys %matrix ) {
        my @tmp;
        foreach my $j (@title) {
            push @tmp, defined $matrix{$i}{$j}
              ? $matrix{$i}{$j}
              : -1;
        }
        print $W join( "\t", $i, @tmp ), "\n";
    }
    close $W;
}

sub mmfss_dot {
    my ( $file, %matrix ) = @_;
    print "make matrix file --> $file.txt\n";

    my %titles;
    for my $i ( keys %matrix ) {
        @titles{ keys %{ $matrix{$i} } } = undef;
    }

    my @title = sort { $a cmp $b } keys %titles;

    open my $W, '>', "$file.txt"
      or croak "Cannot write file $file $!";

    print $W join( "\t", "probeset_id", @title ), "\n";

    foreach my $i ( sort { $a cmp $b } keys %matrix ) {
        my @tmp;
        foreach my $j (@title) {
            push @tmp, defined $matrix{$i}{$j}
              ? $matrix{$i}{$j}
              : ".";
        }
        print $W join( "\t", $i, @tmp ), "\n";
    }
    close $W;
}


sub mmfss_blank {
    my ( $file, %matrix ) = @_;
    print "make matrix file --> $file.txt\n";

    my %titles;
    for my $i ( keys %matrix ) {
        @titles{ keys %{ $matrix{$i} } } = undef;
    }

    my @title = sort { $a cmp $b } keys %titles;

    open my $W, '>', "$file.txt"
      or croak "Cannot write file $file $!";

    print $W join( "\t", "probeset_id", @title ), "\n";

    foreach my $i ( sort { $a cmp $b } keys %matrix ) {
        my @tmp;
        foreach my $j (@title) {
            push @tmp, defined $matrix{$i}{$j}
              ? $matrix{$i}{$j}
              : "";
        }
        print $W join( "\t", $i, @tmp ), "\n";
    }
    close $W;
}


sub mmfss_space2 {
    my ( $file, %matrix ) = @_;
    print "make matrix file --> $file.txt\n";

    my %titles;
    for my $i ( keys %matrix ) {
        @titles{ keys %{ $matrix{$i} } } = undef;
    }

    my @title = sort { $a cmp $b } keys %titles;

    open my $W, '>', "$file.txt"
      or croak "Cannot write file $file $!";

    print $W join( "\t", "probeset_id", @title ), "\n";

    foreach my $i ( sort { $a cmp $b } keys %matrix ) {
        my @tmp;
        foreach my $j (@title) {
            push @tmp, defined $matrix{$i}{$j}
              ? $matrix{$i}{$j}
              : "  ";
        }
        print $W join( "\t", $i, @tmp ), "\n";
    }
    close $W;
}

sub mmfns {
    my ( $file, %matrix ) = @_;
    print "make matrix file --> $file.txt\n";

    my %titles;
    for my $i ( keys %matrix ) {
        @titles{ keys %{ $matrix{$i} } } = undef;
    }

    my @title = sort { $a <=> $b } keys %titles;

    open my $W, '>', "$file.txt"
      or croak "Cannot write file $file $!";

    print $W join( "\t", "probeset_id", @title ), "\n";

    foreach my $i ( sort { $a cmp $b } keys %matrix ) {
        my @tmp;
        foreach my $j (@title) {
            push @tmp, defined $matrix{$i}{$j}
              ? $matrix{$i}{$j}
              : 0;
        }
        print $W join( "\t", $i, @tmp ), "\n";
    }
    close $W;
}

sub mmfsn {
    my ( $file, %matrix ) = @_;
#print "make matrix file --> $file.txt\n";

    my %titles;
    for my $i ( keys %matrix ) {
        @titles{ keys %{ $matrix{$i} } } = undef;
    }

    my @title = sort { $a cmp $b } keys %titles;

    open my $W, '>', "$file.txt"
      or croak "Cannot write file $file $!";

    print $W join( "\t", "probeset_id", @title ), "\n";

    foreach my $i ( sort { $a <=> $b } keys %matrix ) {
        my @tmp;
        foreach my $j (@title) {
            push @tmp, defined $matrix{$i}{$j}
              ? $matrix{$i}{$j}
              : 0;
        }
        print $W join( "\t", $i, @tmp ), "\n";
    }
    close $W;
}

sub mmfnn {
    my ( $file, %matrix ) = @_;
    print "make matrix file --> $file.txt\n";

    my %titles;
    for my $i ( keys %matrix ) {
        @titles{ keys %{ $matrix{$i} } } = undef;
    }

    my @title = sort { $a <=> $b } keys %titles;

    open my $W, '>', "$file.txt"
      or croak "Cannot write file $file $!";

    print $W join( "\t", "probeset_id", @title ), "\n";

    foreach my $i ( sort { $a <=> $b } keys %matrix ) {
        my @tmp;
        foreach my $j (@title) {
            push @tmp, defined $matrix{$i}{$j}
              ? $matrix{$i}{$j}
              : 0;
        }
        print $W join( "\t", $i, @tmp ), "\n";
    }
    close $W;
}

sub h2r {
    my %h = @_;
    my %r;
    for my $i ( keys %h ) {
        map { $r{$_}{$i} = $h{$i}{$_} } keys %{ $h{$i} };
    }
    return %r;
}

sub sam_count_delimit_coma {
    my %hash = @_;
    my $sam_cnt;
    foreach my $i ( keys %hash ) {
        my $cnt = @tmp = split ",", $hash{$i};
        $sam_cnt += $cnt;
    }
    return $sam_cnt;
}

sub make_reverse_hash {
    my %hash = @_;
    my %result;
    foreach my $i ( keys %hash ) {
        my $cnt = $hash{$i};
        $result{$cnt} .= "$i,";
    }
    return %result;
}

sub make_call_matrix {
    my ( $db_f, $snp, $sam, $call ) = @_;

    my %db;
    open( F, $db_f ) || die $!;
    while ( chomp( my $l = <F> ) ) {
        my @pt    = split /\t/, $l;
        my $snpid = $pt[ $snp - 1 ];
        my $samid = uc( $pt[ $sam - 1 ] );    ## sample id upper case
        $samid =~ s/\s+//g;                   ## sample id 공백 제거

        if ( !$db{$samid}{$snpid} ) {
            $db{$samid}{$snpid} = "$pt[$call-1]";
        }
        else {
            $db{$samid}{$snpid} .= ",$pt[$call-1]";
        }

    }
    close F;
    return %db;
}

sub File_line_check {
    foreach my $i (@_) {
        open( F, $i ) || die $!;
        my @line = <F>;
        print "$i file line " . scalar(@line) . " line\n";
        close F;
    }
}

sub csv2txt {
    my $file = shift;
    open $F, $file            or die $!;
    open $W, ">$file-csv2txt" or die $!;
    while ( chomp( my $l = <F> ) ) {
        $l =~ s/^\"//;
        $l =~ s/\"$//;
        $l =~ s/\",\"/\t/g;
        print $W "$l\n";
    }
    close $F;
    close $W;
}

sub show_array_array {
    my @array = @_;
    foreach my $i (@array) {
        print "@{$i}\n";
    }
}

sub select_col_id_cnt {
    my ( $file, $col ) = @_;
    my $sub_key = make_col_function( split ",", $col );
    my ($F) = "F";

    my %id_cnt;
    open( $F, $file ) || die $!;
    while ( chomp( my $l = <$F> ) ) {
        my @pt = split "	", $l;
        my $key = &{$sub_key}(@pt);
        $id_cnt{$key}++;
    }
    close $F;
    Foreach_hash2file( "id_count", %id_cnt );

    return %id_cnt;
}

sub select_two_col_id_cnt {
    my ( $file, $fir, $sec ) = @_;
    my $sub_1_key = make_col_function( split ",", $fir );
    my $sub_2_key = make_col_function( split ",", $sec );
    my ($F)       = "F";

    my %id_cnt;
    open( $F, $file ) || die $!;
    while ( chomp( my $l = <$F> ) ) {
        my @pt    = split "	", $l;
        my $key_1 = &{$sub_1_key}(@pt);
        my $key_2 = &{$sub_2_key}(@pt);
        $id_cnt{$key_1}{$key_2}++;
    }
    close $F;
    confirm_2_file( "id_count", %id_cnt );

    return %id_cnt;
}

sub key_cnt {
    my %hash = @_;
    @key = keys %hash;
    print "key cnt : ", scalar(@key), "\n";
}

sub select_col_count {
    my ( $file, $col ) = @_;
    my @cont = File2Array($file);
    my %result;
    my @col = split ",", $col;
    my $sub_key = make_col_function(@col);

    foreach my $i (@cont) {
        my @pt = split "	", $i;
        my $key = &{$sub_key}(@pt);
        $result{$key}++;
    }

    my @keys = keys %result;
    print "key : ", scalar(@keys), "\n";

    my $cnt;
    foreach my $i ( keys %result ) {
        if ( $result{$i} > 1 ) {
            $cnt++;
            print "$i	$result{$i}\n";
        }
    }

    print "complete : $cnt EA\n";
}

sub get_name {
    my ($file) = @_;
    $file =~ /\/?(\w+)\./;
    return $1;
}

sub special_variant {
    my @special;
    $special[0] = $0;     ## current file name;
    $special[1] = $^O;    ## OS system
}

sub matrix_call_num2AB {
    my ( $file, $name ) = @_;
    my %num2AB = ( 0 => "AA", 1 => "AB", 2 => "BB", 5 => "NN" );

    open( F, $file )        || die $!;
    open( W, ">$name.txt" ) || die $!;
    while ( chomp( my $l = <F> ) ) {
        $cnt++;
        if ( $cnt == 1 ) { print W "$l\n"; next; }

        my ( $id, @pt ) = split /\t/, $l;

        my @line;
        push @line, $id;
        foreach my $i (@pt) {
            push @line, $num2AB{$i};
        }

        my $line = join "	", @line;

        print W "$line\n";
    }
    close F;
    close W;
}

sub sample_random_selection {
    my ( $select_cnt, @list ) = @_;

    my $list_cnt = scalar(@list);

    print "start sampling : $select_cnt\n";
    print "list count : $list_cnt\n";

    if ( $select_cnt > $list_cnt ) { die "sample size is small\n"; }

    my @result;
    my %exist;

    while (1) {
        my $num = int( rand($list_cnt) );    ## rand (10) 0-9까지에서 선택
        if ( !$exist{$num} ) {
            $exist{$num}++;
            push @result, $list[ $num - 1 ];
            if ( scalar(@result) == $select_cnt ) { last; }
        }
    }

    print "selected list : " . scalar(@result), "\n";
    $result = join "\n", @result;
    return $result;
}

sub get_string_from_seq {
    my ( $seq, $window_size, $sliding_size, $start, $end, $rs ) = @_;
    my $len = length($seq);
    my $line;

    foreach my $i ( 1 .. ( $len - ( $window_size - 1 ) ) ) {
        my $string = substr( $seq, ( $i - 1 ), $window_size );
        my $pos_s = $start + ( $i - 1 );
        my $pos_e = $pos_s + ( $window_size - 1 );

        $line .= ">$rs-$pos_s-$pos_e\n$string\n";
    }
    return $line;
}

sub dp_f_info {
    my ( $file, $skip_line ) = @_;
    my @text = File2Array($file);

    splice( @text, 0, $skip_line ) if $skip_line;
    my @tab = split /\t/, $text[0];

    print "\t\t< Display File information >\t\t\n";
    print "\t File	$file\n";
    print "\t Line	", scalar(@text), "\n";
    print "\t Tab	",  scalar(@tab),  "\n\n\n\n";

}

sub perl_script {
    my %info;
    $info{pid}          = $$;    ### 현재 scipt 를 진행하는 process 번호
    $info{uid}          = $<;    ### 현 process의 실 user ID(uid)
    $info{euid}         = $>;    ### 현재 process 의 유효 uid
    $info{gid}          = $(;    ### 현재 process 의 실 gid
    $info{egid}         = $);    ### 현재 process 의 유효 gid
    $info{program_name} = $0;    ### 현재 수행중인 스크립트의 파일 이름
    $info{perl_version} = $];    ### perl version  check
    $info{osname}       = $^O
      ; ### 현재 perl 바이너리가 컴파일된 시스템의 운영체제 Config 모듈 대신 사용할 수 있는 간단한 방법
    $info{basetime} = $^T
      ; ### 1970년부터 시작하여 해당 스크립트가 실행된 시간을 초단위로 환산한 값
    $info{warning}         = $^W;    ### 현재 경고 스위치의 값
    $info{executable_name} = $^X;    ### 실행된 perl 바이너리 자신의 이름

    print "<SYSTEM Information>\n\n[Summary]\n";
    Foreach_hash(%info);

    print "\n\n[ENV]\n";
    Foreach_hash(%ENV);

    print "\n\n[INC]\n";
    Foreach_array(@INC);

    print "\n\n[INC]\n";
    Foreach_hash(%INC);

    print "\n\n[SIG]\n";
    Foreach_hash(%SIG);
}

sub remote_test {
    my ( $host, $timeout ) = @_;

    #$host = "165.132.106.38";
    #$timeout = 10;
    if ( pingecho( $host, $timeout ) ) { print "$host is alive\n"; }
}

sub get_element {
    ## 특수변수일때는 \ 를 붙여준다 --> $delimit
    my ( $list, $delimit, $num ) = @_;
    my @list = split "$delimit", $list;
    return ( $list[ $num - 1 ] );
}

sub convert_line {
    my ( $list, $string ) = @_;
    my @list   = @{$list};
    my @string = @{$string};

    foreach my $i (@list) {
        my ( $expression, $replace ) = @{$i};
        foreach my $j (@string) {
            $j =~ s/$expression/$replace/g;
        }
    }
    return @string;
}

sub Array2File {
    my ( $name, @array ) = @_;
    my $data = join "\n", @array;
    Write_file( $data, $name );
}

sub matrix_call_correction {
    my ( $before, $after ) = @_;

    ### data format title marker row sample

    ### read 잘못된 hetero call 가진 것만 hash 에 저장
    my %bad_matrix = read_matrix_only_fail($before);

    #confirm_2(%bad_matrix);

    ### 보정될 matrix file 을 읽고서 위에서 가진 hetero call 을 fail 로 대체
    my %corrected = read_matrix_qurated( $after, \%bad_matrix );

    ### title
    my @cont  = File2Array($after);
    my $title = shift @cont;
    $title =~ s/^\s+\t|^\t//;

    ### make matrix file
    my %title_hash = Array2Hash( split /\t/, $title );
    make_matrix_file( \%title_hash, "corrected", %corrected );

    # compare two matrix file
    compare_two_matrix( $after, "corrected.txt" );
}

sub compare_two_matrix {
    ### 두개의 matrix file 을 넣는다 ###
    my ( $before, $after ) = @_;

    my %before    = read_matrix($before);
    my %corrected = read_matrix($after);

    my ( $line, $match_cnt );

    print "start compare\n";
    foreach my $i ( sort { $a cmp $b } keys %before ) {
        foreach my $j ( sort { $a cmp $b } keys %{ $before{$i} } ) {
            if ( $corrected{$i}{$j} ne $before{$i}{$j} ) {
                $line .= "$i	$j	$before{$i}{$j} -> $corrected{$i}{$j}\n";
            }
            else { $match_cnt++; }

        }
    }
    print "start Writing\nmatch count : $match_cnt\n";
    Write_file( $line, "compare" );
}

sub read_matrix_qurated {
    e("Read qurated matrix file : $_[0]");
    open( F, $_[0] ) || die $!;
    my $cnt;
    my %qurated = %{ $_[1] };
    my %M;

    my @marker;
    while ( chomp( my $l = <F> ) ) {
        $cnt++;
        my @pt = split "	", $l;

        @marker = @pt if $cnt == 1;
        if ( $cnt != 1 ) {
            my $sam = shift @pt;
            foreach my $i ( 0 .. $#pt ) {
                ### title 이 마커일때
                $M{$sam}{ $marker[ $i + 1 ] } = $pt[$i];

                if ( $qurated{$sam}{ $marker[ $i + 1 ] } ) {
                    $M{$sam}{ $marker[ $i + 1 ] } = 5;
                }

                ### title 이 샘플일때
          #if ( $qurated{$sam}{$marker[$i+1]} ) { $M{$marker[$i+1]}{$sam} = 5; }
          #print "$marker[$i+1]	$sam	$pt[$i]\n";
            }
        }

    }
    close F;
    return %M;
}

sub read_matrix_only_fail {
    ### fail 시킬 마커와 샘플을 키로 해서 저장해놓는다.

    e("Read matrix file : $_[0]");
    open( F, $_[0] ) || die $!;
    my $cnt;
    my %M;
    my @marker;
    while ( chomp( my $l = <F> ) ) {
        $cnt++;
        my @pt = split "	", $l;

        @marker = @pt if $cnt == 1;
        if ( $cnt != 1 ) {
            my $sam = shift @pt;
            foreach my $i ( 0 .. $#pt ) {
                ### title 이 마커일때
                if ( $pt[$i] == 1 ) { $M{$sam}{ $marker[ $i + 1 ] } = $pt[$i]; }

                ### title 이 샘플일때
                #if( $pt[$i] == 1 ){ $M{$marker[$i+1]}{$sam} = $pt[$i]; }
                #print "$marker[$i+1]	$sam	$pt[$i]\n";
            }
        }

    }
    close F;
    return %M;
}

sub matrix2flat {
    my ($file) = @_;

    my @title;
    open( F, $file )         || die $!;
    open( W, ">flat-$file" ) || die $!;
    while ( chomp( my $l = <F> ) ) {
        my ( $sam, @pt ) = split /\t/, $l;
        if ( $. % 1000 == 0 ) { print "line number : $.\n"; }

        if ( $. == 1 ) { @title = @pt; }
        else {
            my @line;
            foreach my $i ( 0 .. $#pt ) {
                push @line, "$sam	$title[$i]	$pt[$i]";
            }
            print W ( join "\n", @line ), "\n";
        }
    }
    close F;
    close W;
}

sub confirm_array_array {
    my @array = @_;
    print "element count :", scalar(@array), "\n";
    foreach my $i (@array) {
        foreach my $j ( @{$i} ) {
            print "$j\n";
        }
        print "\n";
    }
}


sub confirm_2_file_line {
    my ( $name, $key_2, $hash ) = @_;

    ## file name
    ## title 될 reference array
    ## hash

    my @key_2 = sort { $a <=> $b } @{$key_2};
    my %tmp = %{$hash};

    open( W, ">$name.txt" ) || die $!;
    my $title = join "	", @key_2;
    print W "	$title\n";

    foreach my $i ( sort { $a cmp $b } keys %tmp ) {

        my @line;
        push @line, $i;
        foreach my $j (@key_2) {
            if ( !$tmp{$i}{$j} ) { $tmp{$i}{$j} = 0; }
            push @line, $tmp{$i}{$j};
        }
        my $line = join "	", @line;
        print W "$line\n";
    }
    close W;
}

sub show_file_list {
    my @file = @_;

    print "\n\n>> file list\n\n";
    foreach my $i ( 0 .. $#file ) {
        print $i+ 1, "	$file[$i]\n";
    }
    print "\n show file list end\n\n";
}

sub make_removed_col_file {
    my ( $file, $col ) = @_;
    my @col = split ",", $col;

    open my $fh, $file           or die "$!";
    open my $W,  ">$file.rm_col" or die "$!";
    while ( chomp( my $l = <$fh> ) ) {
        if ( $. % 10000 == 0 ) { print get_time_detail(), "	number $.\n"; }

        #$l =~ s/\ //g;
        my (@pt) = split /\t/, $l;
        map { splice( @pt, $_ - 1, 1 ); } reverse @col;
        print $W ( join "	", @pt ) . "\n";
    }
    close $fh;
    close $W;
}

sub get_count_from_interval {
    my ( $file, $number, $content, @interval ) = @_;
    my %result;

    foreach my $i ( File2Array($file) ) {
        my @pt = split /\t/, $i;
        my ( $num, $con ) = ( $pt[ $number - 1 ], $pt[ $content - 1 ] );

        foreach my $j (@interval) {
            my ( $s, $e ) = @{$j};
            if ( $s < $num && $e >= $num ) {
                $result{"$s-$e"}{$con}++;
            }
        }
    }

    make_matrix_file_new( "interval_cal", %result );
}

sub get_count_between {
    ## usage : my @interval = get_count_between(92,99,0.5);
    ##	   get_count_from_interval("content.txt",1,2,@interval);

    my ( $start, $end, $interval, $file ) = @_;

    my @interval;
    my $flag = 1;

    my $op = int( ( $end - $start ) / $interval );

    foreach my $i ( 1 .. $op ) {
        my $s = $start + ( $i - 1 ) * $interval;
        my $e = $s + $interval;

        print "start : $s	end : $e\n";
        push @interval, [ $s, $e ];
    }
    return @interval;
}

sub Find_file_from_list($$) {

    my @will_find_list = @{ $_[0] };
    my @all_file_list  = @{ $_[1] };

    my %will_find_list = %{ { map { lc($_) => $_; } @will_find_list } };

    my $line;
    for (@all_file_list) {

        my ( $name, $dir, $prefix ) = fileparse($_);

        #print "$name	$dir	$prefix\n";
        my $temp_name = lc($name);
        $line .= "$dir	$will_find_list{$temp_name}\n"
          if $will_find_list{$temp_name};
    }

    Write_file( $line, "finded_file_list" );
}

sub mv_png {
    my @list   = @{ $_[1] };
    my @target = @{ $_[0] };

    my %target_list = %{ { map { $_ => 1 } @target } };
    make_dir("temp");

    Foreach_hash(%target_list);
    foreach my $i (@list) {
        my ( $file, $dir, $prefix ) = fileparse($i);
        my $name = getfilename($file);

        if ( $target_list{$name} ) {
            print "$i	temp/$file\n";
            rename( $i, "temp/$file" );
        }
    }
}

sub get_filename_from_path($) {

    my @list;
    for ( File2Array( $_[0] ) ) {
        my ( $filename, $dir, $prefix ) = fileparse($_);
        push @list, $filename;
    }
    return @list;
}

sub make_own_dir {
    my $dir = getfilename($0);
    make_dir($dir);
    return $dir;
}

sub HugeMatrixTransform {

    my ( $CreatedFile, $WillTransformedFile ) = @_;
    print "The $CreatedFile file exist and delete it\n" and unlink($CreatedFile)
      if -e $CreatedFile;

    open my $W, ">$CreatedFile"
      or die "cannot write file $CreatedFile $!\n";
    close $W;

    my $size = 111000;

    tie my @list, 'Tie::File', $CreatedFile
      or die "cannot open file $CreatedFile\n";

    my @LineTemp;
    open my $F, $WillTransformedFile
      or die "cannot read file $WillTransformedFile $!\n";

    while (<$F>) {
        chomp;
        my @element = split /\t/;
        $LineTemp[$_] .= "$element[$_]\t" for ( 0 .. $#element );

        if ( $. % $size == 0 || eof $F ) {
            print scalar localtime(), "	line num : $.\n";
            map { $list[$_] .= "$LineTemp[$_]" } 0 .. $#element;
            @LineTemp = ();
        }
        elsif ( $. % 10000 == 0 ) {
            print scalar localtime(), "	line num : $.\n";
        }
    }
    close $F;
    untie @list;
}

sub Is_DefaultFile {
    my $DefaultTitleFile = shift;

    -e $DefaultTitleFile
      ? ( print "Default File : $DefaultTitleFile loaded\n" )
      : (     print "plz insert file TitleFile name\n> "
          and $DefaultTitleFile = <>
          and chomp $DefaultTitleFile );

    return $DefaultTitleFile;
}

sub show_hash_array {
    my %hash = @_;
    map { print "$_ : @{$hash{$_}}\n" } sort { $a cmp $b } keys %hash;
}

sub hash_tab_limited_linux {
    my ( $f, $k, $v ) = @_;

    my %result;
    my @ks = $k =~ /\d+/g;
    my @vs = $v =~ /\d+/g;

    open my $F, $f or die "$f $!";
    while ( chomp( my $l = <$F> ) ) {
        my @pt = split /\t/, $l;
        my $key   = join( "\t", map { $pt[ $_ - 1 ] } @ks );
        my $value = join( "\t", map { $pt[ $_ - 1 ] } @vs );
        $result{$key} = $value;
    }
    close $F;
    return %result;
}

sub h {
    my ( $file, $select_col, $out_form_col ) = @_;

    #print "$file,$select_col,$out_form_col\n";

    my @select = split ",", $select_col;
    my @values = split ",", $out_form_col;
    my @keys;

    my $sub_key   = make_col_function(@select);
    my $sub_value = make_col_function(@values);
    my %temp;
    my ( $cnt, $group );

    open my $F, '<', $file
      or die "Cannot read $file $!\n";
    while (<$F>) {
        chomp;
        my @pt         = split /\t/;
        my $key_text   = &$sub_key(@pt);
        my $value_text = &$sub_value(@pt);

        #print ">key: $key_text\n>value: $value_text\n";

        if ( $out_form_col eq "all" ) { $value_text = $_; }

        if ( $temp{$key_text} ) { $temp{$key_text} .= ",$value_text"; }
        else                    { $temp{$key_text} = $value_text; }
    }
    close $F;

    return %temp;
}

sub WriteMatrixToFile {
    my @Array = @{ +shift };
    my $file  = shift;

    open my $W, '>', $file
      or die "Cannot write $file $!\n";

    for my $row (@Array) {
        print $W join( "\t", @{$row} ), "\n";
    }

    close $W;
}

sub ReadMatrixToArray {
    my @Array;

    open my $F, '<', $_[0]
      or die "Cannot read $_[0] $!\n";
    while (<$F>) {
        chomp;
        my @F = split /\t/;

        map { $Array[ $. - 1 ][$_] = $F[$_] } 0 .. $#F;
    }

    close $F;

    return \@Array;
}


sub read_matrix_list_col_sum {
    my %M;

    for my $file (@_) {
        open my $F, $file
          or die "Cannot read $file\n";

        my $header = <$F>;
        chomp $header;
        my @col = split "\t", $header;

        while (<$F>) {
            chomp;
            my @F = split "\t";

            map { $M{$file}{ $col[$_] } += $F[$_] if $F[$_] =~ /\d+/ } 1 .. $#F;
        }
        close $F;
    }
    return %M;
}

sub read_matrix_list_row_sum {
    my %M;

    for my $file (@_) {
        open my $F, $file
          or die "Cannot read $file\n";

        my $header = <$F>;

        while (<$F>) {
            chomp;
            my @F = split "\t";

            map { $M{ $F[0] }{$file} += $F[$_] if $F[$_] =~ /\d+/ } 1 .. $#F;
        }
        close $F;
    }
    return %M;
}

sub h1c {
    my %h = @_;
    map { print "$_\t$h{$_}" } sort keys %h;
}

sub h1n {
    my %h = @_;
    map { print "$_\t$h{$_}" } sort { $a <=> $b } keys %h;
}

sub v1n {

    # value 2 sort
    my %h = @_;
    map { print "$_\t$h{$_}" } sort { $h{$a} <=> $h{$b} } keys %h;
}

sub v1np {

    # value 2 sort
    my %h = @_;
	my $total;

	map { $sum += $h{$_} } keys %h;
	$h{TotalCount}=$sum;

	for ( sort { $h{$a} <=> $h{$b} } keys %h ){
		
		$percent = sprintf "%.2f", $h{$_} / $sum * 100;
		print join "\t", $_, $h{$_}, $percent;
	}

}

sub v1n2f {

    # value 2 sort
    my $f = shift;
    my %h = @_;
    my $line;

    map { $line .= "$_\t$h{$_}\n" } sort { $h{$a} <=> $h{$b} } keys %h;
    Write_file( $line, $f );
}

sub hist {
    my %h     = @_;
    my $max   = max values %h;
    my $total = sum values %h;

    for my $i ( sort { $a <=> $b } keys %h ) {
        my $per = $h{$i} / $total * 100;
        my $int = int $per;
        my $bar = "|" x $int;
        $accu += $h{$i};
        printf "%10d %10d %10d %10.2f %10.2f\t%s\n", $i, $h{$i}, $accu, $per,
          $accu / $total * 100, $bar;
    }
}

sub histf {
    my %h     = @_;
    my $max   = max values %h;
    my $total = sum values %h;

    for my $i ( sort { $a <=> $b } keys %h ) {
        my $per = $h{$i} / $total * 100;
        my $int = int $per;
        my $bar = "|" x $int;
        $accu += $h{$i};
        printf "%2.2f %10d %10d %10.2f %10.2f\t%s\n", $i, $h{$i}, $accu, $per,
          $accu / $total * 100, $bar;
    }
}

#sub round
#{
#	    my($number) = shift;
#	    return int($number + .5 * ($number <=> 0));
#}


sub histogram
{
  my ($bin_width, @list) = @_;
  my $total = @list + 0;

  # This calculates the frequencies for all available bins in the data set
  my %histogram;
  $histogram{ ceil(($_ + 1) / $bin_width) -1 }++ for @list;

  my $max;
  my $min;

  # Calculate min and max
  while ( my ($key, $value) = each(%histogram) )
  {
    $max = $key if !defined($min) || $key > $max;
    $min = $key if !defined($min) || $key < $min;
  }


  for (my $i = $min; $i <= $max; $i++)
  {
    my $bin       = sprintf("% 10d", ($i) * $bin_width);
    my $frequency_v = $histogram{$i} || 0;
    my $frequency = $histogram{$i}/$total*100 || 0;
    my $percent = sprintf("% 10d", $frequency);
	my $count = sprintf("% 10d", ($frequency_v) );


    $frequency = "#" x $frequency;

    print $bin." ".$count." ".$percent." ".$frequency."\n";
  }

  print "===============================\n\n";
  print "    Width: ".$bin_width."\n";
  print "    Range: ".$min."-".$max."\n\n";
}

sub histogram_tab
{
  my ($bin_width, @list) = @_;
  my $total = @list + 0;

  # This calculates the frequencies for all available bins in the data set
  my %histogram;
  $histogram{ ceil(($_ + 1) / $bin_width) -1 }++ for @list;

  my $max;
  my $min;

  # Calculate min and max
  while ( my ($key, $value) = each(%histogram) )
  {
    $max = $key if !defined($min) || $key > $max;
    $min = $key if !defined($min) || $key < $min;
  }


  for (my $i = $min; $i <= $max; $i++)
  {
    my $bin       = sprintf("%.1f", ($i) * $bin_width);
    my $frequency_v = $histogram{$i} || 0;
	my $per= $histogram{$i}/$total*100 || 0;
    my $frequency = sprintf ("%.2f", $per);
    my $percent = sprintf("%.2f", $frequency);
	my $count = sprintf("%.0f", ($frequency_v) );


    $frequency = "#" x $frequency;

    print join "\t", $bin,$count,$percent,$frequency;
  }

  print "===============================";
  print "Total: $total";
  print "Width: $bin_width";
  print "Range: $min-$max";
}

sub celname
{
	my ($CEL, $num) = @_;
	$CEL =~ /.+_(\d{6})_(\w{2,3})_(.+)\.\w+$/; 
	($set, $well, $id) = ($1,$2,$3); 
	$id =~ s/_(2|3|4|5)$//; 
	@l=(0,$id,$set,$well);
	return $l[$num];
}

sub celname_substitute_id
{
	my ($file, $id, $substituted_id) = @_;
	$file =~ s/$id/$substituted_id/;
				        
	return($file)
}


sub get_date
{
	my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime;

	my $y = sprintf("%04d", $year + 1900);
	my $m = sprintf("%02d", $mon + 1);
	my $d = sprintf("%02d", $mday);
	return($y.$m.$d);
}

sub ToHash
{
	my ($file, $key, $value) = @_;
	my %h;
	$key--;
	$value-- if $value;

	open my $F, '<', $file;
	while(<$F>){
		my @F = split "\t", $_;
		$h{$F[$key]} = defined $value ? $F[$value] : 1
	}
	close $F;
	return %h;

}

sub snpeff3_6 
{ 
   my %h;
   $h{CODON_CHANGE_PLUS_CODON_DELETION}="Exon";
   $h{CODON_CHANGE_PLUS_CODON_INSERTION}="Exon";
   $h{CODON_DELETION}="Exon";
   $h{CODON_INSERTION}="Exon";
   $h{DOWNSTREAM}="Downstream";
   $h{EXON}="Exon";
   $h{FRAME_SHIFT}="Exon";
   $h{INTERGENIC}="Intergenic";
   $h{INTRAGENIC}="Intron";
   $h{INTRON}="Intron";
   $h{NON_SYNONYMOUS_CODING}="Exon";
   $h{NON_SYNONYMOUS_START}="Exon";
   $h{SPLICE_SITE_ACCEPTOR}="SplicingSite";
   $h{SPLICE_SITE_DONOR}="SplicingSite";
   $h{SPLICE_SITE_REGION}="SplicingSite";
   $h{START_GAINED}="Exon";
   $h{START_LOST}="Exon";
   $h{STOP_GAINED}="Exon";
   $h{STOP_LOST}="Exon";
   $h{SYNONYMOUS_CODING}="Exon";
   $h{SYNONYMOUS_STOP}="Exon";
   $h{UPSTREAM}="Upstream";
   $h{UTR_3_PRIME}="UTR";
   $h{UTR_5_PRIME}="UTR";
   return %h
}

sub timediff
{
#	use Date::Parse;
#	use DateTime;
	
	my ($t1, $t2) = @_; # format timestamp = 05/25/2011 05:22:03
	
	my $t1DateTime = DateTime->from_epoch( epoch => str2time( $t1 ) );
	my $t2DateTime = DateTime->from_epoch( epoch => str2time( $t2 ) );
	my $diff = $t2DateTime->subtract_datetime( $t1DateTime );

	my $day = $diff->in_units('days');
	my $hours = $diff->in_units('hours');
	
	return ( "$day days $hours hrs" );

}

sub Month2Num
{
	my ($mon, $len) = @_;
	%mon2num = qw(Jan 1  Feb 2  Mar 3  Apr 4  May 5  Jun 6 Jul 7  Aug 8  Sep 9  Oct 10 Nov 11 Dec 12);

	$mon=(substr($mon,0,3));
	$mon="\u$mon";

	$out=sprintf "%0".$len."d", $mon2num{$mon};
	return( $out );
}

sub ThisYear
{
	return ( (localtime())[5]+1900 )
}

sub ThreeMonthStr_Day2YMD
{
	my ($STR,$delim) = @_;
	# input : Aug 28 08:34:53
	$STR =~ /(\w{3})\s+(\d+)\s+(\d+:\d+:\d+)/;
	($mon,$day,$time)=($1,$2,$3);
	my $d = $delim ? $delim : "/";

	return ( ThisYear().$d.Month2Num($mon,2).$d.$day." ".$time )
	# ouput : 2016/08/28 08:34:53
}

sub geno2chisqure {
    my ( $aa, $ab, $bb ) = @_;
    my $N = $aa + $ab + $bb;
    my $p = ($aa + $ab) > 0 ? (2*$aa + $ab)/(2*$N) : 0;
    my $q = 1 - $p;
    
    my ($eaa, $eab, $ebb) = ( $N * $p**2, $N * 2*$p*$q, $N * $q**2);
    
    my $daa = abs($aa - $eaa) > 0 ? ($aa - $eaa)**2 / $eaa : 0; 
    my $dab = abs($ab - $eab) > 0 ? ($ab - $eab)**2 / $eab : 0; 
    my $dbb = abs($bb - $ebb) > 0 ? ($bb - $ebb)**2 / $ebb : 0; 
    
    my $chi = sprintf "%.2f", ($daa + $dab + $dbb);
#return ($p,$q, $eaa, $eab, $ebb, $daa, $dab, $dbb, $chi);

	$p =  sprintf "%.2f", $p * 100;
	$q =  sprintf "%.2f", $q * 100;

    return ($p,$q,$chi);
}

sub geno2prob {
    my ( $aa, $ab, $bb ) = @_;
    my $N = $aa + $ab + $bb;
    
    my $paa= sprintf "%.2f", $aa > 0 ? $aa / $N * 100 : 0; 
    my $pab= sprintf "%.2f", $ab > 0 ? $ab / $N * 100 : 0;
    my $pbb= sprintf "%.2f", $bb > 0 ? $bb / $N * 100 : 0;
    
    return($paa, $pab, $pbb)
}

sub VCF2BED_0{

	# 0-based bed
	my ($chr, $bp, $ref, $alt, @remain) = @_;

	my $ref_len = length $ref;
	my $var_len = length $alt;
	my $line ;

	if( $ref_len + $var_len == 2 ){
		$line = join "\t", $chr, $bp-1, $bp, (join ";", @remain);
	}elsif( $ref_len == 1 && $var_len >1){
		$line = join "\t", $chr, $bp, $bp, (join ";", @remain);
	}elsif( $ref_len > 1 ){
		$line = join "\t", $chr, $bp-1, $bp + $ref_len, (join ";", @remain);
	}

}


sub VCF2BED_1{
	
	# 1-based bed
	my ($chr, $bp, $ref, $alt, @remain) = @_;

	my $ref_len = length $ref;
	my $var_len = length $alt;
	my $line ;

	if( $ref_len + $var_len == 2 ){
		$line = join "\t", $chr, $bp, $bp, (join ";", @remain);
	}elsif( $ref_len == 1 && $var_len >1){
		$line = join "\t", $chr, $bp, $bp+1, (join ";", @remain);
	}elsif( $ref_len > 1 ){
		$line = join "\t", $chr, $bp, $bp + $ref_len, (join ";", @remain);
	}

}

sub aa_hash {
	%aa_hash=(
	  Ala=>'A',
	  Arg=>'R',
	  Asn=>'N',
	  Asp=>'D',
	  Cys=>'C',
	  Glu=>'E',
	  Gln=>'Q',
	  Gly=>'G',
	  His=>'H',
	  Ile=>'I',
	  Leu=>'L',
	  Lys=>'K',
	  Met=>'M',
	  Phe=>'F',
	  Pro=>'P',
	  Ser=>'S',
	  Thr=>'T',
	  Trp=>'W',
	  Tyr=>'Y',
	  Val=>'V',
	  Sec=>'U',          
	  Pyl=>'O',
	);
	return(%aa_hash)
}

sub snpsift_anno_string_to_4Class {
    my $str=$_[0];
    my $type="";

    if($str =~ /frameshift/){
        $type = "frameshift"

    }elsif($str =~ /missense/){
        $type = "missense"

    }elsif($str =~ /(nonsense|stop_gained)/){
        $type = "nonsense"

    }elsif($str =~ /(splice_acceptor|splice_donor)/){
        $type = "splice"

    }

    return($type)
}

sub oncotator_anno_string_to_4Class {
    my $str=$_[0];
    my $type="";

    if($str =~ /Frame_Shift/i){
        $type = "frameshift"

    }elsif($str =~ /Missense/i){
        $type = "missense"

    }elsif($str =~ /Nonsense/i){
        $type = "nonsense"

    }elsif($str =~ /Splice_Site/){
        $type = "splice"

    }

    return($type)
}

sub show_hash {
    my %h = @_;
    map { print join "\t", $_, $h{$_} } sort keys %h
}




sub show_hash2 {
    my %h = @_;
    my @k1 = sort keys %h;
    
    for my $i (@k1){
        map { print join "\t", $i, $_, $h{$i}{$_} } sort keys %{ $h{$i} }
    }
}


sub show_matrix {
    my %matrix = @_;
    
    my %titles;
    for my $i ( keys %matrix ) {
        @titles{ keys %{ $matrix{$i} } } = undef;
    }

    my @title = sort { $a cmp $b } keys %titles;

	print join( "\t", "probeset_id", @title ), "\n";

	foreach my $i ( sort { $a cmp $b } keys %matrix ) {
   		my @tmp;
	    foreach my $j (@title) {

		#print "$i  $j      $matrix{$i}{$j}\n";
		push @tmp, defined $matrix{$i}{$j}
		? $matrix{$i}{$j}
		: ".";
		}
		print join( "\t", $i, @tmp ), "\n";
	}

}

sub convert_hash2_to_hash1_by_delim {
    my %h = %{ $_[0] };  ## hash2
    my $delim = $_[1] || ",";
    my %h2;
        
    map { $h2{$_} = join "\t", (join $delim, sort keys %{ $h{$_} }), (keys %{ $h{$_} })+0 } sort keys %h; 
    
    return(%h2)
}

sub Alt_Freq {
	my ($A,$B) = split ",", $_[0];
	return( sprintf "%.2f", $B / ($A+$B) * 100 )
}

sub percent { 
	return (sprintf "%.$_[1]f",$_[0]*100) 
}

sub round { 
	sprintf("%.$_[1]f", $_[0]);
}

sub GenoMatchType_detail{

	$geno{"0/0-0/0"} = "rHom";
	$geno{"0/0-0/1"} = "rHomHet";
	$geno{"0/0-1/1"} = "rHomaHom";
	$geno{"0/1-0/0"} = "HetrHom";
	$geno{"0/1-0/1"} = "Het";	
	$geno{"0/1-1/1"} = "HetaHom";		
	$geno{"1/1-0/0"} = "aHomrHom";	
	$geno{"1/1-0/1"} = "aHomHet";	
	$geno{"1/1-1/1"} = "aHom";	
	
	return($geno{join "-", @_} || "UnEval");
}

sub GenoMatchType{

	$geno{"0/0-0/0"} = "Hom";
	$geno{"0/0-0/1"} = "Het";
	$geno{"0/0-1/1"} = "Hom";
	$geno{"0/1-0/0"} = "Het";
	$geno{"0/1-0/1"} = "Het";	
	$geno{"0/1-1/1"} = "Het";		
	$geno{"1/1-0/0"} = "Hom";	
	$geno{"1/1-0/1"} = "Het";	
	$geno{"1/1-1/1"} = "Hom";	
	
	return($geno{join "-", @_} || "UnEval");
}

sub random{
	return( int(rand($_[0]))+1 )
}

sub DMR_make_cov_file{

	my ($tag, $group, $ids, $h) = @_;
	my @ids = @{$ids};
	my %h =   %{$h};

	if( @ids > 1 ){
		map { $file= $h{$_};  print join "\t", $tag, $id, $file, $group } @ids
	}else{
		$id=$ids[0];
		map { $file=$h{$id}; print join "\t", $tag, $id."_".$_, $file, $group } 1,2; 
	}
}


sub fastq2id{

	$_[0] =~/\/.+\/(.+?)_\w{6,8}_L/;
	return($1)
}


sub args2list{

	$_[0] =~ s/\s+//g;
	return( map { --$_ } split ",", $_[0] );
}

sub read_matrix_list_num {

	## += num 
    my %M;

    for my $file (@_) {
        open my $F, $file
          or die "Cannot read $file\n";

        my $header = <$F>;
        chomp $header;
        my @col = split "\t", $header;

        while (<$F>) {
            chomp;
            my @F = split "\t";

            map { $M{ $F[0] }{ $col[$_] } += $F[$_] if $F[$_] =~ /\d+/ }
              1 .. $#F;
        }
        close $F;
    }
    return %M;
}


sub read_matrix_list_string {

	## = "string" 
    my %M;

    for my $file (@_) {
        open my $F, $file
          or die "Cannot read $file\n";

        my $header = <$F>;
        chomp $header;
        my @col = split "\t", $header;

        while (<$F>) {
            chomp;
            my @F = split "\t";

            map { $M{ $F[0] }{ $col[$_] } = $F[$_] } 1 .. $#F;
        }
        close $F;
    }
    return %M;
}


sub isSNVType {
	($ref, $alt) = @_;
	
	if( $ref eq "-" ){
		$type = "Insertion"
	}elsif( $alt eq "-" ){
		$type = "Deletion"
	}elsif( length($ref.$alt) == 2 ){
		$type = "SNP"
	}else{ 
		$type = "MNP"
	}
	
	return $type
}


1;
__END__

perltoc 은 perldoc 에 대한 내용을 정리한 document 인데,
이 중에서 원하는 모듈이나 내용이 어디에 있는지 찾을 때,
사용하는 스크립트

perldoc -t perltoc | perl -nle "print if /단어/"


어떤 doc 에서 모듈을 사용하는 방법

perldoc -t perl | perl -MList::Util=shuffle -nle"/^\s*perl\w/ and push @L,$_;END{print((shuffle@L)[0])}"








sub cancer_gDNA {
        my %h=();

        @gDNA = $_[0] =~ /:(g\.\d+.+?)[\$,]/g;
        map { $h{"$_[1]:$_"} ++ } @gDNA;
        
        return ( join ",", sort keys %h ) 
}

sub cancer_cDNA { 
        my %h=();

        @cDNA = $_ =~ /:(c..+?)[\$,]/g;
        map { $h{$_} ++ } @cDNA;

        return ( join ",", sort keys %h ) 
}


sub cancer_var { 
        my %h=();

        @var = $_ =~ /:(p..+?)[\$,]/g;
        map { $h{ cancer_3to1($_) } ++ } @var;

        return ( join ",", sort keys %h ) 
}

sub cancer_3to1 {

        $var = $_[0];
        %aa=aa_hash();
 
        if( $var=~ /(\w{3})(\d+)_(\w{3})(\d+)ins(\w+)/ ){
                $pre = $aa{$1}.$2."_".$aa{$3}.$4."ins";
                $remain = $5;
                @aa = $remain =~ /(\w{3})/g;

                $str = $pre.(join "", map { $aa{$_} } @aa);
                    #print join "\t", $var, $str, $remain;
        }elsif( $var =~ /(\w{3})(\d+)_(\w{3})(\d+)del/ ){
                $str = $aa{$1}.$2."_".$aa{$3}.$4."del";
        }elsif( $var =~ /(\w{3})(\d+)del/ ){
                    $str = $aa{$1}.$2."del"
        }elsif( $var =~/(\w{3})(\d+)fs/ ){
                    $str = $aa{$1}.$2."fs";
        }elsif( $var =~/(\w{3})(\d+)\*/ ){
                    $str = $aa{$1}.$2."*"
        }elsif( $var =~/(\w{3})(\d+)(\w{3})/ ){
                    $str = $aa{$1}.$2.$aa{$3};
        }

        return $str
}



