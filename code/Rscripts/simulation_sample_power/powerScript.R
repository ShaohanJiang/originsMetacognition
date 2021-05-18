require(OpenMx)
require(MASS)
mxOption(NULL, 'Default optimizer', 'NPSOL')
source("powerFun.R")

#setwd("")

# 4 Steps for Calculating Power in Twin Studies

## 1) Simulate data for the MZ and DZ twins. 
## The first step is to simulate twin data that corresponds with your expectations about the results. These expectations 
## should be based, as far possible, on the literature. Of course, if you are doing something that has never been done 
## before, these expectations can be less clear. It is also important to consider the ratio of MZ to DZ twins, as the 
## power to detect significant genetic or environmental variance is influenced by this ratio. Specifically, you will 
## need to provide the proportions of variance for the standardized A, C and E variance components. You will not have to 
## simulate the data yourself (the functions will automatically take care of this step), but you will have to provide 
## the values for the ACE parameters.
## 
## 2) Fit the model. 
## The second step is simply to fit the model to the simulated data. Again, the function will do this automatically and 
## return a set of fitted parameters. It is important to make sure that the fitted parameters correspond to the values 
## that you specified in the previous stage. In some cases the simulated values may not correspond with the fitted 
## parameters. In these cases, a warning message will appear. If this happens, it is possible to increase the sample 
## size (keeping the ratio of the MZ to DZ twins constant). While fitting the full ACE model, it is trivial to also 
## fit a reduced model where the parameter of interest is fixed to zero. Fitting both the full and the reduced model 
## provides the difference between the -2 LogLikelihoods and the and obtain the χ2 value for the models, which is 
## the primary purpose of this step.
## 
## 
## 3) Obtain the weighted ncp (Wncp) 
## Third, to obtain the Wncp, we divide the χ2 value by the total sample size (NMZ + NDZ). By dividing the χ2 value 
## by the sample size, we are calculating the average contribution of each family to χ2 value. Therefore, this value 
## is dubbed the weighted ncp (Wncp).
## 
## 
## 4) Calculate power. 
## Power is calculated using the Wncp value obtained in the previous step. The essential component to discussing power 
## from the perspective of the ncp is that the ncp increases linearly with sample size this process. For example, if 
## the value of the χ2 value for the LRT between an ACE model and an AE model is 10 with 500 MZ and 500 DZ twin 
## pairs (N = 1000), each family will contribute 10/1000 = .01 to the χ2 value, on average. It is then possible to 
## extrapolate that with 2000 families, the χ2 value would be 20, and with 500 families the χ2 value would be 5. 
## Therefore, to apply this to an arbitrary set of sample sizes, we can multiply the Wncp obtained in the previous 
## step by a vector of sample sizes to obtain a vector of ncp's. This vector of ncp's is then used to calculate the 
## power for each sample size. 
## 
## Specifically, power is computed using the following code in R:
## 1- pchisq(qchisq(1- pcrit, 1), 1, ncp)






#  Major Question: What is the power to detect Va and Vc in the classical twin design?
#  Minor Question: What factors affect this power?

# What is the Power of A the Univariate Model as C increases?
# Note: the following 3 lines of code are calculating the power for a specific set of variables

modA1 <- acePow(add = .33, com = .1, Nmz = 1000, Ndz = 1000)
modA2 <- acePow(add = .33, com = .3, Nmz = 1000, Ndz = 1000)
modA3 <- acePow(add = .33, com = .5, Nmz = 1000, Ndz = 1000)

# Note: The following lines of code are used to make plots. The plot used below are writen as helper 
#       functions and can be edited (in R) using standard plotting commands. These will be generally
#       repeated for the other graphs in this tutorial.

par(mfrow = c(1,2), mar = c(4, 5, 2, 1) + 0.1)
powerPlot(maxN = 1500, Wncp = c(modA1$WncpA, modA2$WncpA, modA3$WncpA))
legText <- c("A = .33 & C = .1", "A = .33 & C = .3", "A = .33 & C = .5")
legend("right", legend = legText, col = 1:3, ncol = 1, cex = 1, lwd = 3, box.lwd = 0)
mtext("Additive Genetic Variance", cex = 1.5)

