SATmodelCompare <- function(mzData, dzData, vars){
  
  # vars <- "thisroi"
  nv <- 1 # number of variables
  ntv <- nv*2 # number of total variables
  selVars <- paste(vars, c(rep(1,nv),rep(2,nv)), sep="")
  
  # Generate Descriptive Statistics
  Memz <- colMeans(mzData,na.rm=TRUE)
  Medz <- colMeans(dzData,na.rm=TRUE)
  Vmz <- cov(mzData,use="complete")
  Vdz <- cov(dzData,use="complete")
  
  # Set Starting Values
  svMe <- mean(c(Memz, Medz)) # start value for means
  svVa <- mean(c(Vmz,Vdz)) #.8 # start value for variance
  svPa <- .3 # start value for path coefficient
  svPe <- .5 # start value for path coefficient for e
  lbVa <- .0001 # lower bound for variance
  lbPa <- .0001 # lower bound for path coefficient
  
  # ----------------------------------------------------------------------------------------------------------------------
  # PREPARE MODEL
  
  # Create Algebra for expected Mean Matrices
  meanMZ <- mxMatrix( type="Full", nrow=1, ncol=ntv, free=TRUE, values=svMe, labels=c("mMZ1","mMZ2"), name="meanMZ" )
  meanDZ <- mxMatrix( type="Full", nrow=1, ncol=ntv, free=TRUE, values=svMe, labels=c("mDZ1","mDZ2"), name="meanDZ" )
  
  # Create Algebra for expected Variance/Covariance Matrices
  covMZ <- mxMatrix( type="Symm", nrow=ntv, ncol=ntv, free=TRUE, values=valDiag(svVa,ntv), lbound=valDiag(lbVa,ntv),
                     labels=c("vMZ1","cMZ21","vMZ2"), name="covMZ" )
  covDZ <- mxMatrix( type="Symm", nrow=ntv, ncol=ntv, free=TRUE, values=valDiag(svVa,ntv), lbound=valDiag(lbVa,ntv),
                     labels=c("vDZ1","cDZ21","vDZ2"), name="covDZ" )
  
  # Create Data Objects for Multiple Groups
  dataMZ <- mxData( observed=mzData, type="raw" )
  dataDZ <- mxData( observed=dzData, type="raw" )
  
  # Create Expectation Objects for Multiple Groups
  expMZ <- mxExpectationNormal( covariance="covMZ", means="meanMZ", dimnames=selVars )
  expDZ <- mxExpectationNormal( covariance="covDZ", means="meanDZ", dimnames=selVars )
  funML <- mxFitFunctionML()
  
  # Create Model Objects for Multiple Groups
  modelMZ <- mxModel( meanMZ, covMZ, dataMZ, expMZ, funML, name="MZ" )
  modelDZ <- mxModel( meanDZ, covDZ, dataDZ, expDZ, funML, name="DZ" )
  multi <- mxFitFunctionMultigroup( c("MZ","DZ") )
  
  # Create Confidence Interval Objects
  ciCov <- mxCI( c('MZ.covMZ','DZ.covDZ') )
  ciMean <- mxCI( c('MZ.meanMZ','DZ.meanDZ') )
  
  # Build Saturated Model with Confidence Intervals
  modelSAT <- mxModel( "oneSATc", modelMZ, modelDZ, multi, ciCov, ciMean )
  
  # ----------------------------------------------------------------------------------------------------------------------
  # RUN MODEL
  
  # Run Saturated Model
  fitSAT <- mxTryHard( modelSAT, intervals=F )
  sumSAT <- summary( fitSAT )
  
  # Print Goodness-of-fit Statistics & Parameter Estimates
  # fitGofs(fitSAT)
  # fitEsts(fitSAT)
  # mxGetExpected( fitSAT, c("means","covariance") )
  
  # ----------------------------------------------------------------------------------------------------------------------
  # RUN SUBMODELS
  
  # Constrain expected Means to be equal across Twin Order
  # modelEMO <- mxModel( fitSAT, name="oneEMOc" )
  # modelEMO <- omxSetParameters( modelEMO, label=c("mMZ1","mMZ2"), free=TRUE, values=svMe, newlabels='mMZ' )
  # modelEMO <- omxSetParameters( modelEMO, label=c("mDZ1","mDZ2"), free=TRUE, values=svMe, newlabels='mDZ' )
  # fitEMO <- mxTryHard( modelEMO, intervals=F )
  # # fitGofs(fitEMO); fitEsts(fitEMO)
  # 
  # # Constrain expected Means and Variances to be equal across Twin Order
  # modelEMVO <- mxModel( fitEMO, name="oneEMVOc" )
  # modelEMVO <- omxSetParameters( modelEMVO, label=c("vMZ1","vMZ2"), free=TRUE, values=svVa, newlabels='vMZ' )
  # modelEMVO <- omxSetParameters( modelEMVO, label=c("vDZ1","vDZ2"), free=TRUE, values=svVa, newlabels='vDZ' )
  # fitEMVO <- mxTryHard( modelEMVO, intervals=F )
  # # fitGofs(fitEMVO); fitEsts(fitEMVO)
  # 
  # # Constrain expected Means and Variances to be equal across Twin Order and Zygosity
  # modelEMVZ <- mxModel( fitEMVO, name="oneEMVZc" )
  # modelEMVZ <- omxSetParameters( modelEMVZ, label=c("mMZ","mDZ"), free=TRUE, values=svMe, newlabels='mZ' )
  # modelEMVZ <- omxSetParameters( modelEMVZ, label=c("vMZ","vDZ"), free=TRUE, values=svVa, newlabels='vZ' )
  # fitEMVZ <- mxTryHard( modelEMVZ, intervals=F )
  # # fitGofs(fitEMVZ); fitEsts(fitEMVZ)
  # 
  # compSAT <- mxCompare( fitSAT, nested <- list(fitEMO, fitEMVO, fitEMVZ) )
  return(sumSAT$AIC.Mx)
  
   
}


