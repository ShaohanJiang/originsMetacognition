#---------------------------------------------------------------------------------------------------------
#                                                  ACE Model
#   DVM Bishop 13th March 2010; based on p 18, OpenMx manual
#---------------------------------------------------------------------------------------------------------
# mytwindata=read.table("mytwinfile")
#read in previously saved data created with Twin Simulate script
# myDataMZ=mytwindata[,1:2]  #columns 1-2 are MZ twin1 and twin2
# myDataDZ=mytwindata[,3:4]  #columns 3-4 are DZ twin 1 and twin 2
require(OpenMx)
mytwindata=read.csv("mz_mcoh_in1.csv",header = FALSE)
myDataMZ=mytwindata 
mytwindata=read.csv("dz_mcoh_in1.csv", header = FALSE)
myDataDZ=mytwindata 
###########
# myDataMZ = rbind(myDataMZ,myDataMZ)
# myDataDZ = rbind(myDataDZ,myDataDZ)
###########
colnames(myDataMZ)=c("twin1","twin2")
colnames(myDataDZ)=colnames(myDataMZ)
mylabels=colnames(myDataMZ)

# 构建ACE模型 twinACE给变量myACEModel
myACEModel <- mxModel("twinACE",
                      # Matrix expMean for expected mean vector for MZ and DZ twins
                      mxMatrix(type="Full",
                               nrow= 1,
                               ncol=2,
                               free=TRUE,
                               values=0,
                               labels= "mean",
                               name="expMean"),
                      # Matrices X, Y, and Z to store the a, c, and e path coefficients
                      mxMatrix(type="Full",
                               nrow=1,  #just one row and one column to estimate path a
                               ncol=1,
                               free=TRUE,
                               values=.6, #starting values (路径系数的初始值)
                               label="a", 
                               name="X"),
                      mxMatrix(type="Full",
                               nrow=1,
                               ncol=1,
                               free=TRUE,
                               values=.6,
                               label="c",
                               name="Y"),
                      mxMatrix(type="Full",
                               nrow=1,
                               ncol=1,
                               free=TRUE,
                               values=.6,
                               label="e",
                               name="Z"),
                      # Matrixes A, C, and E to compute A, C, and E variance components
                      # A=X^2 路径系数平方反应变异
                      mxAlgebra(X * t(X), name="A"),
                      mxAlgebra(Y * t(Y), name="C"),
                      mxAlgebra(Z * t(Z), name="E"),
                      # 下面定义MZ和DZ分别的协方差矩阵
                      # Matrix expCOVMZ for expected covariance matrix for MZ twins
                      # MZ的协方差矩阵为（A+C+E，A+C
                      #                                   A+C     ，A+C+E）
                      # 表示同卵两个双胞胎之间的相似性，
                      # 对角线表示：T1（2）和T1（2）的协方差，应当是全部协方差；
                      # 副对角线：T1和T2的协方差，表示双生子间基因和环境因素都一样                        
                      mxAlgebra(rbind(cbind(A+C+E, A+C), cbind(A+C, A+C+E)), name="expCovMZ"),
                      mxModel("MZ",
                              mxData(myDataMZ, type="raw"),
                              mxFIMLObjective("twinACE.expCovMZ", "twinACE.expMean",dimnames=colnames(myDataMZ))),
                      # Matrix expCOVDZ for expected covariance matrix for DZ twins
                      # DZ的协方差矩阵为（A+C+E，0.5*A+C
                      #                                   0.5*A+C     ，A+C+E）
                      # 表示同卵两个双胞胎之间的相似性，
                      # 对角线表示：T1（2）和T1（2）的协方差，应当是全部协方差；
                      # 副对角线：T1和T2的协方差，表示双生子间基因和环境因素都一样
                      mxAlgebra(rbind(cbind(A+C+E, .5%x%A+C), cbind(.5%x%A+C , A+C+E)), name="expCovDZ"),  #note use of Kroneker product here!
                      mxModel("DZ",
                              mxData(myDataDZ, type="raw"),
                              mxFIMLObjective("twinACE.expCovDZ", "twinACE.expMean",dimnames=colnames(myDataDZ))),
                      
                      # Algebra to combine objective function of MZ and DZ groups 新模型alltwin为MZ和DZ模型的综合
                      mxAlgebra(MZ.objective + DZ.objective, name="alltwin"),
                      mxAlgebraObjective("alltwin"))
# 进行模型拟合
mytwinACEfit <- mxRun(myACEModel)
#-------------------------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------
#            Saturated_twin_model
#            DVM Bishop, 12th March 2010, based on OpenMxUsersGuide, p. 16
#---------------------------------------------------------------------------------------------
# require(OpenMx)
# mytwindata=read.table("mytwinfile") 
# #read in previously saved data created with Twin Simulate script
# myDataMZ=mytwindata[,1:2]  #columns 1-2 are MZ twin1 and twin2
# myDataDZ=mytwindata[,3:4]  #columns 3-4 are DZ twin 1 and twin 2
# colnames(myDataMZ)=c("twin1","twin2")
# colnames(myDataDZ)=colnames(myDataMZ)
# mylabels=c("twin1","twin2")

