# ----------------------------------------------------------------------------------------------------------------------
# Program: oneSATc.R  
#  Author: William Jiang
#    Date: 24 03 2019
#
# Twin Univariate Saturated model to estimate means and (co)variances across multiple groups
# Matrix style model - Raw data - Continuous data
# -------|---------|---------|---------|---------|---------|---------|---------|---------|---------|---------|---------|

# Load Libraries & Options
rm(list=ls())
setwd("D:/Documents/ScriptR/")
library(OpenMx)
library(psych); library(polycor)
source("miFunctions.R")
require(xlsx)

# Create Output 
# filename    <- "oneSATc"
# sink(paste(filename,".Ro",sep=""), append=FALSE, split=TRUE)

# ----------------------------------------------------------------------------------------------------------------------
# PREPARE DATA

# Load Data
# data(twinData)
# dim(twinData)
# describe(twinData[,1:12], skew=F)

# twinData <-read.table("RDMin1.csv", header=T, na.strings = "NA")
twinDataraw <-read.xlsx("RDMin1.xlsx", sheetIndex = 1, na.strings = "NA")
head(twinDataraw)
# remove bad data
twinData = subset(twinDataraw, twinDataraw$twinsNum != c("T001","T028"))
# twinData = subset(twinData, twinData$twinsNum != "T006")

# Select Variables for Analysis
vars      <- 'mcoh'                     # list of variables names
nv        <- 1                         # number of variables
ntv       <- nv*2                      # number of total variables
selVars   <- paste(vars,c(rep(1,nv),rep(2,nv)),sep="")

# Select Data for Analysis
mzData    <- subset(twinData, zyg==1, selVars)
dzData    <- subset(twinData, zyg==2, selVars)

# Generate Descriptive Statistics
mzMean <- colMeans(mzData,na.rm=TRUE)
dzMean <- colMeans(dzData,na.rm=TRUE)
mzcov <- cov(mzData,use="complete")
dzcov <- cov(dzData,use="complete")

# Set Starting Values
svMe      <-  round(mean(c(mzMean,dzMean)),1)      # start value for means
svVa      <-  round(mean(c(mzcov,dzcov)),3)       # start value for variance
lbVa      <- 1e-5                     # lower bound for variance
svPa      <- .2                        # start value for path coefficient
svPe      <- .5                        # start value for path coefficient for e

# ----------------------------------------------------------------------------------------------------------------------
# PREPARE MODEL

# Create Algebra for expected Mean Matrices
meanMZ    <- mxMatrix( type="Full", nrow=1, ncol=ntv, free=TRUE, values=svMe, labels=c("mMZ1","mMZ2"), name="meanMZ" )
meanDZ    <- mxMatrix( type="Full", nrow=1, ncol=ntv, free=TRUE, values=svMe, labels=c("mDZ1","mDZ2"), name="meanDZ" )

# Create Algebra for expected Variance/Covariance Matrices
covMZ     <- mxMatrix( type="Symm", nrow=ntv, ncol=ntv, free=TRUE, values=valDiag(svVa,ntv), lbound=valDiag(lbVa,ntv), labels=c("vMZ1","cMZ21","vMZ2"), name="covMZ" )
covDZ     <- mxMatrix( type="Symm", nrow=ntv, ncol=ntv, free=TRUE, values=valDiag(svVa,ntv), lbound=valDiag(lbVa,ntv), labels=c("vDZ1","cDZ21","vDZ2"), name="covDZ" )

# Create Data Objects for Multiple Groups
dataMZ    <- mxData( observed=mzData, type="raw" )
dataDZ    <- mxData( observed=dzData, type="raw" )

# Create Expectation Objects for Multiple Groups
expMZ     <- mxExpectationNormal( covariance="covMZ", means="meanMZ", dimnames=selVars )
expDZ     <- mxExpectationNormal( covariance="covDZ", means="meanDZ", dimnames=selVars )
funML     <- mxFitFunctionML()

# Create Model Objects for Multiple Groups
modelMZ   <- mxModel( meanMZ, covMZ, dataMZ, expMZ, funML, name="MZ" )
modelDZ   <- mxModel( meanDZ, covDZ, dataDZ, expDZ, funML, name="DZ" )
multi     <- mxFitFunctionMultigroup( c("MZ","DZ") )

# Create Confidence Interval Objects
ciCov     <- mxCI( c('MZ.covMZ','DZ.covDZ') )
ciMean    <- mxCI( c('MZ.meanMZ','DZ.meanDZ') )

# Build Saturated Model with Confidence Intervals
modelSAT  <- mxModel( "oneSATc", modelMZ, modelDZ, multi, ciCov, ciMean )

# ----------------------------------------------------------------------------------------------------------------------
# RUN MODEL

