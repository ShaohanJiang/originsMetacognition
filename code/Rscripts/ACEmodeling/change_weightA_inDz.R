fun <- function(x){
  # setwd("D:/Documents/ScriptR")
  
  library(OpenMx)
  library(psych); library(polycor)
  library(R.matlab)
  require(xlsx)
  source("miFunctions.R")
  source("TwinsModelsFunctions_path.R")
  
  resfolder <- 'result_changeWeightA'
  if(!dir.exists(resfolder)){
    dir.create(resfolder)
  }
  
  twinDataraw <-read.table("RDMin1.csv", header = TRUE, sep = ",", na.strings = "NA")
  fprefix <- paste0(resfolder, '/path_RDM_')
  twinData = subset(twinDataraw, !(twinDataraw$twinsNum %in% c('T001','T007','T013','T028','T035','T053','T054','T055','T087','T090')))
  allvars <- c('mcoh', 'mconf', 'mrtime', 'stdrtime', 'rtcorr', 'iscgamma', 'auc', 'aucresid')
  
  # twinDataraw <-read.table("TwinMental.csv", header = TRUE, sep = ",", na.strings = "NA")
  # fprefix <- paste0(resfolder, '/path_MentTw_')
  # twinData = twinDataraw
  # allvars <- c('rtweight', 'myiscgamma', 'myiscgammahigh', 'selfguessauc', 'selfguessaucresid')
  
  # twinDataraw <-read.table("StrangerMental.csv", header = TRUE, sep = ",", na.strings = "NA")
  # fprefix <- paste0(resfolder, '/path_MentStrng_')
  # twinData = twinDataraw
  # allvars <- c('rtweight', 'myiscgamma', 'myiscgammahigh', 'selfguessauc', 'selfguessaucresid')
  
  
  
  vv = 1
  
  for (vars in allvars){
    # vars <- "auc" # list of variables names
    nv <- 1 # number of variables
    ntv <- nv*2 # number of total variables
    selVars <- paste(vars,c(rep(1,nv),rep(2,nv)),sep="")
    
    mzData <- subset(twinData, zyg==1, selVars)
    dzData <- subset(twinData, zyg==2, selVars)
    
    # nmz <- nrow(mzData)
    # ndz <- nrow(dzData)
    # mzData <- mzData[sample(c(1:nmz), chunk.size), ]
    # dzData <- dzData[sample(c(1:ndz), chunk.size), ]
    allacecoef <- c()
    wa <- seq(0, 1, 0.05)
    for (ia in 1:length(wa)){
      satres <- SAT_path(mzData, dzData, vars)
      aceres <- ACE_path(mzData, dzData, vars, wa[ia])
      # aderes <- ADEmodelCompare(mzData, dzData, vars)
      
      fitSAT = satres$fitSAT
      fitACE = aceres$fitACE
      fitAE = aceres$fitAE
      fitCE = aceres$fitCE
      fitE = aceres$fitE
      # compSAT <- mxCompare( fitSAT, subs <- list(fitEMO, fitEMVO, fitEMVZ) )
      
      compSATACE <- mxCompare( fitSAT, fitACE )
      compACE <- mxCompare( fitACE, nested <- list(fitAE, fitCE, fitE) )
      acecoef <- round(rbind(fitACE$US$result,fitAE$US$result,fitCE$US$result,fitE$US$result),4)
      aceci <- round(rbind(fitACE$output$confidenceIntervals, fitAE$output$confidenceIntervals, fitCE$output$confidenceIntervals),4)
      
      allacecoef <- rbind(allacecoef, round(fitACE$US$result,4))
    }
    
    dnow =  format(Sys.time(), "%Y-%m-%d_%H;%M;%S")
    outputfile = paste0(fprefix, vv, vars, '_0051_', dnow, ".xlsx")  ## "coage",
    # write.xlsx(rbind(compSAT, compSATACE, compSATADE, compACE, compADE), outputfile, 
    #            col.names = TRUE, row.names = TRUE, sheetName = "Model Compare", append = F)
    write.xlsx(allacecoef, outputfile,
               col.names = TRUE, row.names = TRUE, sheetName = "ACE Model Coeff", append = F)
    # write.xlsx(aceci, outputfile,
    #            col.names = TRUE, row.names = TRUE, sheetName = "ACE Model CI", append = TRUE)
    # write.xlsx(adecoef, outputfile,
    #            col.names = TRUE, row.names = TRUE, sheetName = "ADE Model Coeff", append = TRUE)
    # write.xlsx(adeci, outputfile,
    #            col.names = TRUE, row.names = TRUE, sheetName = "ADE Model CI", append = TRUE)
    
    vv = vv+1
  }
}

fun()