
### DIEBOLD AND YILMAZ (2012)
### BETTER TO GIVE THAN TO RECEIVE: PREDICTIVE DIRECTIONAL MEASUREMENT OF VOLATILITY SPILLOVERS
### JOURNAL OF INTERNATIONAL FORECASTING
### replicated by David Gabauer (https://sites.google.com/view/davidgabauer/contact-details)

gfevd = function(model, n.ahead=10,normalize=TRUE,standardize=TRUE) {
   if (class(model) != "varest") {
      return("The model class is not varest!")
   }
   A <- Phi(model, (n.ahead-1))
   epsilon <- residuals(model)
   Sigma <- t(epsilon)%*%epsilon / (model$obs)
   gi <- array(0, dim(A))
   sigmas <- sqrt(diag(Sigma))
   for (j in 1:dim(A)[3]) {
      gi[,,j] <- t(A[,,j]%*%Sigma%*%solve(diag(sqrt(diag(Sigma)))))
   }
   
   if (standardize==TRUE){
      girf=array(NA, c(dim(gi)[1],dim(gi)[2], (dim(gi)[3])))
      for (i in 1:dim(gi)[3]){
         girf[,,i]=((gi[,,i])%*%solve(diag(diag(gi[,,1]))))
      }
      gi = girf
   }
   
   num <- apply(gi^2,1:2,sum)
   den <- c(apply(num,1,sum))
   fevd <- t(num)/den
   if (normalize==TRUE) {
      fevd=(fevd/apply(fevd, 1, sum))
   } else {
      fevd=(fevd)
   }
   return = list(fevd=fevd, girf=gi)
}
VS = function(CV){
  k = dim(CV)[1]
  SOFM = apply(CV,1:2,mean)*100
  VSI = (sum(rowSums(SOFM-diag(diag(SOFM))))/k)
  INC = colSums(SOFM)
  TO = colSums(SOFM-diag(diag(SOFM)))
  FROM = rowSums(SOFM-diag(diag(SOFM)))
  NET = TO-FROM
  NPSO = t(SOFM)-SOFM
  
  ALL = rbind(rbind(rbind(cbind(SOFM,FROM),c(TO,sum(TO))),c(INC,NA)),c(NET,VSI))
  
  colnames(ALL) = c(rownames(CV),"FROM")
  rownames(ALL) = c(rownames(CV),"Directional TO Others","Directional Inlcuding Own","NET Directional Connectedness")
  ALL = format(round(ALL,2),nsmall=2)
  ALL[nrow(ALL)-1,ncol(ALL)] = "TCI"
  return = list(SOFM=SOFM,VSI=VSI,TO=TO,FROM=FROM,NET=NET,ALL=ALL,NPSO=INC)  
}

path = file.path(file.choose()) # select dy2012.csv
DATA = read.csv(path)
DATE = as.Date(as.character(DATA[,1]))
Y = DATA[,-1]
k = ncol(Y)



### TABLE 1: VOLATILITY SPILLOVER TABLE, FOUR ASSET CLASSES
library("vars")
nlag = 4   # VAR(4)
nfore = 10 # 10-step ahead forecast
var_full = VAR(Y, p=nlag, type="const")
CV_full = gfevd(var_full, n.ahead=nfore)$fevd
rownames(CV_full)=colnames(CV_full)=colnames(Y)
TABLE2 = VS(CV_full)
TABLE2

### STATIC CONNECTEDNESS MEASURES
var_all = VAR(Y, p=nlag, type="const")
CV_ALL = gfevd(var_all, n.ahead=nfore)$fevd
colnames(CV_ALL) = rownames(CV_ALL) = colnames(Y)
vd_all = VS(CV_ALL)
vd_all$ALL

### DYNAMIC CONNECTEDNESS MEASURES
t = nrow(Y)
space = 90 # 200 days rolling window estimation
CV = array(NA, c(k, k, (t-space)))
colnames(CV) = rownames(CV) = colnames(Y)
for (i in 1:dim(CV)[3]) {
   var1 = VAR(Y[i:(space+i-1),], p=nlag, type="const")
   if(any(roots(var1)>1)){ # controls if the VAR process is stationary
      CV[,,i] = CV[,,(i-1)]
   } else {
      CV[,,i] = gfevd(var1, n.ahead=nfore)$fevd
   }
   if (i%%500==0) {print(i)}
}

to = matrix(NA, ncol=k, nrow=(t-space))
from = matrix(NA, ncol=k, nrow=(t-space))
net = matrix(NA, ncol=k, nrow=(t-space))
npso = array(NA,c(k,k,(t-space)))
total = matrix(NA,ncol=1,nrow=(t-space))
for (i in 1:dim(CV)[3]){
  vd = VS(CV[,,i])
  to[i,] = vd$TO/k
  from[i,] = vd$FROM/k
  net[i,] = vd$NET/k
  npso[,,i] = c(t(vd$SOFM)-vd$SOFM)/k
  total[i,] = vd$VSI
}

nps = array(NA,c((t-space),k/2*(k-1)))

colnames(nps) = 1:ncol(nps)
jk = 1
for (i in 1:k) {
  for (j in 1:k) {
    if (j<=i) {
      next
    } else {
      nps[,jk] = npso[i,j,]
      colnames(nps)[jk] = paste0(colnames(Y)[i],"-",colnames(Y)[j])
      jk = jk + 1
    }
  }
}
