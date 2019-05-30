find /microarray/KORV1.1 -type f | grep CEL$ | grep  Axiom_KORV1_1 | xargs -i basename {} | grep -v ^55 | rsync -avz --files-from=- /microarray/KORV1.1/ /home/adminrig/workspace.min/AFFX/Axiom_KORV1.1