# Run Saturated Model
while (TRUE) {
  # fitEMO    <- mxRun( modelEMO, intervals=F )
  fitSAT    <- mxTryHard( modelSAT, intervals=T )
  if (fitSAT$output$status$code==0) {
    break()
  }
}
sumSAT    <- summary( fitSAT )

# Print Goodness-of-fit Statistics & Parameter Estimates
fitGofs(fitSAT)
fitEsts(fitSAT)
mxGetExpected( fitSAT, c("means","covariance") )

# ----------------------------------------------------------------------------------------------------------------------
# RUN SUBMODELS

# Constrain expected Means to be equal across Twin Order
modelEMO  <- mxModel( fitSAT, name="oneEMOc" )
modelEMO  <- omxSetParameters( modelEMO, label=c("mMZ1","mMZ2"), free=TRUE, values=svMe, newlabels='mMZ' )
modelEMO  <- omxSetParameters( modelEMO, label=c("mDZ1","mDZ2"), free=TRUE, values=svMe, newlabels='mDZ' )
while (TRUE) {
  # fitEMO    <- mxRun( modelEMO, intervals=F )
  fitEMO    <- mxTryHard( modelEMO, intervals=F )
  if (fitEMO$output$status$code==0) {
    break()
  }
}
fitGofs(fitEMO); fitEsts(fitEMO)

# Constrain expected Means and Variances to be equal across Twin Order
modelEMVO <- mxModel( fitEMO, name="oneEMVOc" )
modelEMVO <- omxSetParameters( modelEMVO, label=c("vMZ1","vMZ2"), free=TRUE, values=svVa, newlabels='vMZ' )
modelEMVO <- omxSetParameters( modelEMVO, label=c("vDZ1","vDZ2"), free=TRUE, values=svVa, newlabels='vDZ' )
while (TRUE) {
  # fitEMO    <- mxRun( modelEMO, intervals=F )
  fitEMVO    <- mxTryHard( modelEMVO, intervals=F )
  if (fitEMVO$output$status$code==0) {
    break()
  }
}
fitGofs(fitEMVO); fitEsts(fitEMVO)

# Constrain expected Means and Variances to be equal across Twin Order and Zygosity
modelEMVZ <- mxModel( fitEMVO, name="oneEMVZc" )
modelEMVZ <- omxSetParameters( modelEMVZ, label=c("mMZ","mDZ"), free=TRUE, values=svMe, newlabels='mZ' )
modelEMVZ <- omxSetParameters( modelEMVZ, label=c("vMZ","vDZ"), free=TRUE, values=svVa, newlabels='vZ' )
while (TRUE) {
  # fitEMO    <- mxRun( modelEMO, intervals=F )
  fitEMVZ    <- mxTryHard( modelEMVZ, intervals=F )
  if (fitEMVZ$output$status$code==0) {
    break()
  }
}
fitGofs(fitEMVZ); fitEsts(fitEMVZ)

# Print Comparative Fit Statistics
mxCompare( fitSAT, subs <- list(fitEMO, fitEMVO, fitEMVZ) )


##############################################################
# ACE modeling
# Set Starting Values


# ----------------------------------------------------------------------------------------------------------------------
# PREPARE MODEL

# Create Algebra for expected Mean Matrices
meanG     <- mxMatrix( type="Full", nrow=1, ncol=ntv, free=TRUE, values=svMe, labels=labVars("mean",vars), name="meanG" )

# Create Matrices for Variance Components
covA      <- mxMatrix( type="Symm", nrow=nv, ncol=nv, free=TRUE, values=svPa, label="VA11", name="VA" ) 
covC      <- mxMatrix( type="Symm", nrow=nv, ncol=nv, free=TRUE, values=svPa, label="VC11", name="VC" )
covE      <- mxMatrix( type="Symm", nrow=nv, ncol=nv, free=TRUE, values=svPa, label="VE11", name="VE" )

# Create Algebra for expected Variance/Covariance Matrices in MZ & DZ twins
covP      <- mxAlgebra( expression= VA+VC+VE, name="V" )
covMZ     <- mxAlgebra( expression= VA+VC, name="cMZ" )
covDZ     <- mxAlgebra( expression= 0.5%x%VA+ VC, name="cDZ" )
expCovMZ  <- mxAlgebra( expression= rbind( cbind(V, cMZ), cbind(t(cMZ), V)), name="expCovMZ" )
expCovDZ  <- mxAlgebra( expression= rbind( cbind(V, cDZ), cbind(t(cDZ), V)), name="expCovDZ" )

# Create Data Objects for Multiple Groups
dataMZ    <- mxData( observed=mzData, type="raw" )
dataDZ    <- mxData( observed=dzData, type="raw" )

# Create Expectation Objects for Multiple Groups
expMZ     <- mxExpectationNormal( covariance="expCovMZ", means="meanG", dimnames=selVars )
expDZ     <- mxExpectationNormal( covariance="expCovDZ", means="meanG", dimnames=selVars )
funML     <- mxFitFunctionML()

