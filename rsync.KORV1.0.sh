find /microarray/Genetitan -type f | grep CEL$ | grep Axiom_KORV1_0 | xargs -i basename {} | grep -v ^55| rsync -avz --files-from=- /microarray/Genetitan/ /home/adminrig/workspace.min/AFFX/Axiom_KORV1.0 >> /home/adminrig/workspace.min/AFFX/Axiom_KORV1.0.log

