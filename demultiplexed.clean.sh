find 0?? -type l | xargs rm
find 0??/ -maxdepth 1 -type d | grep Sequence | xargs rm -rf
find 0?? | grep nohup | xargs rm
find 0?? |grep parsing | xargs rm
