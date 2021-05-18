fun <- function(x){
  # setwd("D:/Documents/ScriptR/DoModelBootstrap")
  
  library(OpenMx)
  library(psych); library(polycor)
  library(R.matlab)
  source("miFunctions.R")
  source("MetaTwinsFunction.R")

  # twinDataraw <-read.table("RDMin1.csv", header = TRUE, sep = ",", na.strings = "NA")
  # twinDataraw <-read.table("StrangerMental.csv", header = TRUE, sep = ",", na.strings = "NA")
  twinDataraw <-read.table("TwinMental.csv", header = TRUE, sep = ",", na.strings = "NA")
  
  # twinData = subset(twinDataraw, !(twinDataraw$twinsNum %in% c('T001','T007','T013','T028','T035','T053','T054','T055','T087','T090')))
  twinData = twinDataraw
  
  # args<-commandArgs(T)
  # iirange <- args[1]:args[2]
  #
  # print(maxfiles)
  # 
  chunk.size <- 40
  
  vars <- "myiscgamma" # list of variables names
  nv <- 1 # number of variables
  ntv <- nv*2 # number of total variables
  selVars <- paste(vars,c(rep(1,nv),rep(2,nv)),sep="")

  mzData <- subset(twinData, zyg==1, selVars)
  dzData <- subset(twinData, zyg==2, selVars)
  
  nmz <- nrow(mzData)
  ndz <- nrow(dzData)
  mzData <- mzData[sample(c(1:nmz), chunk.size), ]
  dzData <- dzData[sample(c(1:ndz), chunk.size), ]
  
  
  satres <- SATmodelCompare(mzData, dzData, vars)
  aceres <- ACEmodelCompare(mzData, dzData, vars)
  aderes <- ADEmodelCompare(mzData, dzData, vars)
  
  return(list(satres,aceres,aderes))
  
} # END OF FUNCTION



#load parallel
t0 <- proc.time()
library(parallel)

setwd("D:/Documents/ScriptR/DoModelBootstrap")

vars <- "myiscgamma"
resfolder = paste("res_modelcomp/",vars,sep = "")
maxfiles <- 50
ntimes <-200

# AUTO detect existed files
if(!dir.exists(resfolder)){
  dir.create(resfolder)
  nosuffix <- 1;
  
}else{
  
  nfiles <- length(dir(resfolder))
  nosuffix <- nfiles+1
  if(nosuffix>maxfiles){
    print(nosuffix)
    stop('Already Has too much files???')
  }
}


#detectCores core num
clnum<-detectCores(logical = F) 
#initial cl
cl <- makeCluster(getOption("cl.cores", clnum))
#RUN
for(mm in nosuffix:maxfiles){ #
  
  # system.time()
  t1 <- proc.time()
  print(paste0('thisiter is:', mm))
  
  res <- parLapply(cl, 1:ntimes,  fun)
  
  # OUTPUT FILES
  fname = paste("testres", ntimes*1e4+mm, sep="")
  pathname =  paste(resfolder,fname,sep = "/")
  save(res, file = pathname)
  print(paste(pathname,"SAVED",sep = " "))
  rm(list='res')
  
  t2 <- proc.time()
  t = t2-t1
  print(paste0('thisiter cost:', round(t[3][[1]],1), 's'))
  
}

#clear cl
stopCluster(cl)

tend <- proc.time()
tall = tend-t0
print(paste0('total cost:', round(tall[3][[1]]/60, 1), 'mins'))