ACEmodelCompare <- function(mzData, dzData, vars){
  
  # vars <- "thisroi"
  nv <- 1 # number of variables
  ntv <- nv*2 # number of total variables
  selVars <- paste(vars, c(rep(1,nv),rep(2,nv)),sep="")
  
  # Generate Descriptive Statistics
  Memz <- colMeans(mzData,na.rm=TRUE)
  Medz <- colMeans(dzData,na.rm=TRUE)
  Vmz <- cov(mzData,use="complete")
  Vdz <- cov(dzData,use="complete")
  
  # Set Starting Values
  svMe <- mean(c(Memz, Medz)) # start value for means
  svVa <- mean(c(Vmz,Vdz)) #.8 # start value for variance
  svPa <- .3 # start value for path coefficient
  svPe <- .5 # start value for path coefficient for e
  lbVa <- .0001 # lower bound for variance
  lbPa <- .0001 # lower bound for path coefficient
  
  
  # ----------------------------------------------------------------------------------------------------------------------
  # Program: oneACEc.R
  #
  # Twin Univariate ACE model to estimate causes of variation across multiple groups
  # Matrix style model - Raw data - Continuous data
  # -------|---------|---------|---------|---------|---------|---------|---------|---------|---------|---------|---------|
  
  
  # ----------------------------------------------------------------------------------------------------------------------
  # PREPARE MODEL
  
  # Create Algebra for expected Mean Matrices
  meanG <- mxMatrix( type="Full", nrow=1, ncol=ntv, free=TRUE, values=svMe, labels=labVars("mean",vars), name="meanG" )
  
  # Create Matrices for Path Coefficients
  pathA <- mxMatrix( type="Lower", nrow=nv, ncol=nv, free=TRUE, values=svPa, labels="a11", lbound=lbPa, name="a" )
  pathC <- mxMatrix( type="Lower", nrow=nv, ncol=nv, free=TRUE, values=svPa, labels="c11", lbound=lbPa, name="c" )
  pathE <- mxMatrix( type="Lower", nrow=nv, ncol=nv, free=TRUE, values=svPe, labels="e11", lbound=lbPa, name="e" )
  
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
  pars <- list( meanG, pathA, pathC, pathE, covA, covC, covE, covP )
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
  fitACE <- mxTryHard( modelACE, intervals=T )
  sumACE <- summary( fitACE )
  
  # ----------------------------------------------------------------------------------------------------------------------
  # RUN SUBMODELS
  
  # Run AE model
  modelAE <- mxModel( fitACE, name="oneAEc" )
  modelAE <- omxSetParameters( modelAE, labels="c11", free=FALSE, values=0 )
  fitAE <- mxTryHard( modelAE, intervals=T )
  # fitGofs(fitAE); fitEstCis(fitAE)
  
  # Run CE model
  modelCE <- mxModel( fitACE, name="oneCEc" )
  modelCE <- omxSetParameters( modelCE, labels="a11", free=FALSE, values=0 )
  fitCE <- mxTryHard( modelCE, intervals=T )
  # fitGofs(fitCE); fitEstCis(fitCE)
  
  # Run E model
  modelE <- mxModel( fitAE, name="oneEc" )
  modelE <- omxSetParameters( modelE, labels="a11", free=FALSE, values=0 )
  fitE <- mxTryHard( modelE, intervals=T )
  # fitGofs(fitE); fitEstCis(fitE)

  compACE <- mxCompare( fitACE, nested <- list(fitAE, fitCE, fitE) )
  acecoef <- round(rbind(fitACE$US$result,fitAE$US$result,fitCE$US$result,fitE$US$result),4)
  aceci <- round(rbind(fitAE$output$confidenceIntervals,fitCE$output$confidenceIntervals),4)
  
  return(list(compACE, acecoef, aceci))
  
}