# What is the Power of C the Univariate Model as A increases?
modC1 <- acePow(add = .1, com = .33, Nmz = 1000, Ndz = 1000)
modC2 <- acePow(add = .3, com = .33, Nmz = 1000, Ndz = 1000)
modC3 <- acePow(add = .5, com = .33, Nmz = 1000, Ndz = 1000)

#par( mar = c(4, 5, 2, 1) + 0.1)
powerPlot(maxN = 1500, Wncp = c(modC1$WncpC, modC2$WncpC, modC3$WncpC))
legText <- c("A = .1 & C = .33", "A = .3 & C = .33", "A = .5 & C = .33")
legend("right", legend = legText, col = 1:3, ncol = 1, cex = 1, lwd = 3, box.lwd = 0)
mtext("Common Environmental Variance", cex = 1.5)


#  Major Question: How does the proportion of MZ to DZ twins affect the power to detect Va and Vc?

# What is the Power of A and C in the Univariate Model if the MZ and DZ groups are of different sizes?
modN1 <- acePow(add = .33, com = .33, Nmz = 5000, Ndz = 1000)
modN2 <- acePow(add = .33, com = .33, Nmz = 3000, Ndz = 3000)
modN3 <- acePow(add = .33, com = .33, Nmz = 1000, Ndz = 5000)

par(mfrow = c(1,2),  mar = c(4, 5, 2, 1) + 0.1)
powerPlot(maxN = 1500, Wncp = c(modN1$WncpA, modN2$WncpA, modN3$WncpA))
legText <- c("MZ:DZ = 5:1", "MZ:DZ = 1:1", "MZ:DZ = 1:5")
legend("right", legend = legText, col = 1:3, ncol = 1, cex = 1, lwd = 3, box.lwd = 0)
mtext("Additive Genetic Variance", cex = 1.5)

powerPlot(maxN = 1500, Wncp = c(modN1$WncpC, modN2$WncpC, modN3$WncpC))
mtext("Common Environmental Variance", cex = 1.5)
legend("right", legend = legText, col = 1:3, ncol = 1, cex = 1, lwd = 3, box.lwd = 0)


#  Major Question: How does the prevalance of a binary trait affect power?

# What is the Power of A the Univariate Model for Binomial Data (relative to a continuous variable)
con  <- acePow( add  = .33, com  = .33, Nmz  = 1000, Ndz  = 1000)
bin5 <- acePowOrd( add  = .33, com  = .33,  percent = c(.5, .5), Nmz  = 1000, Ndz  = 1000)
bin4 <- acePowOrd( add  = .33, com  = .33,  percent = c(.4, .6), Nmz  = 1000, Ndz  = 1000)
bin3 <- acePowOrd( add  = .33, com  = .33,  percent = c(.3, .7), Nmz  = 1000, Ndz  = 1000)
bin2 <- acePowOrd( add  = .33, com  = .33,  percent = c(.2, .8), Nmz  = 1000, Ndz  = 1000)
bin1 <- acePowOrd( add  = .33, com  = .33,  percent = c(.9, .1), Nmz  = 1000, Ndz  = 1000)
bin05 <- acePowOrd( add  = .33, com  = .33,  percent = c(.05, .95), Nmz  = 1000, Ndz  = 1000)
 
powerPlot(maxN = 5000, Wncp = c(con$WncpA, bin5$WncpA, bin4$WncpA, bin3$WncpA, bin2$WncpA, bin1$WncpA, bin05$WncpA), pcrit = .05)
legText <- c("Continuous", "Binary (Prevalence = .5)","Binary (Prevalence = .4)","Binary (Prevalence = .3)",
             "Binary (Prevalence = .2)", "Binary (Prevalence = .1)", "Binary (Prevalence = .05)")
legend("bottomright", legend = legText, col = 1:7, ncol = 1, cex = 1, lwd = 3, box.lwd = 0)
 
 
# Major Question: What is the Power to detect correlations bewteen the variance components? 
 
