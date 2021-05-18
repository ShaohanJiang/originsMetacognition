#---------------------------------------------------------------------------------------------------------
#                                                  ACE Model
#   DVM Bishop 13th March 2010; based on p 18, OpenMx manual
#---------------------------------------------------------------------------------------------------------
mytwindata=read.table("mytwinfile")
#read in previously saved data created with Twin Simulate script
myDataMZ=mytwindata[,1:2]  #columns 1-2 are MZ twin1 and twin2
myDataDZ=mytwindata[,3:4]  #columns 3-4 are DZ twin 1 and twin 2
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
                               values=.6, #starting values （这是什么值的初始？）
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
                      # A=X2 路径系数平方反应变异
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