ADEmodelCompare <- function(mzData, dzData, vars){
  
  # vars <- "thisroi"
  nv <- 1 # number of variables
  ntv <- nv*2 # number of total variables
  selVars <- paste(vars, c(rep(1,nv),rep(2,nv)),sep="")
  
  # Generate Descriptive Statistics
  Memz <- colMeans(mzData,na.rm=TRUE)
  Medz <- colMeans(dzData,na.rm=TRUE)
  Vmz <- cov(mzData,use="complete")
  Vdz <- cov(dzData,use="complete")
  
  # Set Starting Values
  svMe <- mean(c(Memz, Medz)) # start value for means
  svVa <- mean(c(Vmz,Vdz)) #.8 # start value for variance
  svPa <- .3 # start value for path coefficient
  svPe <- .5 # start value for path coefficient for e
  lbVa <- .0001 # lower bound for variance
  lbPa <- .0001 # lower bound for path coefficient
  
  # ----------------------------------------------------------------------------------------------------------------------
  # Program: oneADEc.R
  # Author: Hermine Maes
  # Date: 10 22 2018
  #
  # Twin Univariate ADE model to estimate causes of variation across multiple groups
  # Matrix style model - Raw data - Continuous data
  # -------|---------|---------|---------|---------|---------|---------|---------|---------|---------|---------|---------|
  
  
  # ----------------------------------------------------------------------------------------------------------------------
  # PREPARE MODEL
  
  # Create Algebra for expected Mean Matrices
  meanG <- mxMatrix( type="Full", nrow=1, ncol=ntv, free=TRUE, values=svMe, labels=labVars("mean",vars), name="meanG" )

  # Create Matrices for Path Coefficients
  pathA <- mxMatrix( type="Lower", nrow=nv, ncol=nv, free=TRUE, values=svPa, labels="a11", lbound=lbPa, name="a" )
  pathD <- mxMatrix( type="Lower", nrow=nv, ncol=nv, free=TRUE, values=svPa, labels="d11", lbound=lbPa, name="d" )
  pathE <- mxMatrix( type="Lower", nrow=nv, ncol=nv, free=TRUE, values=svPe, labels="e11", lbound=lbPa, name="e" )

  # Create Algebra for Variance Components
  covA <- mxAlgebra( expression=a %*% t(a), name="A" )
  covD <- mxAlgebra( expression=d %*% t(d), name="D" )
  covE <- mxAlgebra( expression=e %*% t(e), name="E" )

  # Create Algebra for expected Variance/Covariance Matrices in MZ & DZ twins
  covP <- mxAlgebra( expression= A+D+E, name="V" )
  covMZ <- mxAlgebra( expression= A+D, name="cMZ" )
  covDZ <- mxAlgebra( expression= 0.5%x%A+ 0.25%x%D, name="cDZ" )
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
  pars <- list( meanG, pathA, pathD, pathE, covA, covD, covE, covP )
  modelMZ <- mxModel( pars, covMZ, expCovMZ, dataMZ, expMZ, funML, name="MZ" )
  modelDZ <- mxModel( pars, covDZ, expCovDZ, dataDZ, expDZ, funML, name="DZ" )
  multi <- mxFitFunctionMultigroup( c("MZ","DZ") )

  # Create Algebra for Unstandardized and Standardized Variance Components
  rowUS <- rep('US',nv)
  colUS <- rep(c('A','D','E','SA','SD','SE'),each=nv)
  estUS <- mxAlgebra( expression=cbind(A,D,E,A/V,D/V,E/V), name="US", dimnames=list(rowUS,colUS) )

  # Create Confidence Interval Objects
  ciADE <- mxCI( "US[1,1:3]" )

  # Build Model with Confidence Intervals
  modelADE <- mxModel( "oneADEc", pars, modelMZ, modelDZ, multi, estUS, ciADE )

  # ----------------------------------------------------------------------------------------------------------------------
  # RUN MODEL

  # Run ADE Model
  fitADE <- mxTryHard( modelADE, intervals=T )
  sumADE <- summary( fitADE )

  # ----------------------------------------------------------------------------------------------------------------------
  # RUN SUBMODELS

  # Run AE model
  modelAE <- mxModel( fitADE, name="oneAEc" )
  modelAE <- omxSetParameters( modelAE, labels="d11", free=FALSE, values=0 )
  fitAE <- mxTryHard( modelAE, intervals=T )
  # fitGofs(fitAE); fitEstCis(fitAE)

  # Run DE model
  modelDE <- mxModel( fitADE, name="oneDEc" )
  modelDE <- omxSetParameters( modelDE, labels="a11", free=FALSE, values=0 )
  fitDE <- mxTryHard( modelDE, intervals=T )
  # fitGofs(fitDE); fitEstCis(fitDE)

  # Run E model
  modelE <- mxModel( fitAE, name="oneEc" )
  modelE <- omxSetParameters( modelE, labels="a11", free=FALSE, values=0 )
  fitE <- mxTryHard( modelE, intervals=T )
  # fitGofs(fitE); fitEstCis(fitE)
  
  compADE <- mxCompare( fitADE, nested <- list(fitAE, fitDE, fitE) )
  adecoef <- round(rbind(fitADE$US$result,fitAE$US$result,fitDE$US$result,fitE$US$result ),4)
  adeci <- round(rbind(fitAE$output$confidenceIntervals,
                       fitDE$output$confidenceIntervals),4)
  
  return(list(compADE, adecoef, adeci))
}


