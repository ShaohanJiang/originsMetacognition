rm(list=ls())
#setwd("d:/HCPDATA/R_analysis/R_example/")


library(OpenMx)
library(psych); library(polycor)
library(R.matlab)
source("miFunctions.R")
source("MetaTwinsFunction.R")
# foreach
# library(foreach)
# library(doParallel)


twininfo <- read.table("HCPtwinsinfo.csv",header = TRUE,sep = ",")
twindataraw <- read.table("networkmean900_Yeo17.csv",header = TRUE,sep = ",")

mzinfo <- subset(twininfo, zygcode==1)
dzinfo <- subset(twininfo, zygcode==2)

mzDataall <- c()
dzDataall <- c()
ii <- 1
ntimes <-1000
chunk.size <- 62
for(tt in (1:ntimes)){
  mzData <- data.frame(thisroi1 = twindataraw[mzinfo$twinAno,ii], thisroi2 = twindataraw[mzinfo$twinBno,ii])
  dzData <- data.frame(thisroi1 = twindataraw[dzinfo$twinAno,ii], thisroi2 = twindataraw[dzinfo$twinBno,ii])
  nmz <- nrow(mzData)
  ndz <- nrow(dzData)
  mzData <- mzData[sample(c(1:nmz),62), ]
  dzData <- dzData[sample(c(1:ndz),62), ]
  
  mzDataall <- rbind(mzDataall, mzData)
  dzDataall <- rbind(dzDataall, dzData)
}


# rest.s <- matrix(0, nrow=ntimes, ncol = 1)
# ress.SAT<-c()
# ress.ACE <-c()
# ress.ADE <- c()
# system.time(
#   for(i in 1:ntimes){
#     thischunk <- ((i-1)*chunk.size+1):(i*chunk.size)
#     restmp <- SATmodelCompare(mzDataall[thischunk,], dzDataall[thischunk,])
#     ress.SAT <- rbind(ress.SAT, restmp)
    # restmp <- ACEmodelCompare(mzDataall[thischunk,], dzDataall[thischunk,])
    # ress.ACE <- rbind(ress.ACE, restmp)
    # restmp <- ADEmodelCompare(mzDataall[thischunk,], dzDataall[thischunk,])
    # ress.ADE <- rbind(ress.ADE, restmp)
#   }
# )


# Real physical cores in the computer
cores <- detectCores(logical=F)
cl <- makeCluster(cores)
registerDoParallel(cl, cores=cores)

# split data by ourselves
# chunk.size <- len/cores

# res2.p <- matrix(0, nrow=ntimes, ncol = 1)

system.time(
  resp.SAT <- foreach(i=1:ntimes, .combine='rbind', .packages = "OpenMx") %dopar%
    {  # local data for results
      thischunk <- ((i-1)*chunk.size+1):(i*chunk.size)
      res <- SATmodelCompare(mzDataall[thischunk,], dzDataall[thischunk,])
      return(res)
    }
)

system.time(
  resp.ACE <- foreach(i=1:ntimes, .combine='rbind', .packages = "OpenMx") %dopar%
    {  # local data for results
      thischunk <- ((i-1)*chunk.size+1):(i*chunk.size)
      res <- ACEmodelCompare(mzDataall[thischunk,], dzDataall[thischunk,])
      return(res)
    }
)
stopImplicitCluster()
stopCluster(cl)

cl <- makeCluster(cores)
registerDoParallel(cl, cores=cores)
system.time(
  resp.ADE <- foreach(i=1:ntimes, .combine='rbind', .packages = "OpenMx") %dopar%
    {  # local data for results
      thischunk <- ((i-1)*chunk.size+1):(i*chunk.size)
      res <- ADEmodelCompare(mzDataall[thischunk,], dzDataall[thischunk,])
      return(res)
    }
)

stopImplicitCluster()
stopCluster(cl)
save(resp.SAT, resp.ACE, resp.ADE, file = "testres1004")

# Real physical cores in the computer
# cores <- detectCores(logical=F)
# cl <- makeCluster(cores)
# registerDoParallel(cl, cores=cores)
# # split data by ourselves
# core.size <- ntimes*chunk.size/cores

# res2.p <- matrix(0, nrow=ntimes, ncol = 1)
# system.time(
#   rest2.p <- foreach(i=1:cores, .combine='rbind', .packages = "OpenMx") %dopar%
#     {  # local data for results
#       thischunk <- ((i-1)*core.size+1):(i*core.size)
#       thismzdata <- mzDataall[thischunk,]
#       thisdzdata <- dzDataall[thischunk,]
#       nn.tmp <- core.size/chunk.size
#       res.tmp <- matrix(0, nrow=nn.tmp, ncol=1)
#       for(nn in 1:nn.tmp){
#         thisidx <- ((nn-1)*chunk.size+1):(nn*chunk.size)
#         res.tmp[nn,] <- test.twins(mzDataall[thisidx,], dzDataall[thisidx,])
#       }
#       res.tmp
#       
#     }
# )
# stopImplicitCluster()
# stopCluster(cl)
