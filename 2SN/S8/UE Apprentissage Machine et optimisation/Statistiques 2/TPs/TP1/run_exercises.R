# EXERCISE 1
print("EXERCISE 1")
years=1500:2023                             
bis=((years%%4==0) & (years%%100!=0)) | (years%%400==0)
i=which(bis==TRUE)
years[i]

#EXERCISE 2
print("EXERCISE 2")
A=matrix(runif(12000),nrow=12) 
hist(A) 
meanA=apply(A,2,mean) 
hist(meanA) 
print("Saving pdf...")

#EXERCISE 3
print("EXERCISE 3")
data(iris)
summary(iris)
iris2=iris[iris$Species=="versicolor",]
print("Decreasing order: ")
iris2[order(iris2$Sepal.Length,decreasing=TRUE),]

#EXERCISE 4
print("EXERCISE 4")
ozone = read.table("ozone.txt", header=TRUE)
summary(ozone)
ozone[(ozone$T15 > 30.0),]$maxO3
data2 = ozone[ozone$pluie == 'Sec',]
print("Decreasing order: ")
data2[order(data2$T12,decreasing=TRUE),]
print("Generating historgram and boxplot... ")
hist(data2$Ne9)
boxplot(data2$Ne9)
print("Generating quantile... ")
quantile(data2$maxO3)

#EXERCISE 5
print("EXERCISE 5")
# 1
CLIM = read.table("CLIM.txt", header=TRUE, sep = ';')
summary(CLIM)

# 2
years = substr(CLIM$DATE,1,4)
months = substr(CLIM$DATE,5,6)
CLIM$AN <- years
CLIM$MOIS <- months

# 3
toul = CLIM[CLIM$POSTE =='31069001',]
agen = subset(CLIM, subset=CLIM$POSTE == '47091001') 

# 4
toul[which.max(as.numeric(toul$TX)),c("DATE","TX")]
agen[which.max(as.numeric(agen$TX)),c("DATE","TX")]

#5
par(mfrow=c(1,2))
hist(as.numeric(toul$TX)) ; hist(as.numeric(agen$TX)) 
amp = seq(-9,41,2)
hist(as.numeric(toul$TX),main="Toulouse",xlab="TX",ylab="Real", breaks=amp, col="red")  ; hist(as.numeric(agen$TX),main="Agen",xlab="TX",ylab="Real", breaks=amp, col="blue")

#6
matrice=function(nom,num) {
n=max(nom$AN)-min(nom$AN)+1
tab=matrix(nrow=n,ncol=13)
for(i in 1:n) {
yy=min(nom$AN)+i-1
	for(j in 1:12) {
	tab[i,j]=mean(nom[(nom$AN==yy)&(nom$MOIS==j),num])
	}
tab[i,13]=mean(nom[nom$AN==yy,num])
}
return(tab)
}

#7
toulTX=as.numeric(matrice(toul,5))
max(toulTX[,-13]) #31.09677
max(toulTX[,13]) #19.69178

agenTX=as.numeric(matrice(agen,5))
max(agenTX[,-13]) #30.66452
max(agenTX[,13]) #19.66082

#8
boxplot(toulTX[,13],agenTX[,13],names=c("Toulouse","Agen"),main="Moyenne annuelle TX")