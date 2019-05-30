sudo rm -rf /tmp/rstudio-rsession/
sudo rstudio-server restart
mv -f  ~/.rstudio ~/.rstudio.bak/


sudo fuser -k 8787/tcp
sudo rstudio-server start

