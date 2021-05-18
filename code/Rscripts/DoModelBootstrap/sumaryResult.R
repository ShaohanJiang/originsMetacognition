setwd("D:/Documents/ScriptR/DoModelBootstrap")
# library(R.matlab)

allvar = c('selfguessauc','selfguessaucresid','stdrtime')

thisvar = 'stranger_selfguessaucresid'
resfolder = paste0('res_modelcomp/', thisvar)
allresfiles = dir(resfolder)

ace.model = c('ACE', 'AE', 'CE', 'E')
ade.model = c('ADE', 'AE', 'DE', 'E')
allfit = data.frame(Mcode=NaN,A=NaN,A_D=NaN,E=NaN,SA=NaN,SD_SC=NaN,SE=NaN)
M = c()

for (jj in 1:length(allresfiles)) {
  pathtofile = paste(resfolder, allresfiles[jj], sep = '/')
  load(pathtofile)
  
  for (ii in 1:length(res)) {
    sat.aic = res[[ii]][[1]]
    
    ace.fit = res[[ii]][[2]][[1]]
    ace.coeff = res[[ii]][[2]][[2]]
    
    ade.fit = res[[ii]][[3]][[1]]
    ade.coeff = res[[ii]][[3]][[2]]
    
    ace.comp = ace.fit$AIC - sat.aic
    
    ade.comp = ade.fit$AIC - sat.aic
    
    
    if (ace.comp[1] < ade.comp[1]) { # ACE win
      
      minAIC = min(ace.comp)
      minidx = match(minAIC, ace.comp)
      bestcoef = ace.coeff[minidx,]
      bestmodel = ace.model[minidx]
      modelidx = minidx
      
      
    }else{ # ADE win
      minAIC = min(ade.comp)
      minidx = match(minAIC, ade.comp)
      bestcoef = ade.coeff[minidx,]
      bestmodel = ade.model[minidx]
      modelidx = minidx + 4
      
    }
    M[(jj-1)*200+ii] = bestmodel
    allfit[(jj-1)*200+ii, ] = c(modelidx, bestcoef)
  }
}
allfit$M = M
write.csv(allfit, paste0('R2MATLAB/', 'allbest_', thisvar, '.csv'))
# writeMat(paste0('R2MATLAB/', 'allfit_', thisvar, '.mat'), allfit = allfit)

#############################################
##### collect ACE results ###################
#############################################

setwd("D:/Documents/ScriptR/DoModelBootstrap")
# library(R.matlab)

# allvar = paste0('res_modelcomp/[backup33]/', c('mcoh','mconf','mrtime','rtweight','myiscgamma','selfguessauc'))
# allvar =  c('stranger_rtweight','twin_myiscgamma','twin_myiscgammahigh','twin_selfguessauc')
# allvar = c('rtcorr','aucresid')
allvar = c('stranger_myiscgammahigh')

for (thisvar in allvar){
  # resfolder = paste0('res_modelcomp/[backup33]/', thisvar)
  resfolder = paste0('res_modelcomp', thisvar)
  allresfiles = dir(resfolder)
  
  ace.model = c('ACE', 'AE', 'CE', 'E')
  ade.model = c('ADE', 'AE', 'DE', 'E')
  allfit = data.frame(Mcode=NaN,A=NaN,A_D=NaN,E=NaN,SA=NaN,SD_SC=NaN,SE=NaN)
  M = c()
  
  for (jj in 1:length(allresfiles)) {
    pathtofile = paste(resfolder, allresfiles[jj], sep = '/')
    load(pathtofile)
    
    for (ii in 1:length(res)) {
      
      ace.fit = res[[ii]][[2]][[1]]
      ace.coeff = res[[ii]][[2]][[2]]
      
      
      
      bestcoef = ace.coeff[1,]
      M[(jj-1)*200+ii] = ace.model[1]
      allfit[(jj-1)*200+ii, ] = c(1, bestcoef)
    }
  }
  allfit$M = M
  write.csv(allfit, paste0('R2MATLAB/', 'allACE_', thisvar, '.csv'))
}
# writeMat(paste0('R2MATLAB/', 'allfit_', thisvar, '.mat'), allfit = allfit)