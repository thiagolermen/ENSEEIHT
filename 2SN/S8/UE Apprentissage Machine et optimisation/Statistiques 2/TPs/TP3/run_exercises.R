# TP2 - Modele linaire gaussien

# Phase préliminaire
# Question 1
data=read.table(file="DataTP.txt",header=TRUE)
library(MASS) ; library(verification)

# Question 2
data$OCC=as.factor(as.numeric(data$O3o>180))
data$OCCp=as.factor(as.numeric(data$O3p>180))
summary(data)

# Question 3
source("scores.R")

#Regression logistique
# Question 1
print("Estimating the linear model ...")
glm.out=glm(OCC~.,data[,-2],family=binomial) # select all columns but column 2
summary(glm.out)

# Question 2
print("Selecting predictors based on the BIC score ...")
glm.outBIC=stepAIC(glm.out,k=log(nrow(data)))
summary(glm.outBIC)

# Question 3
print("Evaluating post-traited predictions ...")
scores(data$OCCp, data$OCC)
print("Evaluating linear regression predictions ...")
scores(predict(glm.outBIC,type="response") > 0.5, data$OCC)

# Question 4
print("Generating ROC curve and optimizing le predictor ...")
roc.plot(as.numeric(data$OCC) - 1, predict(glm.outBIC, type = "response"))
scores(predict(glm.outBIC,type="response") > 0.1, data$OCC)

# Question 5
print("Generating Gaussian model and evaluating it ...")
lm.out=lm(O3o~.,data[,-9])
scores(predict(lm.out)>180, data$OCC)