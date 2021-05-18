# ----------------------------------------------------------------------------------------------------------------------
# Program: oneACEc.R
# Author: Hermine Maes
# Date: 10 22 2018
#
# Twin Univariate ACE model to estimate causes of variation across multiple groups
# Matrix style model - Raw data - Continuous data
# -------|---------|---------|---------|---------|---------|---------|---------|---------|---------|---------|---------|
# Load Libraries & Options
rm(list=ls())
library(OpenMx)
library(psych); library(polycor)
source("miFunctions.R")
require(xlsx)
# Load Library
# -----------------------------------------------------------------------------

TryFitting <- function(model, iscalcinterval=TRUE){
  
  fitres <- mxRun(model, intervals = iscalcinterval)
  if(fitres$output$status$code==0){
    return(fitres)
  }else{
    while (TRUE) {
      fitres    <- mxTryHard(model, intervals=iscalcinterval )
      if (fitres$output$status$code==0) {
        break()
      }
    }
    return(fitres)
  }
}



oneACEc <- function(vars){
# Load Data
twinDataraw <-read.xlsx("RDMin1.xlsx", sheetIndex = 1, na.strings = "NA")
# head(twinDataraw)
# remove bad data
twinData = subset(twinDataraw, twinDataraw$twinsNum != c("T001","T028"))
# twinData = subset(twinData, twinData$twinsNum != "T006")

# Select Variables for Analysis
# vars <- 'mcoh' # list of variables names
nv <- 1 # number of variables
ntv <- nv*2 # number of total variables
selVars <- paste(vars,c(rep(1,nv),rep(2,nv)),sep="")

# Select Data for Analysis
mzData <- subset(twinData, zyg==1, selVars)
dzData <- subset(twinData, zyg==2, selVars)

# Generate Descriptive Statistics
colMeans(mzData,na.rm=TRUE)
colMeans(dzData,na.rm=TRUE)
cov(mzData,use="complete")
cov(dzData,use="complete")

# Set Starting Values
svMe <- 10 # start value for means
svPa <- .5 # start value for path coefficient
svPe <- .7 # start value for path coefficient for e
lbPa <- .0001 # lower bound for path coefficient

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
fitACE <- mxRun( modelACE, intervals=T )
sumACE <- summary( fitACE )
# Compare with Saturated Model
#if saturated model fitted in same session
#mxCompare( fitSAT, fitACE )
#if saturated model prior to genetic model
#lrtSAT(fitACE,4055.9346,1767)
# Print Goodness-of-fit Statistics & Parameter Estimates
fitGofs(fitACE)
fitEstCis(fitACE)

# ----------------------------------------------------------------------------------------------------------------------
# RUN SUBMODELS

# Run AE model
modelAE <- mxModel( fitACE, name="oneAEc" )
modelAE <- omxSetParameters( modelAE, labels="c11", free=FALSE, values=0 )
fitAE <- TryFitting( modelAE, TRUE )
fitGofs(fitAE); fitEstCis(fitAE)

# Run CE model
modelCE <- mxModel( fitACE, name="oneCEc" )
modelCE <- omxSetParameters( modelCE, labels="a11", free=FALSE, values=0 )
fitCE <- TryFitting( modelCE, TRUE )
fitGofs(fitCE); fitEstCis(fitCE)

# Run E model
modelE <- mxModel( fitAE, name="oneEc" )
modelE <- omxSetParameters( modelE, labels="a11", free=FALSE, values=0 )
fitE <- TryFitting( modelE, TRUE )
fitGofs(fitE); fitEstCis(fitE)

# Print Comparative Fit Statistics
modelcomp = mxCompare( fitACE, nested <- list(fitAE, fitCE, fitE))
print(round(rbind(fitACE$US$result,fitAE$US$result,fitCE$US$result,fitE$US$result),4))
# ----------------------------------------------------------------------------------------------------------------------
# sink()
# save.image(paste(filename,".Ri",sep=""))

return(modelcomp)
}





