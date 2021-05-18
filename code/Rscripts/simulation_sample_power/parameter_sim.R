

aceSim <- function(xinto, Nmz=50, Ndz=50){
  library(OpenMx)
  require(MASS)
  mxOption(NULL, 'Default optimizer', 'NPSOL')
  
  
  rdmac <- rbind(c(.36, .33, .36, .21, .0, .09, .1, .0),
                 c(.0, .0, .0, .13, .19, .11, .33, .26))
  
  # mentlac <- rbind(c(.46, .24, .31, .0, .54, .21, .25), 
  #                   c(.05, .0, .0, .15, .0, .17, .24))
  
  allac <- rdmac
  add <- allac[1, xinto]
  com <- allac[2, xinto]
  
  nv <- 1
  ntv <- nv*2
  
  AA <- add
  CC <- com
  EE <- 1 - add - com
  
  mzMat <- matrix(c(AA + CC + EE, AA + CC, AA + CC, AA + CC + EE),2)
  dzMat <- matrix(c(AA + CC + EE, .5*AA + CC, .5*AA + CC, AA + CC + EE),2)
  
  mzData <- mvrnorm(Nmz , mu = c(0,0), mzMat, empirical = F)
  dzData <- mvrnorm(Ndz , mu = c(0,0), dzMat, empirical = F)
  
  selVars <- paste("t", 1:2, sep = "")
  colnames(mzData) <- colnames(dzData) <- selVars
  lbPa <- .0001
  
  # Create Algebra for expected Mean Matrices
  meanG <- mxMatrix( type="Full", nrow=1, ncol=ntv, free=TRUE, values=0, labels="mean", name="meanG" )
  
  # Create Matrices for Path Coefficients
  pathA <- mxMatrix( type="Lower", nrow=nv, ncol=nv, free=TRUE, values=.5, labels="a11", lbound=lbPa, name="a" )
  pathC <- mxMatrix( type="Lower", nrow=nv, ncol=nv, free=TRUE, values=.5, labels="c11", lbound=lbPa, name="c" )
  pathE <- mxMatrix( type="Lower", nrow=nv, ncol=nv, free=TRUE, values=.5, labels="e11", lbound=lbPa, name="e" )
  
  # Create Algebra for Variance Components
  covA <- mxAlgebra( expression=a %*% t(a), name="A" )
  covC <- mxAlgebra( expression=c %*% t(c), name="C" )
  covE <- mxAlgebra( expression=e %*% t(e), name="E" )
  
  # Create Algebra for expected Variance/Covariance Matrices in MZ & DZ twins
  covP <- mxAlgebra( expression= A+C+E, name="V" )
  covMZ <- mxAlgebra( expression= A+C, name="cMZ" )
  covDZ <- mxAlgebra( expression= 0.5%x%A+ C, name="cDZ" )
  expCovMZ <- mxAlgebra( expression= rbind( cbind(V, cMZ), cbind(t(cMZ), V)), name="expCovMZ" )
  expCovDZ <- mxAlgebra( expression= rbind( cbind(V, cDZ), cbind(t(cDZ), V)), name="expCovDZ" )
  
  # Create Data Objects for Multiple Groups
  dataMZ <- mxData( observed=mzData, type="raw" )
  dataDZ <- mxData( observed=dzData, type="raw" )
  
  # Create Expectation Objects for Multiple Groups
  expMZ <- mxExpectationNormal( covariance="expCovMZ", means="meanG", dimnames=selVars )
  expDZ <- mxExpectationNormal( covariance="expCovDZ", means="meanG", dimnames=selVars )
  funML <- mxFitFunctionML()
  
  # Create Model Objects for Multiple Groups
  pars <- list( meanG, pathA, pathC, pathE, covA, covC, covE, covP)
  modelMZ <- mxModel( pars, covMZ, expCovMZ, dataMZ, expMZ, funML, name="MZ" )
  modelDZ <- mxModel( pars, covDZ, expCovDZ, dataDZ, expDZ, funML, name="DZ" )
  multi <- mxFitFunctionMultigroup( c("MZ","DZ") )
  
  # Create Algebra for Unstandardized and Standardized Variance Components
  rowUS <- rep('US',nv)
  colUS <- rep(c('A','C','E','SA','SC','SE'),each=nv)
  estUS <- mxAlgebra( expression=cbind(A,C,E,A/V,C/V,E/V), name="US", dimnames=list(rowUS,colUS) )
  
  # Create Confidence Interval Objects
  ciACE <- mxCI( "US[1,1:3]" )
  
  # Build Model with Confidence Intervals
  modelACE <- mxModel( "oneACEc", pars, modelMZ, modelDZ, multi, estUS, ciACE )
  
  # ----------------------------------------------------------------------------------------------------------------------
  # RUN MODEL
  
  # Run ACE Model
  fitACE <- suppressWarnings(mxTryHard( modelACE, intervals=T ))
  
  # aceFit <- suppressWarnings(mxRun(ace, silent = T))
  # summary(aceFit)
  
  # ceFit <- omxSetParameters(aceFit, labels = "A11", free = F, values = 0)
  # ceFit <- suppressWarnings(mxRun(ceFit, silent = T))
  # 
  # aeFit <- omxSetParameters(aceFit, labels = "C11", free = F, values = 0)
  # aeFit <- suppressWarnings(mxRun(aeFit, silent = T))
  # 
#   ncpA <- (ceFit$output$Minus2LogLikelihood - aceFit$output$Minus2LogLikelihood)/(dim(mzData)[1] + dim(dzData)[1])
#   ncpC <- (aeFit$output$Minus2LogLikelihood - aceFit$output$Minus2LogLikelihood)/(dim(mzData)[1] + dim(dzData)[1])
#   
#   
  Ests <-    as.data.frame(cbind(add, com, fitACE$US$result[4], fitACE$US$result[5]))
  colnames(Ests) <- c("Simulated_a", "Simulated_c", "Estimated_a", "Estimated_c")
  Ests$Difference <- Ests$Estimated_c - Ests$Estimated_a
  Ests <- round(Ests, 5)
  # Imprecision <- sum(Ests$Difference)
#   
#   
#   if( Imprecision > .02 ) warning("The estimated values may differ from the simulated values more than you are comfortable with. 
# Make sure you double check these values. You may want to increase the sample size ", call. = F)
  return ( list(Parameters = Ests)) #, WncpA = ncpA, WncpC =ncpC
  
} # aceSim()