# What is the Power to detect Rg in the Bivariate Model?
rg1 <- bivPow(A1 = .3, A2 = .3, rg = .10, C1 = .33, C2 = .33, rc = .1, Nmz = 1000, Ndz = 1000)
rg2 <- bivPow(A1 = .3, A2 = .3, rg = .30, C1 = .33, C2 = .33, rc = .3, Nmz = 1000, Ndz = 1000)
rg3 <- bivPow(A1 = .3, A2 = .3, rg = .50, C1 = .33, C2 = .33, rc = .5, Nmz = 1000, Ndz = 1000)

rg4 <- bivPow(A1 = .4, A2 = .4, rg = .10, C1 = .33, C2 = .33, rc = .1, Nmz = 1000, Ndz = 1000)
rg5 <- bivPow(A1 = .4, A2 = .4, rg = .30, C1 = .33, C2 = .33, rc = .3, Nmz = 1000, Ndz = 1000)
rg6 <- bivPow(A1 = .4, A2 = .4, rg = .50, C1 = .33, C2 = .33, rc = .5, Nmz = 1000, Ndz = 1000)

rg7 <- bivPow(A1 = .5, A2 = .5, rg = .10, C1 = .33, C2 = .33, rc = .1, Nmz = 1000, Ndz = 1000)
rg8 <- bivPow(A1 = .5, A2 = .5, rg = .30, C1 = .33, C2 = .33, rc = .3, Nmz = 1000, Ndz = 1000)
rg9 <- bivPow(A1 = .5, A2 = .5, rg = .50, C1 = .33, C2 = .33, rc = .5, Nmz = 1000, Ndz = 1000)

par(mfrow = c(3,2),  mar = c(4, 5, 2, 1) + 0.1)
powerPlot(maxN = 750, Wncp = c(rg1$WncpA1, rg2$WncpA1, rg3$WncpA1))
legText <- c("a = .3 & rg = .1", "a = .3 & rg = .3", "a = .3 & rg = .5")
legend("right", legend = legText, col = 1:3, ncol = 1, cex = 1, lwd = 3, box.lwd = 0)
mtext("Additive Genetic Variance", cex = 1)

powerPlot(maxN = 2000, Wncp = c(rg1$WncpRg, rg2$WncpRg, rg3$WncpRg))
mtext("Genetic Correlation", cex = 1)

powerPlot(maxN = 750, Wncp = c(rg4$WncpA1, rg5$WncpA1, rg6$WncpA1))
legText <- c("a = .4 & rg = .1", "a = .4 & rg = .3", "a = .4 & rg = .5")
legend("right", legend = legText, col = 1:3, ncol = 1, cex = 1, lwd = 3, box.lwd = 0)
mtext("Additive Genetic Variance", cex = 1)

powerPlot(maxN = 2000, Wncp = c(rg4$WncpRg, rg5$WncpRg, rg6$WncpRg))
mtext("Genetic Correlation", cex = 1)

powerPlot(maxN = 750, Wncp = c(rg7$WncpA1, rg8$WncpA1, rg9$WncpA1))
legText <- c("a = .5 & rg = .1", "a = .5 & rg = .3", "a = .5 & rg = .5")
legend("right", legend = legText, col = 1:3, ncol = 1, cex = 1, lwd = 3, box.lwd = 0)
mtext("Additive Genetic Variance", cex = 1)

powerPlot(maxN = 2000, Wncp = c(rg7$WncpRg, rg8$WncpRg, rg9$WncpRg))
mtext("Genetic Correlation", cex = 1)


