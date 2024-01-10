# BE statistiques

# SOTORIVA LERMEN Thiago
# 2SN - B2
# Etudiant etranger

# QUESTION 1
data=read.table("Data.txt", header=TRUE)
data$DD <- as.factor(data$DD)
data$RR <- as.factor(data$RR)
summary(data)

# QUESTION 2
print("Modele 1")
lm.out1 <- lm(O3v~O3,data)
summary(lm.out1)

plot(data$O3,data$O3v,xlab="O3 [ug/m3]",ylab="O3v [ug/m3]",pch='+')
abline(lm.out1, col="red")

# en analysant le modele, on observe que la regression lineaire
# passe au centre des valeurs moyennes, mais il y a beaucoup des
# valeus qui passent loin de la droite trasse. On obser que le modele
# avec 1 predicteur O3 a un standard error de 20.71 et son valeur
# R-squared = 0.46. Ça veut dire que on peut bien ameliorer le modele
# car lui n'est pas bien adapte aux donnees d'entree.


# QUESTION 3
print("Analyse d'impact de RR sur O3")
plot(data$O3,data$RR,xlab="O3 [ug/m3]",ylab="RR [Pluie - 1.0/ Sec - 2.0]", main="Impact RR sur O3")
dataPluie <- subset(data, RR=="Pluie")
dataSec <- subset(data, RR=="Sec")
print("RR = Pluie")
summary(dataPluie)
print("RR = Sec")
summary(dataSec)

# Avec ce plot on peut verifier que la concentration de O3 quand
# la variable qualitatif RR est Sec est plus eleve. Quand il y a de pluie
# la concentration de O3 est inferior.
# Avec les donnees qui saffichent avec summary, on bien verifie
# que la moyen de O3 quand RR = Pluie est 70.0 et son valeur maximal
# est 117. Lorsque quand RR = Sec on a que la moyen de O3 est 100.8
# e sa valeur maximale est 166.

print("Modele 2")
lm.out2 <- lm(O3v~O3 + T + N + FF + DD + RR, data)
summary(lm.out2)

# Impact de la variable N sur le predictand:
#   On verifie que la valeur de p-value < 0.05 donc
#   N peut etre considere significatif pour le modele 2.
#   On verifie que l'estimation de N est 2.9771, c'est a dire 
#   que si les autres valeurs des predicteurs sont constantes
#   l'impact de N sur la valeur de O3v (predictand) est 2.9771

# Resultats relatifs a DD
#   DD est une variavle qualitatif divisee en NOrd, OUest, SUd et Est,
#   le logiciel R utilise la contrainte DDEst = 0 et cree de nouveles
#   variables qualitatifs a partir de ce conrainte pour etre possible
#   d'etre numerique. On verifie que la p-value de la direction des 
#   vents dans le modele (DDNOrd, DDOuest, DDSud) sont toutes superior 
#   a 0.05, c'est a dire que la variable qualitatif DD peut etre
#   consideree non significatif pour l'estimation du predictand, donc
#   le modele peut etre encore ameliore.

# Les hypotheses du cadre theorique du modele lineaire gaussien sont-elles respectes?
plot(fitted(lm.out2),residuals(lm.out2),main="Hypothèse Homoscedasticite",xlab="Valeurs ajustees (Y*)",ylab="Residus")
# Pour l'hypothese d'homoscedasticie on observe que les valeurs sont pas bien regoupees autour des memes droites
# et sont disperses (format de cone verifie). Donc l'hypothese de variance constante
# n'est pas bien verifie. Donc, on peut realiser des changements sur le modele.
qqnorm(residuals(lm.out2))
# Ici, on bien verifie un plot dune graphique presque lineaire avec des valeurs qui
# sont regroupees dans lintervale [-2, 2]. Les distribuitions donc sont proches de normales,
# donc on peut verifier l'hypothese de normalite
acf(residuals(lm.out2))
# On cherche la correlation entres les variables, donc on verifie que il y a des valeeurs]
# qui depassent la ligne des 0.05. Donc, on peut considerer que les variables sont independentes les unes des autres
# ce qui valide l'hypothese d'independance.
plot(fitted(lm.out2),data$quality,xlab="Valeur Prévues",ylab="Valeur Observées",pch="+",main="Hypothese de linearite")
# Ici on verifie que les valeurssont dispersees au centre et on a donc peu de linearite

# 
# Predicteurs a conserver
#   Pour la decision je considerais la valeur de p-value de chaque predicteur.
#   Donc, les predicteur que je conserverais serais O3, T et N. Les autres
#   prediceur ont leur valeurs de p-values > 0.05 donc non significatifs pour le modele

#################################
# IMPORTANT!!!!!!!!!!
# A PARTIR DE INI JE CONSIDERE "LE MODELE PRECENDENTE" LE MODELE lm.out2 en enlevent les
# predicteurs avec des p-values > 0.05
# DONC LE MODELE PRECEDENTE EST: O3v ~ O3 + T + N
#################################