mdlSelect <- function(){
  # models Compare
  # compSAT <- mxCompare( fitSAT, nested <- list(fitEMO, fitEMVO, fitEMVZ) )
  # compSATACDE <- mxCompare( fitSAT,  nested<-list(fitACE,fitADE) )
  # compACE <- mxCompare( fitACE, nested <- list(fitAE, fitCE, fitE) )
  # compADE <- mxCompare( fitADE, nested <- list(fitAE, fitDE, fitE) )
  
  # # coef and ci
  # 
  # 
  # acecoef <- round(rbind(fitACE$US$result,fitAE$US$result,fitCE$US$result,fitE$US$result),4)
  # aceci <- round(rbind(fitAE$output$confidenceIntervals,fitCE$output$confidenceIntervals),4)
  # 
  # adecoef <- round(rbind(fitADE$US$result,fitAE$US$result,fitDE$US$result,fitE$US$result ),4)
  # adeci <- round(rbind(fitAE$output$confidenceIntervals,
  #                      fitDE$output$confidenceIntervals),4)
  
  # output
  # if(min(compSATACDE[,'AIC'])==compSATACDE[1,'AIC']){
  #   # exceptioncount = exceptioncount + 1
  #   thisbest = 'SAT'
  # }
  # 
  # if (compSATACDE[2,'AIC']<compSATACDE[3,'AIC']){ # ACE win 
  #   models = c('ACE', 'AE', 'CE', 'E')
  #   thisbest = models[compACE[,'AIC']==min(compACE[,'AIC'])]
  #   thiscoef = acecoef[compACE[,'AIC']==min(compACE[,'AIC']),]
  # } 
  # else{ # ADE win 
  #   models = c('ADE', 'AE', 'DE', 'E')
  #   thisbest = models[compADE[,'AIC']==min(compADE[,'AIC'])]
  #   thiscoef = adecoef[compADE[,'AIC']==min(compADE[,'AIC']),]
  #   
  # }
  
  
}