#load parallel
t0 <- proc.time()
library(parallel)

setwd("E:/ShaohanData/simulation_sample_power")

if(!dir.exists("res_paraRecov")){dir.create("res_paraRecov")}

rdmvars <- paste0('rdm', c('1diff', '4mconf', '2mrt', '3stdrt',
                        '5rtcorr', '6gamma', '7auc', '8aucresid'))

# mentlvars <- c(paste0('tw', c('1rtweight', '2gamma', '3auc', '4aucresid')),
#                    paste0('Strg', c('1rtweight', '2gamma', '3auc')))

allvars <- rdmvars

for (ii in 1:length(allvars)){
  vars <- allvars[ii]
  resfolder = paste("res_paraRecov/", vars, sep = "")
  maxfiles <- 20
  ntimes <-500
  xinto <- rep(ii, ntimes)
  
  # AUTO detect existed files
  if(!dir.exists(resfolder)){
    dir.create(resfolder)
    nosuffix <- 1;
    
  }else{
    
    nfiles <- length(dir(resfolder))
    nosuffix <- nfiles+1
    if(nosuffix>maxfiles){
      # print(nosuffix)
      stop(paste0('File ',nosuffix,'! Already Has too much files???'))
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
    
    # res <- parLapply(cl,  1:ntimes,  aceSim)
    
    res <- parLapply(cl,  xinto,  aceSim)
    
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
}#for rdmvars
#clear cl
stopCluster(cl)

tend <- proc.time()
tall = tend-t0
print(paste0('total cost:', round(tall[3][[1]]/60, 1), ' mins. At ', Sys.time()))

