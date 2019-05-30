if [ ! -z $1 ]
then
proccomm="ps -e -o pcpu,cpu,nice,state,cputime,args --sort pcpu | grep $1"
else
proccomm="ps -e -o pcpu,cpu,nice,state,cputime,args --sort pcpu"
fi
eval $proccomm

STR=AxiomGT1.calls.txt.extract.plink_fwd.gender

PMR=/home/adminrig/workspace.pyg/GWAS/array/PMR/161107/batch/$STR.???
BioBank=/home/adminrig/workspace.pyg/GWAS/array/Biobank/161109/batch/$STR.???
UKBioBank=/home/adminrig/workspace.pyg/GWAS/array/UKBiobank/161110/batch/$STR.???
KORV1_1=/home/adminrig/workspace.pyg/GWAS/array/Axiom_KORV1.1/161114_PMR_48rescan/batch/$STR.???



for i in PMR BioBank UKBioBank KORV1_1
     do 
#     y=$(eval echo '$'$i)
     y=$(eval echo \$$i)
     #echo $y
     (mkdir $i && cd $i && ln -s $y ./ && rename $STR $i $STR.???)
done