#   # What is the Power to detect Rg in the Bivariate Ordinal Model?
# org1 <- aceBivPowOrd(A1 = .3, A2 = .3, rg = .10, C1 = .33, C2 = .33, rc = .1, percent1 = c(.25, .25, .25,.25), percent2 = c(.33,.34,.33), Nmz = 1000, Ndz = 1000)
# org2 <- aceBivPowOrd(A1 = .3, A2 = .3, rg = .30, C1 = .33, C2 = .33, rc = .3, percent1 = c(.25, .25, .25,.25), percent2 = c(.33,.34,.33), Nmz = 1000, Ndz = 1000)
# org3 <- aceBivPowOrd(A1 = .3, A2 = .3, rg = .50, C1 = .33, C2 = .33, rc = .5, percent1 = c(.25, .25, .25,.25), percent2 = c(.33,.34,.33), Nmz = 1000, Ndz = 1000)
# 
# org4 <- aceBivPowOrd(A1 = .4, A2 = .4, rg = .10, C1 = .33, C2 = .33, rc = .1, percent1 = c(.25, .25, .25,.25), percent2 = c(.33,.34,.33), Nmz = 1000, Ndz = 1000)
# org5 <- aceBivPowOrd(A1 = .4, A2 = .4, rg = .30, C1 = .33, C2 = .33, rc = .3, percent1 = c(.25, .25, .25,.25), percent2 = c(.33,.34,.33), Nmz = 1000, Ndz = 1000)
# org6 <- aceBivPowOrd(A1 = .4, A2 = .4, rg = .50, C1 = .33, C2 = .33, rc = .5, percent1 = c(.25, .25, .25,.25), percent2 = c(.33,.34,.33), Nmz = 1000, Ndz = 1000)
# 
# org7 <- aceBivPowOrd(A1 = .5, A2 = .5, rg = .10, C1 = .33, C2 = .33, rc = .1, percent1 = c(.25, .25, .25,.25), percent2 = c(.33,.34,.33), Nmz = 1000, Ndz = 1000)
# org8 <- aceBivPowOrd(A1 = .5, A2 = .5, rg = .30, C1 = .33, C2 = .33, rc = .3, percent1 = c(.25, .25, .25,.25), percent2 = c(.33,.34,.33), Nmz = 1000, Ndz = 1000)
# org9 <- aceBivPowOrd(A1 = .5, A2 = .5, rg = .50, C1 = .33, C2 = .33, rc = .5, percent1 = c(.25, .25, .25,.25), percent2 = c(.33,.34,.33), Nmz = 1000, Ndz = 1000)
# 
# par(mfrow = c(3,1),  mar = c(4, 5, 2, 1) + 0.1)
# powerPlot(maxN = 5000, Wncp = c(org1$WncpRg, org2$WncpRg, org3$WncpRg))
# mtext("Genetic Correlation", cex = 1)
# legText <- c("a = .3 & rg = .1", "a = .3 & rg = .3", "a = .3 & rg = .5")
# legend("topleft", legend = legText, col = 1:3, ncol = 1, cex = 1, lwd = 3, box.lwd = 0)
# 
# powerPlot(maxN = 5000, Wncp = c(org4$WncpRg, org5$WncpRg, org6$WncpRg))
# mtext("Genetic Correlation", cex = 1)
# legText <- c("a = .4 & rg = .1", "a = .4 & rg = .3", "a = .4 & rg = .5")
# legend("bottomright", legend = legText, col = 1:3, ncol = 1, cex = 1, lwd = 3, box.lwd = 0)
# 
# powerPlot(maxN = 5000, Wncp = c(org7$WncpRg, org8$WncpRg, org9$WncpRg))
# mtext("Genetic Correlation", cex = 1)
# legText <- c("a = .5 & rg = .1", "a = .5 & rg = .3", "a = .5 & rg = .5")
# legend("bottomright", legend = legText, col = 1:3, ncol = 1, cex = 1, lwd = 3, box.lwd = 0)


# What is the Power to detect Qualitative (different genes) and Quantitative (same genes but to different extents) Sex Limitation?

