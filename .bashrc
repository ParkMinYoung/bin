# .bashrc

source ~/.bash_function

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

set -o emacs


# User specific aliases and functions


# CASAVA 1.7
#PATH=$PATH:/home/adminrig/src/CASAVA/bin
# CASAVA 1.8
PATH=$PATH:/home/adminrig/src/Maker/maker/src/mpich2.install/bin
PATH=$PATH:/home/adminrig/bin:/home/adminrig/bin/x86_64:/home/adminrig/src/short_read_assembly/bin:/home/adminrig/src/OLB/OLB-1.9.0/python/setup:/home/adminrig/src/CASAVA/bin
PATH=$PATH:/home/adminrig/lib
PATH=$PATH:/home/adminrig/src/CASAVA/CASAVA1.8/bin/:$HOME/perl/bin/:/home/adminrig/src/PolyPhen-2/polyphen-2.1.0/bin
PATH=$PATH:/home/adminrig/src/Maker/maker/src/gm_es_bp_linux64_v2.3e/gmes
PATH=$PATH:/home/adminrig/src/Maker/maker/src/genemark_suite_linux_64/gmsuite
PATH=$PATH:/home/adminrig/src/Maker/maker/bin
PATH=$PATH:/home/adminrig/src/biopiece/scan_for_matches
PATH=$PATH:/home/adminrig/src/homer/bin
PATH=$PATH:/home/adminrig/src/weblogo/
PATH=$PATH:/home/adminrig/src/ngsplot/ngsplot/bin
PATH=${PATH}:~/.local/bin

# for bcl2fastq #
PATH=${PATH}:~/apps/bin 


export PATH=$PATH:/home/adminrig/include

# PERL DEPENDANCY based on linux version

LINUX_VERSION=$(uname -r)

PERL5LIB=${PERL5LIB}:/home/adminrig/src/short_read_assembly/bin
if [ $LINUX_VERSION == "2.6.32-279.14.1.el6.x86_64" ];then ## 93

	PERL5LIB=${PERL5LIB}:$HOME/src/vcf-tools/vcftools_0.1.5/perl
	export PERL5LIB=$PERL5LIB:/home/jin/lib64/perl5/:/home/jin/share/perl5:/home/jin/perl5/lib/perl5

elif [ $LINUX_VERSION == "2.6.32-642.4.2.el6.x86_64" ];then ## 69 server
	export PERL5LIB
elif [ $LINUX_VERSION == "3.10.0-957.1.3.el7.x86_64" ];then ## 73 server
	export PERL5LIB
else 

	PERL5LIB=${PERL5LIB}:$HOME/perl/lib/perl5
	PERL5LIB=${PERL5LIB}:$HOME/perl/lib/perl5/site_perl/5.8.8
	PERL5LIB=${PERL5LIB}:$HOME/perl5/lib/perl5
	PERL5LIB=${PERL5LIB}:$HOME/src/vcf-tools/vcftools_0.1.5/perl
#	PERL5LIB=${PERL5LIB}:${HOME}/src/ENSEMBL/BioPerl/bioperl-live
#	PERL5LIB=${PERL5LIB}:${HOME}/src/ENSEMBL/BioPerl/ensembl/modules
#	PERL5LIB=${PERL5LIB}:${HOME}/src/ENSEMBL/BioPerl/ensembl-compara/modules
#	PERL5LIB=${PERL5LIB}:${HOME}/src/ENSEMBL/BioPerl/ensembl-variation/modules
#	PERL5LIB=${PERL5LIB}:${HOME}/src/ENSEMBL/BioPerl/ensembl-functgenomics/modules
	PERL5LIB=${PERL5LIB}:${HOME}/src/Maker/maker/lib
	PERL5LIB=${PERL5LIB}:${HOME}/src/Maker/maker/src/inc/lib
	PERL5LIB=${PERL5LIB}:${HOME}/src/Maker/maker/perl/lib
	export PERL5LIB

fi


export PERL_CPANM_OPT="--local-lib=~/perl5"

