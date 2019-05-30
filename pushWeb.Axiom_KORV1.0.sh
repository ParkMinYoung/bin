## while [ 1 ]
##     do
##     sudo rsync -avzh /home/adminrig/workspace.min/DNALink/AffyChip/Axiom_KORV1.0/ /home/adminrig/workspace.min/211.174.205.50/DNALink/AffyChip/Axiom_KORV1.0
##     sleep 7200
## done
## 

echo "start : "`date`
sudo rsync -avzh /home/adminrig/workspace.min/DNALink/AffyChip/Axiom_KORV1.0/ /home/adminrig/workspace.min/211.174.205.50/DNALink/AffyChip/Axiom_KORV1.0
echo "end   : "`date`