# Qualitative Sex Limitation
qual9 <- sexLimPower(am = .5, cm = .1, af = .5, cf = .1, rg = .9  , Nmzm = 5000, Nmzf = 5000, Ndzm = 5000, Ndzf = 5000, Ndzo = 10000)
qual7 <- sexLimPower(am = .5, cm = .1, af = .5, cf = .1, rg = .7  , Nmzm = 5000, Nmzf = 5000, Ndzm = 5000, Ndzf = 5000, Ndzo = 10000)
qual5 <- sexLimPower(am = .5, cm = .1, af = .5, cf = .1, rg = .5  , Nmzm = 5000, Nmzf = 5000, Ndzm = 5000, Ndzf = 5000, Ndzo = 10000)
qual3 <- sexLimPower(am = .5, cm = .1, af = .5, cf = .1, rg = .3  , Nmzm = 5000, Nmzf = 5000, Ndzm = 5000, Ndzf = 5000, Ndzo = 10000)
qual1 <- sexLimPower(am = .5, cm = .1, af = .5, cf = .1, rg = .1  , Nmzm = 5000, Nmzf = 5000, Ndzm = 5000, Ndzf = 5000, Ndzo = 10000)

# Quantitative Sex Limitation
quant1 <- sexLimPower(am = .2, cm = .2, af = .5, cf = .2, rg = 1, Nmzm = 5000, Nmzf = 5000, Ndzm = 5000, Ndzf = 5000, Ndzo = 5000)
quant2 <- sexLimPower(am = .3, cm = .2, af = .5, cf = .2, rg = 1, Nmzm = 5000, Nmzf = 5000, Ndzm = 5000, Ndzf = 5000, Ndzo = 5000)
quant3 <- sexLimPower(am = .4, cm = .2, af = .5, cf = .2, rg = 1, Nmzm = 5000, Nmzf = 5000, Ndzm = 5000, Ndzf = 5000, Ndzo = 5000)


par(mfrow = c(1,2),  mar = c(4, 5, 2, 1) + 0.1)

powerPlot(maxN = 15000, Wncp = c(qual9$WncpRg, qual7$WncpRg, qual5$WncpRg, qual3$WncpRg, qual1$WncpRg))
legText <- c("rg = .9", "rg = .7", "rg = .5", "rg = .3", "rg = .1")
legend("bottomright", legend = legText, col = 1:5, ncol = 1, cex = 1, lwd = 3, box.lwd = 0)
mtext("Qualitative Sex Limitation", cex = 1)
# 41738 twin pairs required for 80% power for rg=.9

powerPlot(maxN = 5000, Wncp = c(quant1$WncpEqualA, quant2$WncpEqualA, quant3$WncpEqualA))
legText <- c("Am = .2 & Af = .5", "Am = .3 & Af = .5", "Am = .4 & Af = .5")
legend("bottomright", legend = legText, col = 1:3, ncol = 1, cex = 1, lwd = 3, box.lwd = 0)
mtext("Quantitative Sex Limitation", cex = 1)


# What is the Power to detect Additive Genetic Variance in a Common Pathway Twin Model?

# Simulate data for the Common Pathway Model 
ComPathDat <- comPathSim(aL=.2, cL=.2, eL=.6, load = c(.9,.8,.7,.6,.5), 
                         specA = c(.2, .2, .2, .2,.2), specC = c(.2, .2, .2, .2,.2), specE = c(.2, .2, .2, .2,.2), 
						 Nmz = 2000, Ndz = 2000)

# Put the data into MZ and DZ objects
mzData <- ComPathDat$mzData	
dzData <- ComPathDat$dzData	
	
# Set up objects for the analysis
selVars <- colnames(mzData)            
nf  <- 1       # number of factors
ntv <-  dim(mzData)[2]
nv <- ntv/2
nl        <- 1
vars <- paste("V", 1:nv, sep = "")

# Create Mean Matrices
meanG     <- mxMatrix( type="Full", nrow=1, ncol=ntv, free=TRUE, values=0, labels=paste("mean",vars,sep="_"), name="meanG" )

# Matrices ac, cc, and ec to store a, c, and e path coefficients for latent phenotype(s)
pathAl    <- mxMatrix( type="Lower", nrow=nl, ncol=nl, free=TRUE, values=.6, labels="aPath", lbound=.00001, name="al" )
pathCl    <- mxMatrix( type="Lower", nrow=nl, ncol=nl, free=TRUE, values=.6, labels="cPath", lbound=.00001, name="cl" )
pathEl    <- mxMatrix( type="Lower", nrow=nl, ncol=nl, free=TRUE, values=.6, labels="ePath", lbound=.00001, name="el" )

