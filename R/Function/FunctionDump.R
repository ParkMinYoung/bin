FunctionDump <-
function(funs){
  
  funs_file = paste(funs, "R", sep=".")
  target_dir = "/home/adminrig/src/short_read_assembly/bin/R/Function"
  cmd = paste("mv -f", funs_file, target_dir, sep=" ")
  
  dump(eval(funs), file=funs_file)
  system(cmd)
  #print(cmd) 
}
