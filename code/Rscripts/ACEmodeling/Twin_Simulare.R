#----------------------------------------------------------------------------------------------------------------------
#                                                             Twin simulate
# DVM Bishop, 11th March 2010, Based on script in OpenMXUserGuide, p 15
#----------------------------------------------------------------------------------------------------------------------
require(OpenMx)   # 这个是必须的，加载OpenMx包
#------------------下面是模拟数据需要的
require(MASS)    # needed for multivariate random number generation
set.seed(200)        # specified seed ensures same random number set generated on each run
#-----------设定a、c、e的值
mya2<-0.5 #Additive genetic variance component (a squared)
myc2<-0.3 #Common environment variance component (c squared)
mye2<-1-mya2-myc2 #Specific environment variance component (e squared)
#-----------给定要生成数据的相关系数
my_rMZ <-mya2+myc2          # correlation between MZ twin1 and twin2
my_rDZ <- .5*mya2+myc2     # correlation between DZ twin 1 and twin 2
#-----------利用mvrnorm函数生成数据，MZ、DZ共1000对数据，均值均为0，
#-----------被试之间的协方差矩阵为CovMZ=[1  0.8; 0.8 1];CovDZ=[1  0.55; 0.55 1]
myDataMZ <- mvrnorm (1000, c(0,0), matrix(c(1,my_rMZ,my_rMZ,1),2,2))
myDataDZ <- mvrnorm (1000, c(0,0), matrix(c(1,my_rDZ,my_rDZ,1),2,2))
#-----------给刚刚生成的双生子数据加上标签，并且给出数据的基本统计信息
colnames(myDataMZ) <- c('twin1', 'twin2') # assign column names
colnames(myDataDZ) <- c('twin1', 'twin2')
summary(myDataMZ)
summary(myDataDZ)
colMeans(myDataMZ,na.rm=TRUE)  
#----------na.rm 表示忽略 NA值 (非数值)
colMeans(myDataDZ,na.rm=TRUE)
cov(myDataMZ,use="complete")
#----------"complete" 表示使用所有数据，没有确实值
cov(myDataDZ,use="complete")

#---------- 对 MZ 和 DZ数据画散点图
split.screen(c(1,2))        # split display into two screens side by side
# (use c(2,1) for screens one above the other)
screen(1)
plot(myDataMZ,main='MZ')    # main specifies overall plot title
screen(2)
plot(myDataDZ, main='DZ')
#use drag and drop to resize the plot window if necessary

#----------把所有数据串起来作为最后生成的数据
alltwin=cbind(myDataMZ,myDataDZ)
colnames(alltwin)=c("MZ_twin1","MZ_twin2","DZ_twin1","DZ_twin2")
write.table(alltwin,"mytwinfile")    
# 保存到R当前的路经下 "mytwinfile"
#--------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------
#  MZ submodel
#--------------------------------------------------------------------------------------------
mxModel("MZ",
        #------第一个矩阵：MZ的均值期望
        mxMatrix(
          type="Full",
          nrow=1,
          ncol=2,
          free=TRUE,
          values=c(0,0),
          name="expMeanMZ"),
        #------第二个矩阵：MZ的Cholesky分解
        mxMatrix(
          type="Lower",
          nrow=2,
          ncol=2,
          free=TRUE, 
          values=.5,
          name="CholMZ"),
        #------第三个矩阵：MZ的协方差期望矩阵
        mxAlgebra(
          CholMZ %*% t(CholMZ),
          name="expCovMZ"),
        mxData(
          myDataMZ,
          type="raw"),
        mxFIMLObjective("expCovMZ", "expMeanMZ")) # 拟合函数
#--------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------
#  DZ submodel, illustrating compact formatting
#--------------------------------------------------------------------------------------------
mxModel("DZ",
        mxMatrix("Full", 1, 2, T, c(0,0), name="expMeanDZ"),
        mxMatrix("Lower", 2, 2, T, .5, name="CholDZ"),
        mxAlgebra(CholDZ %*% t(CholDZ), name="expCovDZ"),
        mxData(myDataDZ, type="raw"),
        mxFIMLObjective("expCovDZ", "expMeanDZ", mylabels))
#--------------------------------------------------------------------------------------------