# 模型设置Model specification starts here
mytwinSatModel <- mxModel("twinSat", # 饱和模型的配置
                          mxModel("MZ", #构建MZ模型
                                  mxMatrix(type="Full",
                                           nrow=1,
                                           ncol= 2,
                                           free=TRUE,    
                                           values=c(0,0),
                                           name="expMeanMZ"), #模型中的MZ均值期望
                                  mxMatrix("Lower",
                                           nrow= 2,
                                           ncol=2,
                                           free=TRUE,
                                           values=.5,
                                           name="CholMZ"), #模型中的MZ的Cholesky分解
                                  mxAlgebra(CholMZ %*% t(CholMZ), name="expCovMZ"),
                                  mxData(myDataMZ, type="raw"),
                                  mxFIMLObjective("expCovMZ", "expMeanMZ", mylabels)),
                          
                          mxModel("DZ",
                                  mxMatrix(type="Full",
                                           nrow=1,
                                           ncol= 2,
                                           free=TRUE,
                                           values=c(0,0),
                                           name="expMeanDZ"),
                                  mxMatrix(type="Lower",
                                           nrow=2,
                                           ncol=2,
                                           free=TRUE,
                                           values=.5,
                                           name="CholDZ"),
                                  mxAlgebra(CholDZ %*% t(CholDZ), name="expCovDZ"),
                                  mxData(myDataDZ, type="raw"),
                                  mxFIMLObjective("expCovDZ", "expMeanDZ", mylabels)),
                          #以上为最DZ建模
                          mxAlgebra(MZ.objective + DZ.objective, name="twin"),
                          # 将MZ和DZ的似然度相加 
                          mxAlgebraObjective("twin")) 
# 对mxAlgebra的表达进行估计，连个submodel同时进行估计
#---------------------------------------------------------------------------------------------------------------------------
mytwinSatFit <- mxRun(mytwinSatModel) #mxRun指令对模型进行估计
myExpMeanMZ <- mxEval(MZ.expMeanMZ, mytwinSatFit)
#估计完后，可以查看模型中参数的结果
myExpCovMZ <- mxEval(MZ.expCovMZ, mytwinSatFit)
myExpMeanDZ <- mxEval(DZ.expMeanDZ, mytwinSatFit)
myExpCovDZ <- mxEval(DZ.expCovDZ, mytwinSatFit)
LL_Sat <- mxEval(objective, mytwinSatFit)
summary(mxRun(mytwinSatModel))
#--------------------------------------------------------------------------------------------------------------------------
# compute DF for this model - this is a clunky way to do it!
msize=nrow(myDataMZ)*ncol(myDataMZ)
dsize=nrow(myDataDZ)*ncol(myDataDZ)
myDF_Sat=msize+dsize-nrow(mytwinSatFit@output$standardErrors)
#-------------------------------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------------
#                                 ACE_Model_Output
#  DVM Bishop, 13th March 2010, based on OpenMxUserGuide, p. 18
#---------------------------------------------------------------------------------------------------------
# NB assumes you have run Saturated twin model （饱和模型）, and ACE model, 
# and have likelihood and DF from those models in memory
# -2LL for ACE model from previous script
LL_ACE <- mxEval(objective, mytwinACEfit) 

#compute DF: NB only works if no missing data!（计算自由度）
msize=nrow(myDataMZ)*ncol(myDataMZ) #MZ数据行数乘以列数
dsize=nrow(myDataDZ)*ncol(myDataDZ)
myDF_ACE=msize+dsize-nrow(mytwinACEfit@output$standardErrors)
# subtract LL for Saturated model from LL for ACE 
# 计算ACE模型和全模型-2LL的差，即为ACE模型的Chi2值
mychi_ACE= LL_ACE - LL_Sat  
# subtract DF for Saturated model from DF for ACE 
# 计算ACE模型和饱和模型之间自由度之差
mychi_DF=myDF_ACE-myDF_Sat 
# compute chi square probability 
# 计算相应的概率
mychi_p=1-pchisq(mychi_ACE,mychi_DF) 
# Retrieve vectors of expected means and expected covariance matrices
# 拉取平均值和协方差矩阵
myMZc <- mxEval(expCovMZ, mytwinACEfit)
myDZc <- mxEval(expCovDZ, mytwinACEfit)
myM <- mxEval(expMean, mytwinACEfit)
# Retrieve the unstandardized A, C, and E variance components
# 拉取没有标准化的A、C、E方差成分
A <- mxEval(A, mytwinACEfit)
C <- mxEval(C, mytwinACEfit)
E <- mxEval(E, mytwinACEfit)

# Calculate standardized variance components
# 标准化
V <- (A+C+E)   # total variance
a2 <- A/V      # genetic term as proportion of total variance, i.e. standardized
c2 <- C/V      # shared environment term as proportion of total variance
e2 <- E/V      # nonshared environment term as proportion of total variance

# Build and print reporting table with row and column names
# Round is used here simply to keep output to 3 decimal places
# 保留三位小数
myoutput <- rbind(cbind(round(A,3),round(C,3),round(E,3)),cbind(round(a2,3),round(c2,3),round(e2,3)),cbind("chisq","DF","p"),cbind(round(mychi_ACE,3),mychi_DF,round(mychi_p,3)))
myoutput <- data.frame(myoutput, row.names=c("Unstandarized Var Comp","Standardized Var Comp","","Model fit"))
# Writes the output into a data frame which allows row and col labels
names(myoutput)<-c("A", "C", "E")
myoutput 
# Print the table on screen
#---------------------------------------------------------------------------------------------------------------------------