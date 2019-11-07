
path = file.path(file.choose()) # select dy2012.csv
DATA = read.csv(path)
DATE = as.Date(as.character(DATA[,1]))
Y = DATA[,-1]
k = ncol(Y)
### TABLE 1: LOG VOLATILITY SUMMARY STATISTICS, FOUR ASSET CLASSES
library("moments")
TABLE1 = rbind(apply(Y,2,mean),
                apply(Y,2,median),
                apply(Y,2,max),
                apply(Y,2,min),
                apply(Y,2,sd),
                apply(Y,2,skewness),
                apply(Y,2,kurtosis))
rownames(TABLE1) = c("Mean","Median","Maximum","Minimum","Std.Deviation","Skewness","Kurtosis")

round(TABLE1,2)
cat(TABLE1,file='C:/Users/JianLei/Desktop/CryptocurrencyMarket/Datas/Row_Data/Test.txt',append=T)

print(TABLE1)