test.twins <- function(mzData, dzData){
  
  vars <- "thisroi"
  nv <- 1 # number of variables
  ntv <- nv*2 # number of total variables
  selVars <- paste("thisroi",c(rep(1,nv),rep(2,nv)),sep="")
  
  # Generate Descriptive Statistics
  Memz <- colMeans(mzData,na.rm=TRUE)
  Medz <- colMeans(dzData,na.rm=TRUE)
  Vmz <- cov(mzData,use="complete")
  Vdz <- cov(dzData,use="complete")
  
  # Set Starting Values
  svMe <- mean(c(Memz, Medz)) # start value for means
  svVa <- mean(c(Vmz,Vdz)) #.8 # start value for variance
  svPa <- .3 # start value for path coefficient
  svPe <- .5 # start value for path coefficient for e
  lbVa <- .0001 # lower bound for variance
  lbPa <- .0001 # lower bound for path coefficient
  
  # ----------------------------------------------------------------------------------------------------------------------
  # PREPARE MODEL
  
  # Create Algebra for expected Mean Matrices
  meanMZ <- mxMatrix( type="Full", nrow=1, ncol=ntv, free=TRUE, values=svMe, labels=c("mMZ1","mMZ2"), name="meanMZ" )
  meanDZ <- mxMatrix( type="Full", nrow=1, ncol=ntv, free=TRUE, values=svMe, labels=c("mDZ1","mDZ2"), name="meanDZ" )
  
  # Create Algebra for expected Variance/Covariance Matrices
  covMZ <- mxMatrix( type="Symm", nrow=ntv, ncol=ntv, free=TRUE, values=valDiag(svVa,ntv), lbound=valDiag(lbVa,ntv),
                     labels=c("vMZ1","cMZ21","vMZ2"), name="covMZ" )
  covDZ <- mxMatrix( type="Symm", nrow=ntv, ncol=ntv, free=TRUE, values=valDiag(svVa,ntv), lbound=valDiag(lbVa,ntv),
                     labels=c("vDZ1","cDZ21","vDZ2"), name="covDZ" )
  
  # Create Data Objects for Multiple Groups
  dataMZ <- mxData( observed=mzData, type="raw" )
  dataDZ <- mxData( observed=dzData, type="raw" )
  
  # Create Expectation Objects for Multiple Groups
  expMZ <- mxExpectationNormal( covariance="covMZ", means="meanMZ", dimnames=selVars )
  expDZ <- mxExpectationNormal( covariance="covDZ", means="meanDZ", dimnames=selVars )
  funML <- mxFitFunctionML()
  
  # Create Model Objects for Multiple Groups
  modelMZ <- mxModel( meanMZ, covMZ, dataMZ, expMZ, funML, name="MZ" )
  modelDZ <- mxModel( meanDZ, covDZ, dataDZ, expDZ, funML, name="DZ" )
  multi <- mxFitFunctionMultigroup( c("MZ","DZ") )
  
  # Create Confidence Interval Objects
  ciCov <- mxCI( c('MZ.covMZ','DZ.covDZ') )
  ciMean <- mxCI( c('MZ.meanMZ','DZ.meanDZ') )
  
  # Build Saturated Model with Confidence Intervals
  modelSAT <- mxModel( "oneSATc", modelMZ, modelDZ, multi, ciCov, ciMean )
  
  # ----------------------------------------------------------------------------------------------------------------------
  # RUN MODEL
  
  # Run Saturated Model
  fitSAT <- mxTryHard( modelSAT, intervals=F )
  sumSAT <- summary( fitSAT )
  
  return(fitSAT$output$fit)
}