print("Modele BIC")
library(MASS)

# ?stepAIC
# lm.outAIC=stepAIC(lm.out2) #par defaut selection descendante effectuee par la fct stepAIC
lm.outBIC=stepAIC(lm.out2,k=log(nrow(data)))
summary(lm.outBIC)
formula(lm.outBIC)

# Le modele BIC a fait la selection automatique de predicteurs.
# Dans ce cas, on a selectione automatiquement les variables
# O3, T et N qui sont exactement les variables qui ont son
# p-value < 0.05. O verifie aussi que le modele a un standard error = 19.63
# et sa valeur R-squared = 0.53.

# QUESTION 4
print("Modele BIC INT")
regint=lm(O3v~.*.,data)
lm.outBICint=stepAIC(regint,k=log(nrow(data)))
formula(lm.outBICint)
summary(lm.outBICint)

# Le modele BIC Int d'ordre 2 a selectionee automatiquement
# les variables suivantes: O3, T, N (memes q'on a choisit avant),
# FF, O3*T et T*FF. On verifie que on a ajoute 3 nouvelles predicteurs
# en comparant avec le modele q'on a choisi les predicteurs manuellement
# ces predicteur sont FF, O3*T et T*FF. On verifie aussi que 
# le standard error est 18.22 et la valeur de R-squared est 0.60
# Du coup on verifie une amelioration dans le modele.

# QUESTION 5
plot(data$O3v,type ="l",main="Concentration d'ozone maximale",xlab="Indice",ylab="[O3v]")
points(fitted(lm.out1),col="red",pch="+",cex=1.2)
points(fitted(lm.outBICint),col="blue",pch="+",cex=1.2)
legend(0,330,lty=1,col=c("black"),legend=c("observé"),bty="n")
legend(0,320,pch="+",col=c("blue","red","green"),legend=c("       prevu","       RegSimple","       RegBICint"),bty="n") 

# On verifie que le modele lm.outBICint en bleu ameliore la regression 
# simple en rouge en permettant une plus grande variabilite aux previsions
# statistiques (modele plus flexible). 

# QUESTION 6
# Calcul des scores :

# fonction calculant le biais et le RMSE
score=function(obs,prev) {
    rmse=sqrt(mean((prev-obs)**2))
    biais=mean(prev-obs)
    print("Biais  RMSE") 
    return(round(c(biais,rmse),3))
}

# création de data de test et d'apprentissage
nappr=ceiling(0.8*nrow(data))
ii=sample(1:nrow(data),nappr)
jj=setdiff(1:nrow(data),ii)
datatest=data[jj,]
datapp=data[ii,]

# transformation des modèles sur les données d'apprentissage
lm.out1=lm(formula(lm.out1),datapp)
lm.out2=lm(formula(lm.out2),datapp)
lm.outBICint=lm(formula(lm.outBICint),datapp)

print("Aprentissage")
score(datapp$O3v,fitted(lm.out1))
# [1] "Biais  RMSE"
# [1]  0.000 20.018
score(datapp$O3v,fitted(lm.out2))
# [1] "Biais  RMSE"
# [1]  0.000 18.291
score(datapp$O3v,fitted(lm.outBICint))
# [1] "Biais  RMSE"
# [1]  0.000 17.444

print("Test")
score(datatest$O3v,fitted(lm.out1))
# [1] "Biais  RMSE"
# [1] -7.544 33.900
score(datatest$O3v,fitted(lm.out2))
# [1] "Biais  RMSE"
# [1] -7.544 34.582
score(datatest$O3v,fitted(lm.outBICint))
# [1] "Biais  RMSE"
# [1] -7.544 35.573


# On observe que pour tous les scores sur les fichiers d'apprentissage les modèles sont non biaisées,
# et le modele avec le RMSE le plus bas est lm.outBICint avec RMSE = 17.444
# Par contre, pour les donnees de test le modele le plus generalisant est
# le modele lm.out1 avec RMSE = 33.900. Tous les modeles dans l'etape de test
# sont biaisesavec un biais = -7.54.

RMSE=function(obs,pr){
return(sqrt(mean((pr-obs)^2)))}

k=100 # nb iterations
tab=matrix(nrow=k,ncol=6)
for (i in 1:k) {

    nappr=ceiling(0.8*nrow(data))
    ii=sample(1:nrow(data),nappr)
    jj=setdiff(1:nrow(data),ii)
    datatest=data[jj,]
    datapp=data[ii,]

    # Estimation des modeles
    lm.out1=lm(formula(lm.out1),datapp)
    lm.out2=lm(formula(lm.out2),datapp)
    lm.outBICint=lm(formula(lm.outBICint),datapp)

    # Scores sur apprentissage
    tab[i,1]=RMSE(datapp$O3v,predict(lm.out1))
    tab[i,2]=RMSE(datapp$O3v,predict(lm.out2))
    tab[i,3]=RMSE(datapp$O3v,predict(lm.outBICint))

    # Scores sur test
    tab[i,4]=RMSE(datatest$O3v,predict(lm.out1))
    tab[i,5]=RMSE(datatest$O3v,predict(lm.out2))
    tab[i,6]=RMSE(datatest$O3v,predict(lm.outBICint))

}

