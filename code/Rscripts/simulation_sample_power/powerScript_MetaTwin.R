require(OpenMx)
require(MASS)
mxOption(NULL, 'Default optimizer', 'NPSOL')
source("powerFun.R")

#setwd("")
modrdm <- c()
powerrdm <- c()

modrdm$diff <- acePow(add = .36, com = .0, Nmz = 1e3, Ndz = 1e3)
powerrdm$diffA <- powerValue(1:1000, modrdm$diff$WncpA)


modrdm$mconf <- acePow(add = .33, com = .0, Nmz = 1e3, Ndz = 1e3)
powerrdm$mconfA <- powerValue(1:1000, modrdm$mconf$WncpA)

modrdm$mrt <- acePow(add = .36, com = .0, Nmz = 1e3, Ndz = 1e3)
powerrdm$mrtA <- powerValue(1:1000, modrdm$mrt$WncpA)

modrdm$stdrt <- acePow(add = .21, com = .13, Nmz = 1e3, Ndz = 1e3)
powerrdm$stdrtA <- powerValue(1:1000, modrdm$stdrt$WncpA)
powerrdm$stdrtC <- powerValue(1:1000, modrdm$stdrt$WncpC)

modrdm$rtcorr <- acePow(add = .0, com = .19, Nmz = 1e3, Ndz = 1e3)
powerrdm$rtcorrC <- powerValue(1:1000, modrdm$rtcorr$WncpC)

modrdm$iscgamma <- acePow(add = .09, com = .11, Nmz = 1e3, Ndz = 1e3)
powerrdm$iscgammaA <- powerValue(1:1000, modrdm$iscgamma$WncpA)
powerrdm$iscgammaC <- powerValue(1:1000, modrdm$iscgamma$WncpC)

modrdm$auc <- acePow(add = .1, com = .33, Nmz = 1e3, Ndz = 1e3)
powerrdm$aucA <- powerValue(1:1000, modrdm$auc$WncpA)
powerrdm$aucC <- powerValue(1:1000, modrdm$auc$WncpC)

modrdm$aucresid <- acePow(add = .0, com = .26, Nmz = 1e3, Ndz = 1e3)
powerrdm$aucresidC <- powerValue(1:1000, modrdm$aucresid$WncpC)

### mental twins
modtw <- c()
powertw <- c()

modtw$rtweight <- acePow(add = .46, com = .05, Nmz = 1e3, Ndz = 1e3)
powertw$rtweightA <- powerValue(1:1000, modtw$rtweight$WncpA)

modtw$gamma <- acePow(add = .24, com = .0, Nmz = 1e3, Ndz = 1e3)
powertw$gammaA <- powerValue(1:1000, modtw$gamma$WncpA)

modtw$auc <- acePow(add = .31, com = .0, Nmz = 1e3, Ndz = 1e3)
powertw$aucA <- powerValue(1:1000, modtw$auc$WncpA)

modtw$aucresid <- acePow(add = .0, com = .15, Nmz = 1e3, Ndz = 1e3)
powertw$aucresidC <- powerValue(1:1000, modtw$aucresid$WncpC)

### mental strangers
modst <- c()
powerst <-c()

modst$rtweight <- acePow(add = .54, com = .0, Nmz = 1e3, Ndz = 1e3)
powerst$rtweightA <- powerValue(1:1000, modst$rtweight$WncpA)

modst$gamma <- acePow(add = .21, com = .17, Nmz = 1e3, Ndz = 1e3)
powerst$gammaA <- powerValue(1:1000, modst$gamma$WncpA)
powerst$gammaC <- powerValue(1:1000, modst$gamma$WncpC)

modst$auc <- acePow(add = .25, com = .24, Nmz = 1e3, Ndz = 1e3)
powerst$aucA <- powerValue(1:1000, modst$auc$WncpA)
powerst$aucC <- powerValue(1:1000, modst$auc$WncpC)

# modst$aucresid <- acePow(add = .0, com = .0, Nmz = 1e3, Ndz = 1e3)
# powerst$aucresid <- powerValue(1:1000, modst$aucresid$WncpA)

require(R.matlab)
writeMat('res1e3.mat', powerrdm = powerrdm, powerst=powerst, powertw = powertw)


# write.csv(allfit, paste0('R2MATLAB/', 'allACE_', thisvar, '.csv'))