# Matrix and Algebra for constraint on variance of latent phenotype
covarLP   <- mxAlgebra( expression=al %*% t(al) + cl %*% t(cl) + el %*% t(el), name="CovarLP" )
varLP     <- mxAlgebra( expression= diag2vec(CovarLP), name="VarLP" )
unit      <- mxMatrix( type="Unit", nrow=nl, ncol=1, name="Unit")
varLP1    <- mxConstraint( expression=VarLP == Unit, name="varLP1")

# Matrix f for factor loadings on latent phenotype
pathFl    <- mxMatrix( type="Full", nrow=nv, ncol=nl, free=TRUE, values=.2, labels=paste("load",1:nv,sep = ""), name="fl" )

# Matrices as, cs, and es to store a, c, and e path coefficients for specific factors
pathAs    <- mxMatrix( type="Diag", nrow=nv, ncol=nv, free=TRUE, values=.4, labels=paste("as",1:nv, sep = ""), lbound=.00001, name="as" )
pathCs    <- mxMatrix( type="Diag", nrow=nv, ncol=nv, free=TRUE, values=.4, labels=paste("cs",1:nv, sep = ""), lbound=.00001, name="cs" )
pathEs    <- mxMatrix( type="Diag", nrow=nv, ncol=nv, free=TRUE, values=.5, labels=paste("es",1:nv, sep = ""), lbound=.00001, name="es" )

# Matrices A, C, and E compute variance components
covA      <- mxAlgebra( expression=fl %&% (al %*% t(al)) + as %*% t(as), name="A" )
covC      <- mxAlgebra( expression=fl %&% (cl %*% t(cl)) + cs %*% t(cs), name="C" )
covE      <- mxAlgebra( expression=fl %&% (el %*% t(el)) + es %*% t(es), name="E" )

# Create Algebra for expected Variance/Covariance Matrices in MZ & DZ twins
covP      <- mxAlgebra( expression= A+C+E, name="V" )
covMZ     <- mxAlgebra( expression= A+C, name="cMZ" )
covDZ     <- mxAlgebra( expression= 0.5%x%A+ C, name="cDZ" )
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
pars      <- list(meanG, pathAl, pathCl, pathEl, covarLP, varLP, unit, pathFl, pathAs, pathCs, pathEs, covA, covC, covE, covP)
modelMZ   <- mxModel( name="MZ", pars, covMZ, expCovMZ, dataMZ, expMZ, funML )
modelDZ   <- mxModel( name="DZ", pars, covDZ, expCovDZ, dataDZ, expDZ, funML )
multi     <- mxFitFunctionMultigroup( c("MZ","DZ") )

# Build & Run the Full Model 
modelCP   <- mxModel( "ComPath", pars, varLP1, modelMZ, modelDZ, multi )
fullCP     <- mxRun(modelCP)
summary(fullCP)

# Build & Run the Reduced Model 
redCP <- omxSetParameters(fullCP, labels = "aPath", value = 0, free = FALSE, name = "reduced")
redCP     <- mxRun(redCP)
summary(redCP)

# Calculate the Weighted NCP
neg2LL <- redCP$output$fit - fullCP$output$fit
totN   <- dim(mzData)[1]+dim(dzData)[1]
Wncp <- neg2LL / totN
Wncp

powerPlot(maxN = 2000, Wncp = c( 0.003413346, 0.00928087, 0.03469791)) 
legText <- c("A = .2, C = .2, & E = .6", "A = .3, C = .2, & E = .5", "A = .4, C = .2, & E = .4")
legend("bottomright", legend = legText, col = 1:3, ncol = 1, cex = 1, lwd = 3, box.lwd = 0)
mtext("Power to detect Additive Genetic \n Variance in a Latent Factor", cex = 1.5, line = 1)