export PPH=/home/adminrig/src/PolyPhen-2/polyphen-2.1.0


# set History size
#HISTTIMEFORMAT='%Y-%m-%d %H:%M:%S '
#export HISTTIMEFORMAT

export HISTSIZE=100000
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH

# for kent src

export MACHTYPE=x86_64
export MYSQLLIBS="/usr/lib64/mysql/libmysqlclient.a -lz"
export MYSQLINC=/usr/include/mysql

# JAVA

CLASSPATH=$SGE_ROOT/lib/drmaa.jar
CLASSPATH=$CLASSPATH:/home/adminrig/src/BAMBINO/bambino_core.jar:/home/adminrig/src/BAMBINO/mysql.jar:/home/adminrig/src/BAMBINO/bambino_bundle.jar:/home/adminrig/src/BAMBINO/sam.jar
export CLASSPATH

# NEWBLER
export ALLOW_ROCKS=1


if [ -z ${LD_LIBRARY_PATH} ] && [ ${#LD_LIBRARY_PATH} -ge 5 ];then

	export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/adminrig/src/Maker/maker-2.24/mpich2-1.4.1p1/mpich2-.install/lib:/home/adminrig/src/matlab_compiler_runtime/build/v81/runtime/glnxa64:/home/adminrig/src/matlab_compiler_runtime/build/v81/bin/glnxa64:/home/adminrig/src/matlab_compiler_runtime/build/v81/sys/os/glnxa64:/home/adminrig/src/matlab_compiler_runtime/build/v81/sys/java/jre/glnxa64/jre/lib/amd64/native_threads:/home/adminrig/src/matlab_compiler_runtime/build/v81/sys/java/jre/glnxa64/jre/lib/amd64/server:/home/adminrig/src/matlab_compiler_runtime/build/v81/sys/java/jre/glnxa64/jre/lib/amd64:/home/adminrig/src/sqlite3/lib

else
	export LD_LIBRARY_PATH=/home/adminrig/src/Maker/maker-2.24/mpich2-1.4.1p1/mpich2-.install/lib:/home/adminrig/src/matlab_compiler_runtime/build/v81/runtime/glnxa64:/home/adminrig/src/matlab_compiler_runtime/build/v81/bin/glnxa64:/home/adminrig/src/matlab_compiler_runtime/build/v81/sys/os/glnxa64:/home/adminrig/src/matlab_compiler_runtime/build/v81/sys/java/jre/glnxa64/jre/lib/amd64/native_threads:/home/adminrig/src/matlab_compiler_runtime/build/v81/sys/java/jre/glnxa64/jre/lib/amd64/server:/home/adminrig/src/matlab_compiler_runtime/build/v81/sys/java/jre/glnxa64/jre/lib/amd64:/home/adminrig/src/sqlite3/lib

fi


export XAPPLRESDIR=/home/adminrig/src/matlab_compiler_runtime/build/v81/X11/app-defaults


#DISPLAY=localhost:0.0
#export DISPLAY

# For SNAP gene finding tools
export ZOE=/home/adminrig/src/Maker/maker/src/snap/Zoe
export AUGUSTUS_CONFIG_PATH=/home/adminrig/src/Maker/maker/src/augustus.2.5.5/config/

# wgs-assembler
export PATH=/home/adminrig/src/wgs-7.0/Linux-amd64/bin:$PATH



PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

# >>>>>>>>>>>>>>>>>>>>>>> Enabling Biopieces if installed <<<<<<<<<<<<<<<<<<<<<<<

# Installation instructions:
# http://code.google.com/p/biopieces/wiki/Installation

# Modify the below paths according to your settings.
# If you have followed the installation instructions step-by-step
# the below should work just fine.

export BP_DIR="$HOME/src/biopiece/biopieces-read-only"  # Directory where biopieces are installed
export BP_DATA="$HOME/src/biopiece/BP_DATA"   # Contains genomic data etc.
export BP_TMP="$HOME/src/biopiece/tmp"        # Required temporary directory.
export BP_LOG="$HOME/src/biopiece/BP_LOG"     # Required log directory.

if [ -f "$BP_DIR/bp_conf/bashrc" ]; then
    source "$BP_DIR/bp_conf/bashrc"
	fi  

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


#RNASeq
export STAR=/home/adminrig/src/STAR/STAR_2.3.0e.Linux_x86_64/STAR

#temp
export PATH=/home/adminrig/workspace.test/2014.12.29_brca_test/brca_diagnostic:$PATH

MANPATH=$MANPATH:$HOME/share/man


####### workspace_pyg #######
export YG68LINK=adminrig@211.174.205.68:/data/public/GWAS_PYG
export YG91LINK=uploader@211.174.205.91:/dat02/public/GWAS_PYG
export YG91NGSLINK=uploader@211.174.205.91:/dat02/public/NGS_PYG

export YGHIGHQ8="qsub -pe orte 8 -q high.q -V -cwd -S /bin/bash"
export YGHIGHQ4="qsub -pe orte 4 -q high.q -V -cwd -S /bin/bash"
export YGHIGHQ2="qsub -pe orte 2 -q high.q -V -cwd -S /bin/bash"
export YGHIGHQ1="qsub -pe orte 1 -q high.q -V -cwd -S /bin/bash"

export YGUTLQ8="qsub -pe orte 8 -q utl.q -V -cwd -S /bin/bash"
export YGUTLQ4="qsub -pe orte 4 -q utl.q -V -cwd -S /bin/bash"
export YGUTLQ2="qsub -pe orte 2 -q utl.q -V -cwd -S /bin/bash"
export YGUTLQ1="qsub -pe orte 1 -q utl.q -V -cwd -S /bin/bash"

export YGK1stC1="/home/adminrig/workspace.pyg/GWAS/script/Axiom/protocol/1stCall/Axiom_KORV1.0.sh"
export YGK1stC2="/home/adminrig/workspace.pyg/GWAS/script/Axiom/protocol/1stCall/Axiom_KORV1.1.sh"
export YGK2ndC1="/home/adminrig/workspace.pyg/GWAS/script/Axiom/protocol/2ndCall/Axiom_KORV1.0.sh"
export YGK2ndC2="/home/adminrig/workspace.pyg/GWAS/script/Axiom/protocol/2ndCall/Axiom_KORV1.1.sh"

export YGK1stQ1="/home/adminrig/workspace.pyg/GWAS/script/Axiom/protocol/1stQC/QC_5k_single.sh"
export YGK1stQ2="/home/adminrig/workspace.pyg/GWAS/script/Axiom/protocol/1stQC/QC_5k_single_kchip1.1.sh"
export YGK2ndQ1_step1="/home/adminrig/workspace.pyg/GWAS/script/Axiom/protocol/2ndQC/QC_5k_single.sh"
export YGK2ndQ1_step2="/home/adminrig/workspace.pyg/GWAS/script/Axiom/protocol/2ndQC/QC_5k_single_LatterHalf.sh"
export YGK2ndQ2_step1="/home/adminrig/workspace.pyg/GWAS/script/Axiom/protocol/2ndQC/QC_5k_single_kchip1.1.sh"
export YGK2ndQ2_step2="/home/adminrig/workspace.pyg/GWAS/script/Axiom/protocol/2ndQC/QC_5k_single_LatterHalf_kchip1.1.sh"

export YGK1="/home/adminrig/workspace.pyg/GWAS/array/Axiom_KORV1.1"
export YGK0="/home/adminrig/workspace.pyg/GWAS/array/Axiom_KORV1.0"

export Axiom_Analysis="/home/adminrig/workspace.pyg/GWAS/script/Axiom/Axiom_Analysis.sh"

export Broken_Link="find . -type l | (while read line ; do test -e \$line || ls -ld \$line; done)"


# added by Miniconda2 installer
#export PATH="/home/adminrig/miniconda2/bin:$PATH"



