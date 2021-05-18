
rm(list=ls())
setwd("D:/Documents/ScriptR/DoModelBootstrap")


library(OpenMx)
library(psych); library(polycor)
library(R.matlab)
source("miFunctions.R")
source("MetaTwinsFunction.R")
# foreach
library(foreach)
library(doParallel)


twinDataraw <-read.table("RDMin1.csv", header = TRUE, sep = ",", na.strings = "NA")
# twinDataraw <-read.table("StrangerMental.csv", header = TRUE, sep = ",", na.strings = "NA")
# twinDataraw <-read.table("TwinMental.csv", header = TRUE, sep = ",", na.strings = "NA")

twinData = subset(twinDataraw, !(twinDataraw$twinsNum %in% c('T001','T007','T013','T028','T035','T053','T054','T055','T087','T090')))
# twinData = twinDataraw

args<-commandArgs(T)
iirange <- args[1]:args[2]
maxfiles <- as.double(args[3])
print(maxfiles)
ntimes <-8
chunk.size <- 40
# maxfiles <- 500

vars <- "mrtime" # list of variables names
nv <- 1 # number of variables
ntv <- nv*2 # number of total variables
selVars <- paste(vars,c(rep(1,nv),rep(2,nv)),sep="")



# initial parfor parameter
# Real physical cores in the computer
cores <- detectCores(logical=F)-1
cl <- makeCluster(cores)
registerDoParallel(cl, cores=cores)

system.time(
  
  for(ii in iirange){ # each roi
    
    resfolder = paste("res_modelcomp/",vars,sep = "")
    if(!dir.exists(resfolder)){
      dir.create(resfolder)
      nosuffix <- 1;
      
    }else{
      
      nfiles <- length(dir(resfolder))
      nosuffix <- nfiles+1
      if(nosuffix>maxfiles){
        print(nosuffix)
        next
      }
    }
    
    
    for(mm in (nosuffix:maxfiles)){ # each res file
      print(paste(ii,mm,sep = "_"))
      
      mzDataall <- c()
      dzDataall <- c()
      
      
      for(tt in (1:ntimes)){
        
        
        
        # Select Data for Analysis
        mzData <- subset(twinData, zyg==1, selVars)
        dzData <- subset(twinData, zyg==2, selVars)
        
        nmz <- nrow(mzData)
        ndz <- nrow(dzData)
        mzData <- mzData[sample(c(1:nmz), chunk.size), ]
        dzData <- dzData[sample(c(1:ndz), chunk.size), ]
        
        mzDataall <- rbind(mzDataall, mzData)
        dzDataall <- rbind(dzDataall, dzData)
      }
      
      
      # 
      resp.SAT <- foreach(i=1:ntimes, .combine='rbind', .packages = "OpenMx") %dopar%
        {  # local data for results
          thischunk <- ((i-1)*chunk.size+1):(i*chunk.size)
          res <- SATmodelCompare(mzDataall[thischunk,], dzDataall[thischunk,], vars)
          return(res)
        }
      # )
      print("SAT DONE")
      
      # system.time(
      resp.ACE <- foreach(i=1:ntimes, .combine='rbind', .packages = "OpenMx") %dopar%
        {  # local data for results
          thischunk <- ((i-1)*chunk.size+1):(i*chunk.size)
          res <- ACEmodelCompare(mzDataall[thischunk,], dzDataall[thischunk,], vars)
          return(res)
        }
      # )
      print("ACE DONE")
      
      # system.time(
      resp.ADE <- foreach(i=1:ntimes, .combine='rbind', .packages = "OpenMx") %dopar%
        {  # local data for results
          thischunk <- ((i-1)*chunk.size+1):(i*chunk.size)
          res <- ADEmodelCompare(mzDataall[thischunk,], dzDataall[thischunk,], vars)
          return(res)
        }
      # )
      print("ADE DONE")
      
      fname = paste("testres", ntimes*1e4+mm, sep="")
      pathname =  paste(resfolder,fname,sep = "/")
      save(resp.SAT, resp.ACE, resp.ADE, file = pathname)
      
      print(paste(pathname,"SAVED",sep = " "))
      rm(list=c("resp.SAT", "resp.ACE", "resp.ADE"))
    }
  }
)

# close Cluster
stopImplicitCluster()
stopCluster(cl)