# Create Model Objects for Multiple Groups
pars      <- list( meanG, covA, covC, covE, covP )
modelMZ   <- mxModel( pars, covMZ, expCovMZ, dataMZ, expMZ, funML, name="MZ" )
modelDZ   <- mxModel( pars, covDZ, expCovDZ, dataDZ, expDZ, funML, name="DZ" )
multi     <- mxFitFunctionMultigroup( c("MZ","DZ") )

# Create Algebra for Variance Components
rowVC     <- rep('VC',nv)
colVC     <- rep(c('VA','VC','VE','SA','SC','SE'),each=nv)
estVC     <- mxAlgebra( expression=cbind(VA,VC,VE,VA/V,VC/V,VE/V), name="VarC", dimnames=list(rowVC,colVC) )

# Create Confidence Interval Objects
ciACE     <- mxCI( c("VA","VC","VE") ,interval = 0.95)

# Build Model with Confidence Intervals
modelACE  <- mxModel( "oneACEvc", pars, modelMZ, modelDZ, multi, estVC, ciACE )

# ----------------------------------------------------------------------------------------------------------------------
# RUN MODEL

# Run ACE Model
# fitACE    <- mxRun( modelACE, intervals=T )
while (TRUE) {
  # fitEMO    <- mxRun( modelEMO, intervals=F )
  fitACE    <- mxTryHard( modelACE, intervals=T )
  if (fitACE$output$status$code==0) {
    break()
  }
}
sumACE    <- summary( fitACE )

# Compare with Saturated Model
#if saturated model fitted in same session
mxCompare( fitSAT, fitACE )
#if saturated model prior to genetic model
lrtSAT(fitACE, sumSAT$Minus2LogLikelihood, sumSAT$degreesOfFreedom)

# Print Goodness-of-fit Statistics & Parameter Estimates
fitGofs(fitACE)
fitEstCis(fitACE)
round(fitACE$VarC$result,4)

# ----------------------------------------------------------------------------------------------------------------------
# RUN SUBMODELS

# Run AE model
modelAE   <- mxModel( fitACE, name="oneAEvc" )
modelAE   <- omxSetParameters( modelAE, labels="VC11", free=FALSE, values=0 )
while (TRUE) {
  # fitEMO    <- mxRun( modelEMO, intervals=F )
  fitAE    <- mxTryHard( modelAE, intervals=T )
  if (fitAE$output$status$code==0) {
    break()
  }
}
fitGofs(fitAE); fitEstCis(fitAE)

# Run CE model
modelCE   <- mxModel( fitACE, name="oneCEvc" )
modelCE   <- omxSetParameters( modelCE, labels="VA11", free=FALSE, values=0 )
modelCE   <- omxSetParameters( modelCE, labels=c("VE11","VC11"), free=TRUE, values=.6 )
while (TRUE) {
  # fitEMO    <- mxRun( modelEMO, intervals=F )
  fitCE    <- mxTryHard( modelCE, intervals=T )
  if (fitCE$output$status$code==0) {
    break()
  }
}
fitGofs(fitCE); fitEstCis(fitCE)

# Run E model
modelE    <- mxModel( fitAE, name="oneEvc" )
modelE    <- omxSetParameters( modelE, labels="VA11", free=FALSE, values=0 )
while (TRUE) {
  # fitEMO    <- mxRun( modelEMO, intervals=F )
  fitE    <- mxTryHard( modelE, intervals=T )
  if (fitE$output$status$code==0) {
    break()
  }
}
fitGofs(fitE); fitEstCis(fitE)

# Print Comparative Fit Statistics
mxCompare( fitACE, nested <- list(fitAE, fitCE, fitE) )
round(rbind(fitACE$VarC$result,fitAE$VarC$result,fitCE$VarC$result,fitE$VarC$result),4)

################################################################
# ADE modeling
# PREPARE MODEL

# Create Algebra for expected Mean Matrices
meanG     <- mxMatrix( type="Full", nrow=1, ncol=ntv, free=TRUE, values=svMe, labels=labVars("mean",vars), name="meanG" )

# Create Matrices for Variance Components
covA      <- mxMatrix( type="Symm", nrow=nv, ncol=nv, free=TRUE, values=svPa, label="VA11", name="VA" ) 
covD      <- mxMatrix( type="Symm", nrow=nv, ncol=nv, free=TRUE, values=svPa, label="VD11", name="VD" )
covE      <- mxMatrix( type="Symm", nrow=nv, ncol=nv, free=TRUE, values=svPe, label="VE11", name="VE" )

