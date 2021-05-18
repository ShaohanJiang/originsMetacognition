require(OpenMx)
require(MASS)
mxOption(NULL, 'Default optimizer', 'NPSOL')
source("powerFun.R")


acePow <- function(add, com, Nmz, Ndz){
  
  nv <- 1
  ntv <- nv*2
  
  AA <- add
  CC <- com
  EE <- 1 - add - com
  
  mzMat <- matrix(c(AA + CC + EE, AA + CC, AA + CC, AA + CC + EE),2)
  dzMat <- matrix(c(AA + CC + EE, .5*AA + CC, .5*AA + CC, AA + CC + EE),2)
  
  mzData <- mvrnorm(Nmz , mu = c(0,0), mzMat, empirical = T)
  dzData <- mvrnorm(Ndz , mu = c(0,0), dzMat, empirical = T)
  
  selVars <- paste("t", 1:2, sep = "")
  colnames(mzData) <- colnames(dzData) <- selVars
  
  MZdata  <-  mxData(mzData, type="raw" )
  DZdata  <-  mxData(dzData, type="raw" )
  
  
  A <-  mxMatrix( type="Symm", nrow=nv, ncol=nv, free=TRUE, values=.6, label="A11", name="A" )
  C <-  mxMatrix( type="Symm", nrow=nv, ncol=nv, free=TRUE, values=.6, label="C11", name="C" )
  E <-  mxMatrix( type="Symm", nrow=nv, ncol=nv, free=TRUE, values=.6, label="E11", name="E" )
  
  Mean    <-  mxMatrix( type="Full", nrow=1, ncol=nv, free=TRUE, values= 0, label="mean", name="Mean" )
  expMean <-  mxAlgebra( expression= cbind(Mean,Mean), name="expMean")
  
  expCovMZ <- mxAlgebra( expression= rbind  ( cbind(A+C+E , A+C),cbind(A+C   , A+C+E)), name="expCovMZ" )
  expCovDZ <- mxAlgebra( expression= rbind  ( cbind(A+C+E     , 0.5%x%A+C),cbind(0.5%x%A+C , A+C+E)),  name="expCovDZ" ) 
  
  obs <-  list(A,C,E,Mean,expMean,expCovMZ,expCovDZ)
  
  fun <- mxFitFunctionML()
  mzExp <- mxExpectationNormal(covariance="expCovMZ", means="expMean", dimnames=selVars )
  dzExp <- mxExpectationNormal(covariance="expCovDZ", means="expMean", dimnames=selVars )
  
  MZ <- mxModel("MZ", obs, MZdata, fun, mzExp)
  DZ <- mxModel("DZ", obs, DZdata, fun, dzExp)
  
  aceFun <- mxFitFunctionMultigroup(c("MZ","DZ"))
  ace <- mxModel("ACE", MZ, DZ, fun, aceFun)
  
  aceFit <- suppressWarnings(mxRun(ace, silent = T))
  summary(aceFit)
  
  ceFit <- omxSetParameters(aceFit, labels = "A11", free = F, values = 0)
  ceFit <- suppressWarnings(mxRun(ceFit, silent = T))
  
  aeFit <- omxSetParameters(aceFit, labels = "C11", free = F, values = 0)
  aeFit <- suppressWarnings(mxRun(aeFit, silent = T))
  
  ncpA <- (ceFit$output$Minus2LogLikelihood - aceFit$output$Minus2LogLikelihood)/(dim(mzData)[1] + dim(dzData)[1])
  ncpC <- (aeFit$output$Minus2LogLikelihood - aceFit$output$Minus2LogLikelihood)/(dim(mzData)[1] + dim(dzData)[1])
  
  
  Ests <-    as.data.frame(cbind(rbind(add, com), rbind(aceFit$output$estimate[1], aceFit$output$estimate[2])))
  colnames(Ests) <- c("Simulated", "Estimated")
  Ests$Difference <- Ests$Simulated - Ests$Estimated
  Ests <- round(Ests, 3)
  Imprecision <- sum(Ests$Difference)
  
  
  if( Imprecision > .02 ) warning("The estimated values may differ from the simulated values more than you are comfortable with. 
Make sure you double check these values. You may want to increase the sample size ", call. = F)
  return ( list(Parameters = Ests, WncpA = ncpA, WncpC =ncpC))
  
}



