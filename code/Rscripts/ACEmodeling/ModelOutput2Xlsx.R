require(xlsx)
compSAT <- mxCompare( fitSAT, subs <- list(fitEMO, fitEMVO, fitEMVZ) )

compSATACE <- mxCompare( fitSAT, fitACE )
compACE <- mxCompare( fitACE, nested <- list(fitACEAE, fitCE, fitACEE) )
acecoef <- round(rbind(fitACE$US$result,fitACEAE$US$result,fitCE$US$result,fitACEE$US$result),4)

aceci <- round(rbind(fitACE$output$confidenceIntervals,fitACEAE$output$confidenceIntervals,fitCE$output$confidenceIntervals),4)

compSATADE <- mxCompare( fitSAT, fitADE )
compADE <- mxCompare( fitADE, nested <- list(fitADEAE, fitDE, fitADEE) )
adecoef <- round(rbind(fitADE$US$result, fitADEAE$US$result, fitDE$US$result,fitADEE$US$result ),4)
adeci <- round(rbind(fitADE$output$confidenceIntervals, fitADEAE$output$confidenceIntervals, fitDE$output$confidenceIntervals),4)

dnow =  format(Sys.time(), "%Y-%m-%d_%H;%M;%S")
outputfile = paste("path_", vars, dnow, ".xlsx",sep = "") #"coage",
write.xlsx(rbind(compSAT, compSATACE, compSATADE, compACE, compADE), outputfile, 
           col.names = TRUE, row.names = TRUE, sheetName = "Model Compare", append = F)
write.xlsx(acecoef, outputfile,
           col.names = TRUE, row.names = TRUE, sheetName = "ACE Model Coeff", append = TRUE)
write.xlsx(aceci, outputfile,
           col.names = TRUE, row.names = TRUE, sheetName = "ACE Model CI", append = TRUE)
write.xlsx(adecoef, outputfile,
           col.names = TRUE, row.names = TRUE, sheetName = "ADE Model Coeff", append = TRUE)
write.xlsx(adeci, outputfile,
           col.names = TRUE, row.names = TRUE, sheetName = "ADE Model CI", append = TRUE)