boxplot(tab,col=c(rep("blue",3),rep("red",3)),xlab="bleu=apprentissage - rouge=test", names=c("lm.out1","lm.out2", "lm.outBICint","lm.out1","lm.out2", "lm.outBICint"),main=("Modele lineaire gaussien - Score RMSE"))

# Avec lstrategie de persistence on constate que le modele outBICint pour
# aprentissage est le plus perfomant, mais ne generalise pas les donnes
# pendant l'etape de test a cause de sa complexite. On aussi verifie que le
# modele le plus performant pendant l'etape de test est out1, le modele
# de regression simple le moins complexe.
# Donc le modele choisit serait le modele avec le RMSE le plus bas pendant l'etape de test
# dans le strategie de persistence, donc lm.out1

print("Pour journees seches")
# lm.out1Sec <- lm(O3v~O3,dataSec)
# lm.out2Sec <- lm(O3v~O3 + T + N + FF + DD, dataSec)
# regintSec=lm(O3v~.*.,dataSec)
# lm.outBICintSec=stepAIC(regintSec,k=log(nrow(dataSec)))

# k=100 # nb iterations
# tab=matrix(nrow=k,ncol=6)
# for (i in 1:k) {

#     nappr=ceiling(0.8*nrow(dataSec))
#     ii=sample(1:nrow(dataSec),nappr)
#     jj=setdiff(1:nrow(dataSec),ii)
#     datatest=dataSec[jj,]
#     datapp=dataSec[ii,]

#     # Estimation des modeles
#     lm.out1Sec=lm(formula(lm.out1Sec),datapp)
#     lm.out2Sec=lm(formula(lm.out2Sec),datapp)
#     lm.outBICintSec=lm(formula(lm.outBICintSec),datapp)

#     # Scores sur apprentissage
#     tab[i,1]=RMSE(datapp$O3v,predict(lm.out1Sec))
#     tab[i,2]=RMSE(datapp$O3v,predict(lm.out2Sec))
#     tab[i,3]=RMSE(datapp$O3v,predict(lm.outBICintSec))

#     # Scores sur test
#     tab[i,4]=RMSE(datatest$O3v,predict(lm.out1Sec))
#     tab[i,5]=RMSE(datatest$O3v,predict(lm.out2Sec))
#     tab[i,6]=RMSE(datatest$O3v,predict(lm.outBICintSec))

# }

# boxplot(tab,col=c(rep("blue",3),rep("red",3)),xlab="bleu=apprentissage - rouge=test", names=c("lm.out1","lm.out2", "lm.outBICint","lm.out1","lm.out2", "lm.outBICint"),main=("Modele lineaire gaussien (Jounees seches) - Score RMSE"))

# # print("Pour journees pluvieuses:")
# # k=100 # nb iterations
# # tab=matrix(nrow=k,ncol=6)
# # for (i in 1:k) {

# #     nappr=ceiling(0.8*nrow(dataPluie))
# #     ii=sample(1:nrow(dataPluie),nappr)
# #     jj=setdiff(1:nrow(dataPluie),ii)
# #     datatest=dataPluie[jj,]
# #     datapp=dataPluie[ii,]

# #     # Estimation des modeles
# #     lm.out1=lm(formula(lm.out1),datapp)
# #     lm.out2=lm(formula(lm.out2),datapp)
# #     lm.outBICint=lm(formula(lm.outBICint),datapp)

# #     # Scores sur apprentissage
# #     tab[i,1]=RMSE(datapp$O3v,predict(lm.out1))
# #     tab[i,2]=RMSE(datapp$O3v,predict(lm.out2))
# #     tab[i,3]=RMSE(datapp$O3v,predict(lm.outBICint))

# #     # Scores sur test
# #     tab[i,4]=RMSE(datatest$O3v,predict(lm.out1))
# #     tab[i,5]=RMSE(datatest$O3v,predict(lm.out2))
# #     tab[i,6]=RMSE(datatest$O3v,predict(lm.outBICint))

# # }

# # boxplot(tab,col=c(rep("blue",3),rep("red",3)),xlab="bleu=apprentissage - rouge=test", names=c("lm.out1","lm.out2", "lm.outBICint","lm.out1","lm.out2", "lm.outBICint"),main=("Modele lineaire gaussien (Jounees pluvieuses) - Score RMSE"))