HCPROIFCmodelCompare <- function(mzData, dzData){
  
  vars <- "thisroi"
  nv <- 1 # number of variables
  ntv <- nv*2 # number of total variables
  selVars <- paste("thisroi",c(rep(1,nv),rep(2,nv)),sep="")
  
  # Generate Descriptive Statistics
  Memz <- colMeans(mzData,na.rm=TRUE)
  Medz <- colMeans(dzData,na.rm=TRUE)
  Vmz <- cov(mzData,use="complete")
  Vdz <- cov(dzData,use="complete")
  
  # Set Starting Values
  svMe <- mean(c(Memz, Medz)) # start value for means
  svVa <- mean(c(Vmz,Vdz)) #.8 # start value for variance
  svPa <- .3 # start value for path coefficient
  svPe <- .5 # start value for path coefficient for e
  lbVa <- .0001 # lower bound for variance
  lbPa <- .0001 # lower bound for path coefficient
  
  # ----------------------------------------------------------------------------------------------------------------------
  # PREPARE MODEL
  
  # Create Algebra for expected Mean Matrices
  meanMZ <- mxMatrix( type="Full", nrow=1, ncol=ntv, free=TRUE, values=svMe, labels=c("mMZ1","mMZ2"), name="meanMZ" )
  meanDZ <- mxMatrix( type="Full", nrow=1, ncol=ntv, free=TRUE, values=svMe, labels=c("mDZ1","mDZ2"), name="meanDZ" )
  
  # Create Algebra for expected Variance/Covariance Matrices
  covMZ <- mxMatrix( type="Symm", nrow=ntv, ncol=ntv, free=TRUE, values=valDiag(svVa,ntv), lbound=valDiag(lbVa,ntv),
                     labels=c("vMZ1","cMZ21","vMZ2"), name="covMZ" )
  covDZ <- mxMatrix( type="Symm", nrow=ntv, ncol=ntv, free=TRUE, values=valDiag(svVa,ntv), lbound=valDiag(lbVa,ntv),
                     labels=c("vDZ1","cDZ21","vDZ2"), name="covDZ" )
  
  # Create Data Objects for Multiple Groups
  dataMZ <- mxData( observed=mzData, type="raw" )
  dataDZ <- mxData( observed=dzData, type="raw" )
  
  # Create Expectation Objects for Multiple Groups
  expMZ <- mxExpectationNormal( covariance="covMZ", means="meanMZ", dimnames=selVars )
  expDZ <- mxExpectationNormal( covariance="covDZ", means="meanDZ", dimnames=selVars )
  funML <- mxFitFunctionML()
  
  # Create Model Objects for Multiple Groups
  modelMZ <- mxModel( meanMZ, covMZ, dataMZ, expMZ, funML, name="MZ" )
  modelDZ <- mxModel( meanDZ, covDZ, dataDZ, expDZ, funML, name="DZ" )
  multi <- mxFitFunctionMultigroup( c("MZ","DZ") )
  
  # Create Confidence Interval Objects
  ciCov <- mxCI( c('MZ.covMZ','DZ.covDZ') )
  ciMean <- mxCI( c('MZ.meanMZ','DZ.meanDZ') )
  
  # Build Saturated Model with Confidence Intervals
  modelSAT <- mxModel( "oneSATc", modelMZ, modelDZ, multi, ciCov, ciMean )
  
  # ----------------------------------------------------------------------------------------------------------------------
  # RUN MODEL
  
  # Run Saturated Model
  fitSAT <- mxTryHard( modelSAT, intervals=F )
  sumSAT <- summary( fitSAT )
  
  # Print Goodness-of-fit Statistics & Parameter Estimates
  # fitGofs(fitSAT)
  # fitEsts(fitSAT)
  # mxGetExpected( fitSAT, c("means","covariance") )
  
  # ----------------------------------------------------------------------------------------------------------------------
  # RUN SUBMODELS
  
  # Constrain expected Means to be equal across Twin Order
  modelEMO <- mxModel( fitSAT, name="oneEMOc" )
  modelEMO <- omxSetParameters( modelEMO, label=c("mMZ1","mMZ2"), free=TRUE, values=svMe, newlabels='mMZ' )
  modelEMO <- omxSetParameters( modelEMO, label=c("mDZ1","mDZ2"), free=TRUE, values=svMe, newlabels='mDZ' )
  fitEMO <- mxTryHard( modelEMO, intervals=F )
  # fitGofs(fitEMO); fitEsts(fitEMO)
  
  # Constrain expected Means and Variances to be equal across Twin Order
  modelEMVO <- mxModel( fitEMO, name="oneEMVOc" )
  modelEMVO <- omxSetParameters( modelEMVO, label=c("vMZ1","vMZ2"), free=TRUE, values=svVa, newlabels='vMZ' )
  modelEMVO <- omxSetParameters( modelEMVO, label=c("vDZ1","vDZ2"), free=TRUE, values=svVa, newlabels='vDZ' )
  fitEMVO <- mxTryHard( modelEMVO, intervals=F )
  # fitGofs(fitEMVO); fitEsts(fitEMVO)
  
  # Constrain expected Means and Variances to be equal across Twin Order and Zygosity
  modelEMVZ <- mxModel( fitEMVO, name="oneEMVZc" )
  modelEMVZ <- omxSetParameters( modelEMVZ, label=c("mMZ","mDZ"), free=TRUE, values=svMe, newlabels='mZ' )
  modelEMVZ <- omxSetParameters( modelEMVZ, label=c("vMZ","vDZ"), free=TRUE, values=svVa, newlabels='vZ' )
  fitEMVZ <- mxTryHard( modelEMVZ, intervals=F )
  # fitGofs(fitEMVZ); fitEsts(fitEMVZ)
  
  # ----------------------------------------------------------------------------------------------------------------------
  # Program: oneACEc.R
  #
  # Twin Univariate ACE model to estimate causes of variation across multiple groups
  # Matrix style model - Raw data - Continuous data
  # -------|---------|---------|---------|---------|---------|---------|---------|---------|---------|---------|---------|
  
  
  # ----------------------------------------------------------------------------------------------------------------------
  # PREPARE MODEL
  
  # Create Algebra for expected Mean Matrices
  meanG <- mxMatrix( type="Full", nrow=1, ncol=ntv, free=TRUE, values=svMe, labels=labVars("mean",vars), name="meanG" )
  
  # Create Matrices for Path Coefficients
  pathA <- mxMatrix( type="Lower", nrow=nv, ncol=nv, free=TRUE, values=svPa, labels="a11", lbound=lbPa, name="a" )
  pathC <- mxMatrix( type="Lower", nrow=nv, ncol=nv, free=TRUE, values=svPa, labels="c11", lbound=lbPa, name="c" )
  pathE <- mxMatrix( type="Lower", nrow=nv, ncol=nv, free=TRUE, values=svPe, labels="e11", lbound=lbPa, name="e" )
  
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
  pars <- list( meanG, pathA, pathC, pathE, covA, covC, covE, covP )
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
  fitACE <- mxTryHard( modelACE, intervals=T )
  sumACE <- summary( fitACE )
  
  # ----------------------------------------------------------------------------------------------------------------------
  # RUN SUBMODELS
  
  # Run AE model
  modelAE <- mxModel( fitACE, name="oneAEc" )
  modelAE <- omxSetParameters( modelAE, labels="c11", free=FALSE, values=0 )
  fitAE <- mxTryHard( modelAE, intervals=T )
  # fitGofs(fitAE); fitEstCis(fitAE)
  
  # Run CE model
  modelCE <- mxModel( fitACE, name="oneCEc" )
  modelCE <- omxSetParameters( modelCE, labels="a11", free=FALSE, values=0 )
  fitCE <- mxTryHard( modelCE, intervals=T )
  # fitGofs(fitCE); fitEstCis(fitCE)
  
  # Run E model
  modelE <- mxModel( fitAE, name="oneEc" )
  modelE <- omxSetParameters( modelE, labels="a11", free=FALSE, values=0 )
  fitE <- mxTryHard( modelE, intervals=T )
  # fitGofs(fitE); fitEstCis(fitE)
  
  # ----------------------------------------------------------------------------------------------------------------------
  # Program: oneADEc.R
  # Author: Hermine Maes
  # Date: 10 22 2018
  #
  # Twin Univariate ADE model to estimate causes of variation across multiple groups
  # Matrix style model - Raw data - Continuous data
  # -------|---------|---------|---------|---------|---------|---------|---------|---------|---------|---------|---------|
  
  
  # ----------------------------------------------------------------------------------------------------------------------
  # PREPARE MODEL
  
  # Create Algebra for expected Mean Matrices
  meanG <- mxMatrix( type="Full", nrow=1, ncol=ntv, free=TRUE, values=svMe, labels=labVars("mean",vars), name="meanG" )
  
  # Create Matrices for Path Coefficients
  pathA <- mxMatrix( type="Lower", nrow=nv, ncol=nv, free=TRUE, values=svPa, labels="a11", lbound=lbPa, name="a" )
  pathD <- mxMatrix( type="Lower", nrow=nv, ncol=nv, free=TRUE, values=svPa, labels="d11", lbound=lbPa, name="d" )
  pathE <- mxMatrix( type="Lower", nrow=nv, ncol=nv, free=TRUE, values=svPe, labels="e11", lbound=lbPa, name="e" )
  
  # Create Algebra for Variance Components
  covA <- mxAlgebra( expression=a %*% t(a), name="A" )
  covD <- mxAlgebra( expression=d %*% t(d), name="D" )
  covE <- mxAlgebra( expression=e %*% t(e), name="E" )
  
  # Create Algebra for expected Variance/Covariance Matrices in MZ & DZ twins
  covP <- mxAlgebra( expression= A+D+E, name="V" )
  covMZ <- mxAlgebra( expression= A+D, name="cMZ" )
  covDZ <- mxAlgebra( expression= 0.5%x%A+ 0.25%x%D, name="cDZ" )
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
  pars <- list( meanG, pathA, pathD, pathE, covA, covD, covE, covP )
  modelMZ <- mxModel( pars, covMZ, expCovMZ, dataMZ, expMZ, funML, name="MZ" )
  modelDZ <- mxModel( pars, covDZ, expCovDZ, dataDZ, expDZ, funML, name="DZ" )
  multi <- mxFitFunctionMultigroup( c("MZ","DZ") )
  
  # Create Algebra for Unstandardized and Standardized Variance Components
  rowUS <- rep('US',nv)
  colUS <- rep(c('A','D','E','SA','SD','SE'),each=nv)
  estUS <- mxAlgebra( expression=cbind(A,D,E,A/V,D/V,E/V), name="US", dimnames=list(rowUS,colUS) )
  
  # Create Confidence Interval Objects
  ciADE <- mxCI( "US[1,1:3]" )
  
  # Build Model with Confidence Intervals
  modelADE <- mxModel( "oneADEc", pars, modelMZ, modelDZ, multi, estUS, ciADE )
  
  # ----------------------------------------------------------------------------------------------------------------------
  # RUN MODEL
  
  # Run ADE Model
  fitADE <- mxTryHard( modelADE, intervals=T )
  sumADE <- summary( fitADE )
  
  # ----------------------------------------------------------------------------------------------------------------------
  # RUN SUBMODELS
  
  # Run AE model
  modelAE <- mxModel( fitADE, name="oneAEc" )
  modelAE <- omxSetParameters( modelAE, labels="d11", free=FALSE, values=0 )
  fitAE <- mxTryHard( modelAE, intervals=T )
  # fitGofs(fitAE); fitEstCis(fitAE)
  
  # Run DE model
  modelDE <- mxModel( fitADE, name="oneDEc" )
  modelDE <- omxSetParameters( modelDE, labels="a11", free=FALSE, values=0 )
  fitDE <- mxTryHard( modelDE, intervals=T )
  # fitGofs(fitDE); fitEstCis(fitDE)
  
  # Run E model
  modelE <- mxModel( fitAE, name="oneEc" )
  modelE <- omxSetParameters( modelE, labels="a11", free=FALSE, values=0 )
  fitE <- mxTryHard( modelE, intervals=T )
  # fitGofs(fitE); fitEstCis(fitE)
  
  #######################################################
  # models Compare
  compSAT <- mxCompare( fitSAT, nested <- list(fitEMO, fitEMVO, fitEMVZ) )
  compSATACDE <- mxCompare( fitSAT,  nested<-list(fitACE,fitADE) )
  compACE <- mxCompare( fitACE, nested <- list(fitAE, fitCE, fitE) )
  compADE <- mxCompare( fitADE, nested <- list(fitAE, fitDE, fitE) )

  # coef and ci

  acecoef <- round(rbind(fitACE$US$result,fitAE$US$result,fitCE$US$result,fitE$US$result),4)
  aceci <- round(rbind(fitAE$output$confidenceIntervals,fitCE$output$confidenceIntervals),4)

  adecoef <- round(rbind(fitADE$US$result,fitAE$US$result,fitDE$US$result,fitE$US$result ),4)
  adeci <- round(rbind(fitAE$output$confidenceIntervals,
                       fitDE$output$confidenceIntervals),4)

  # output
  if(min(compSATACDE[,'AIC'])==compSATACDE[1,'AIC']){
    # exceptioncount = exceptioncount + 1
    thisbest = 'SAT'
    thiscoef <- runif(6)*NaN
  }

  if (compSATACDE[2,'AIC']<compSATACDE[3,'AIC']){ # ACE win
    models = c('ACE', 'AE', 'CE', 'E')
    thisbest = models[compACE[,'AIC']==min(compACE[,'AIC'])]
    thiscoef = acecoef[compACE[,'AIC']==min(compACE[,'AIC']),]
  }
  else{ # ADE win
    models = c('ADE', 'AE', 'DE', 'E')
    thisbest = models[compADE[,'AIC']==min(compADE[,'AIC'])]
    thiscoef = adecoef[compADE[,'AIC']==min(compADE[,'AIC']),]

  }
  
  return(list(thisbest, thiscoef))
  
}