# Create Algebra for expected Variance/Covariance Matrices in MZ & DZ twins
covP      <- mxAlgebra( expression= VA+VD+VE, name="V" )
covMZ     <- mxAlgebra( expression= VA+VD, name="cMZ" )
covDZ     <- mxAlgebra( expression= 0.5%x%VA+ 0.25%x%VD, name="cDZ" )
expCovMZ  <- mxAlgebra( expression= rbind( cbind(V, cMZ), cbind(t(cMZ), V)), name="expCovMZ" )
expCovDZ  <- mxAlgebra( expression= rbind( cbind(V, cDZ), cbind(t(cDZ), V)), name="expCovDZ" )

# Create Data Objects for Multiple Groups
dataMZ    <- mxData( observed=mzData, type="raw" )
dataDZ    <- mxData( observed=dzData, type="raw" )

# Create Expectation Objects for Multiple Groups
expMZ     <- mxExpectationNormal( covariance="expCovMZ", means="meanG", dimnames=selVars )
expDZ     <- mxExpectationNormal( covariance="expCovDZ", means="meanG", dimnames=selVars )
funML     <- mxFitFunctionML()

# Create Model Objects for Multiple Groups
pars      <- list( meanG, covA, covD, covE, covP )
modelMZ   <- mxModel( pars, covMZ, expCovMZ, dataMZ, expMZ, funML, name="MZ" )
modelDZ   <- mxModel( pars, covDZ, expCovDZ, dataDZ, expDZ, funML, name="DZ" )
multi     <- mxFitFunctionMultigroup( c("MZ","DZ") )

# Create Algebra for Variance Components
rowVC     <- rep('VC',nv)
colVC     <- rep(c('VA','VD','VE','SA','SD','SE'),each=nv)
estVC     <- mxAlgebra( expression=cbind(VA,VD,VE,VA/V,VD/V,VE/V), name="VC", dimnames=list(rowVC,colVC) )

# Create Confidence Interval Objects
ciADE     <- mxCI( c("VA","VD","VE") )

# Build Model with Confidence Intervals
modelADE  <- mxModel( "oneADEvc", pars, modelMZ, modelDZ, multi, estVC, ciADE )

# ----------------------------------------------------------------------------------------------------------------------
# RUN MODEL

# Run ADE Model
while (TRUE) {
  # fitEMO    <- mxRun( modelEMO, intervals=F )
  fitADE    <- mxTryHard( modelADE, intervals=T )
  if (fitADE$output$status$code==0) {
    break()
  }
}
sumADE    <- summary( fitADE )

# Compare with Saturated Model
#if saturated model fitted in same session
mxCompare( fitSAT, fitADE )
#if saturated model prior to genetic model
lrtSAT(fitADE, sumSAT$Minus2LogLikelihood, sumSAT$degreesOfFreedom)

# Print Goodness-of-fit Statistics & Parameter Estimates
fitGofs(fitADE)
fitEstCis(fitADE)
round(fitADE$VC$result,4)

# ----------------------------------------------------------------------------------------------------------------------
# RUN SUBMODELS

# Run AE model
modelAE   <- mxModel( fitADE, name="oneAEvc" )
modelAE   <- omxSetParameters( modelAE, labels="VD11", free=FALSE, values=0 )
while (TRUE) {
  # fitEMO    <- mxRun( modelEMO, intervals=F )
  fitAE    <- mxTryHard( modelAE, intervals=T )
  if (fitAE$output$status$code==0) {
    break()
  }
}
fitGofs(fitAE); fitEstCis(fitAE)

# Run DE model
modelDE   <- mxModel( fitADE, name="oneDEvc" )
modelDE   <- omxSetParameters( modelDE, labels="VA11", free=FALSE, values=0 )
modelDE   <- omxSetParameters( modelDE, labels=c("VE11","VD11"), free=TRUE, values=.6 )
while (TRUE) {
  # fitEMO    <- mxRun( modelEMO, intervals=F )
  fitDE    <- mxTryHard( modelDE, intervals=T )
  if (fitDE$output$status$code==0) {
    break()
  }
}
fitGofs(fitDE); fitEstCis(fitDE)

# Run E model
modelE    <- mxModel( fitAE, name="oneEvc" )
modelE    <- omxSetParameters( modelE, labels="VA11", free=FALSE, values=0 )
while (TRUE) {
  # fitEMO    <- mxRun( modelEMO, intervals=F )
  fitE    <- mxTryHard( modelE, intervals=T )
  if (fitE$output$status$code==0) {
    break()
  }
}
fitGofs(fitE); fitEstCis(fitE)

# Print Comparative Fit Statistics
mxCompare( fitADE, nested <- list(fitAE, fitDE, fitE) )
round(rbind(fitADE$VC$result,fitAE$VC$result,fitDE$VC$result,fitE$VC$result ),4)

# ----------------------------------------------------------------------------------------------------------------------
# sink()
# save.image(paste(filename,".Ri",sep=""))
