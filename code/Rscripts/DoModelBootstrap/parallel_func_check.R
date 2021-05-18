fun <- function(x){
  
  return(x+1)
  
} # END OF FUNCTION


#load parallel
t0 <- proc.time()
library(parallel)

#detectCores core num
clnum<-detectCores(logical = F) 
#initial cl
cl <- makeCluster(getOption("cl.cores", clnum))
#RUN
ntimes <- 1e6
res <- parLapply(cl, 1:ntimes,  fun)

#clear cl
stopCluster(cl)

tend <- proc.time()
tall = tend-t0
tall
# print(paste0('total cost:', tall[3][[1]]/60, 1), 'mins'))