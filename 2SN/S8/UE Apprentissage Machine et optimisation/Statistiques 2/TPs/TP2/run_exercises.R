# Script TP2 HPC-BigData - Modele linaire gaussien

rm(list=ls())

######################
# Partie 1 :
######################

# 1 - Chargement librairies et donnees

data=read.table(file="DataTP.txt",header=TRUE)

names(data)
summary(data)
dim(data)
#Assurez-vous que R considere bien par defaut les variables JJ et STATION comme etant de type factor 
#(effectifs par modalite affiches dans le summary), sinon forcez le type comme ceci : 
data$JJ=as.factor(data$JJ)
data$STATION=as.factor(data$STATION)

# 2 - Etude preliminaire et regression simple

aix=subset(data,STATION=="Aix")
summary(aix)
sd(aix$O3o) # standard deviation
sd(aix$O3p)

par(mfrow=c(1,2))
hist(aix$O3o,breaks=seq(0,300,30),ylim=c(0,100))
hist(aix$O3p,breaks=seq(0,300,30),ylim=c(0,100))
# on impose ici les memes classes pour pouvoir comparer les histogrammes

#x11()
boxplot(aix$O3o,aix$O3p,names=c("[O3]obs","[O3]prevu"))
# Les previsions semblent surestimer globalement les mesures

var.test(aix$O3o,aix$O3p)
# -> les variances peuvent etre considerees comme egales
t.test(aix$O3o,aix$O3p,var.equal=T) # se as variancias nao sai iguais, coloca var.equal = F
# -> les moyennes sont significativement differentes : les previsions 03p sont biaisees (biais positif)

cor(aix$O3o,aix$O3p)
cor.test(aix$O3o,aix$O3p)
#liaison linéaire significative detectee

plot(aix$O3p,aix$O3o)
regsimple=lm(O3o~O3p,data=aix)
summary(regsimple)
# -> les 2 parametres du modele sont juges significativement differents de 0
# -> la regression simple n'explique que 22% (R-squared has to be close to 1 but its not the case) de la variance totale du predictand
# en considerant d'autres predicteurs, le modele statistique peut certainement etre ameliore

#x11()
plot(aix$O3p,aix$O3o,xlab="O3 PREVU MOCAGE",ylab="O3 OBSERVE",
     main="PREVISIONS 24H",pch='+')
abline(regsimple,col="red")

#x11()
plot(aix$O3o,type ="l",lwd=2,main="Concentration d'ozone à Aix",xlab="Date",ylab="[O3]")
points(aix$O3p,col="blue",pch="+")
points(fitted(regsimple),col="red",pch="+")
legend(0,268,lty=1,col=c("black"),legend=c("observée"),bty="n")
legend(0,256,pch="+",col=c("blue","red"),legend=c("       prevue","       ASsimple"),bty="n") 
# -> le traitement statistique tire les previsions brutes vers la moyenne du predictand mais est incapable d'atteindre les valeurs extremes
# la variabilité du predictand est mal reproduite, il faut enrichir la regression pour obtenir une flexibilite plus forte du modele.


# 3 - Regression multiple : predicteurs continus


#x11()
par(mfrow=c(3,2))
hist(data$O3p)
hist(data$TEMPE)
hist(data$FF)
hist(data$RMH2O)
hist(data$NO2)
hist(log(data$NO2))
cor(data$O3o,data$NO2)
cor(data$O3o,log(data$NO2))
cor.test(data$O3o,log(data$NO2))
# -> la distribution de NO2 est tres dissymetrique, l'emploi de la fonction log permet d'obtenir un profil mieux correle au predictand.
# -> on utilisera donc plutot la variable log(NO2) comme prédicteur par la suite.

#x11()
pairs(data[,c(-1,-7)])
# -> on cherche à reperer sur cette matrice graphique d'une part les pb de colinearite entre predicteurs et d'autre part les fortes correlations entre 
# les differents predicteurs et le predictand O3o
# -> pas de pb de colinearite trop marquee entre predicteurs ici, les variables les mieux correlees avec O3o semblent etre O3p et TEMPE qui constitueront 
# les meilleurs predicteurs

regmult=lm(O3o~O3p+TEMPE+RMH2O+log(NO2)+FF,data)
summary(regmult)
# -> l'analyse des tests de Student montre que l'influence de NO2 n'est pas significative
# le % de variance expliquee passe à 51%, ce qui n'est pas formidable
model.matrix(regmult)[1:10,]

plot(fitted(regmult),residuals(regmult),main="Hypothèse d'homoscédasticité",xlab="Valeurs ajustées (Y*)",ylab="Résidus")
# -> heteroscedasticite : la variabilite de l'erreur n'est pas stable, une structure en cone apparait, hypothese d'homoscedasticite non verifiee

qqnorm(residuals(regmult))
hist(residuals(regmult))
# residus centres par construction sur apprentissage,
# les queues de distribution s'eloignent de la normalite, mais globalement l'hypothèse de normalite ne pose pas probleme sur une large plage

acf(residuals(regmult))
# -> autocorrelation marquee pendant une bonne semaine, moins nette ensuite, hypothèse d'independance non respectee

plot(fitted(regmult),data$O3o,xlab="[03] PREVUE par AS",ylab="[03] OBSERVEE",pch="+",main="Hypothèse de linéarité")
# -> on decele une legere courbure dans le nuage, l'hypothese de linearite n'est pas completement adaptee

# # Les hypotheses non respectees par les donnees expliquent les performances decevantes de la regression lineaire ici

# # Au final, les predicteurs a conserver seraient a ce stade : O3p, TEMPE, RMH2O et FF (car p_val<0.05)



######################
# Partie 2 :
######################

# 4 - Analyse de variance (ANOVA) : predicteurs qualitatifs

anova1=lm(O3o~JJ,data)
summary(anova1)
model.matrix(anova1)[1:10,]
# Par defaut, R pose comme contrainte d'identification alpha(F)=0. La modalite F du facteur JJ est donc ici prise comme reference.
# Le terme constant du modele englobe donc ici l'effet moyen de la modalite F. L'estimation du parametre alpha(S) relatif à la modalite S du facteur JJ
# R estime l'effet différentiel de la modalité S par rapport à la modalité F (0.4716).
# Ce terme est juge non significatif par le test de Student et donc le predicteur JJ est ici juge sans interet.

anova2=lm(O3o~C(JJ,sum),data)
summary(anova2)
model.matrix(anova2)[1:10,]
# avec la contrainte 'somme des alpha = 0', le modele global ne change en rien : ce sont les parametres estimes et leur interpretation qui different.
# On conclut toujours que le predicteur JJ n'est pas influent et les p-values des tests sont rigoureusement les memes avec les 2 contraintes, tout comme les R2 et les valeurs ajustees.
# Le modele statistique n'a pas change en modifiant la contrainte et fera exactement les memes previsions.


# 5 - Analyse de covariance (ANCOVA) : predicteurs quantitatifs et qualitatifs, selection automatique

# Modele complet

regcomplet=lm(O3o~O3p+TEMPE+RMH2O+log(NO2)+FF+STATION+JJ,data)

# On ajoute le facteur STATION a 5 modalites. On cherche donc ici à estimer un seul modele statistique capable d'adapter sa prevision selon au site considere.

summary(regcomplet)
# Deux contraintes ont ici ete imposees puisqu'il y a 2 facteurs. Au vu des sorties R, le logiciel a pris comme references la modalite F de JJ et la modalite Aix de STATION. 
# L'analyse des tests de Student confirme que le facteur JJ n'est pas significativement influent, par contre certaines modalites du facteur STATION menent a des effets differentiels juges significatifs.
# O3o se comporte differemment aux stations Pla et Cad par rapport à Aix alors que Als et Ram ont des comportements moyens très proches d'Aix. 
# Il faut donc conserver le predicteur STATION qui enrichit notre modele, lui permettant une adaptation plus fine sur certaines stations.
# On remarque que la variable FF semble plus influente qu'à la question 2, de meme pour NO2. FF et NO2 doivent donc avoir un impact significatif sur O3o sur certains sites seulement.
# Manuellement, seule la variable JJ serait a retirer car jugee inutile.


# Selection automatique des predicteurs

library(MASS)

# La minimisation des indices AIC et BIC permattent d'obtenir, des la phase d'apprentissage, des modeles evitant le sur-apprentissage.

# ?stepAIC
regaic=stepAIC(regcomplet) #par defaut selection descendante effectuee par la fct stepAIC
summary(regaic)
formula(regaic)
# la sélection automatique descendante utilisant le critere AIC ne retire que le facteur JJ, comme la selection manuelle precedente.

regbic=stepAIC(regcomplet,k=log(nrow(data)))
summary(regbic)
formula(regbic)
# la selection automatique descendante utilisant le critere BIC retire le facteur JJ et les variables RMH2O et NO2.
# la penalisation de la complexite du modele est plus severe avec l'indice BIC et mène en general à des modeles plus parcimonieux (moins de predicteurs selectionnes qu'avec le critere AIC)
# Le % de variance expliquee passe à 52%

#L'interet de tels algorithmes intervient en cas de modele complet plus complexe, par exemple si on cherche a tester toutes les interactions d'ordre 2 possibles
# l'algorithme permet d'effectuer un premier tri, essayez :
regint=lm(O3o~.*.,data)
summary(regint)
regbicint=stepAIC(regint,k=log(nrow(data)))
formula(regbicint)



# 6 - Evaluation des modeles

plot(data$O3o,type ="l",main="Concentration d'ozone",xlab="Indice",ylab="[O3]")
points(data$O3p,col="blue",pch="+",cex=1.2)
regsimple=lm(O3o~O3p,data)
points(fitted(regbicint),col="green",pch="+",cex=1.2)
points(fitted(regsimple),col="red",pch="+",cex=1.2)
legend(0,330,lty=1,col=c("black"),legend=c("observé"),bty="n")
legend(0,320,pch="+",col=c("blue","red","green"),legend=c("       prevu","       regsimple","       regbicint"),bty="n") 
# On voit que le modele regbicint en vert ameliore la regression simple en rouge en permettant une plus grande variabilite aux previsions statistiques (modele plus flexible)

# Calcul des scores :

# fonction calculant le biais et le RMSE
score=function(obs,prev) {
rmse=sqrt(mean((prev-obs)**2))
biais=mean(prev-obs)
print("Biais  RMSE") 
return(round(c(biais,rmse),3))
}

score(data$O3o,data$O3p)
# biais=11.82 RMSE=38.34
# -> la prevision brute est biaisee
score(data$O3o,fitted(regsimple))
# biais=0 RMSE=33.01
# -> la regression simple debiaise la prevision brute et reduit la variabilite de l'erreur
score(data$O3o,fitted(regbic))
# biais=0 RMSE=28.24
# -> la regression BIC reduit encore la variabilite de l'erreur
score(data$O3o,fitted(regbicint))
# -> la regression BICint reduit encore la variabilite de l'erreur, le modele le plus complexe etant sans surprise le plus performant sur les donnees d'apprentissage

# Mais les ecarts constates sont-ils signigicatifs ? Rien ne permet de l'affirmer a ce stade.
# De plus quel serait le comportement de ces modeles en conditions operationnelles, sur de nouvelles donnees ?

# Ces scores ont ete calcules sur fichier d'apprentissage, c'est à dire sur les donnees qui ont servi à l'estimation du modele statistique.
# Il faut pour valider le modele le tester sur de nouvelles donnees (non utilisees pour estimer les parametres du modele) pour verifier que les scores ne se degradent pas trop. 
# Les scores sur fichier test servent à apprecier la robustesse du modele (= capacite à s'adapter à de nouvelles donnees).
# Si le modele est de trop grande dimension, les scores seront bons voire excellents sur apprentissage mais mauvais sur test : 
# le modele sera trop adapte à l'echantillon d'apprentissage et incapable de s'en detacher (=sur-apprentissage, incpacite a generaliser). 

# Creation des fichiers d'apprentissage et de test
nappr=ceiling(0.8*nrow(data))
ii=sample(1:nrow(data),nappr)
jj=setdiff(1:nrow(data),ii)
datatest=data[jj,]
datapp=data[ii,]

# Entrainement des modeles sur le fichier datapp
regsimple=lm(O3o~O3p,datapp)
regaic=lm(formula(regaic),datapp)
regbic=lm(formula(regbic),datapp)
regbicint=lm(formula(regbicint),datapp)
regsurapp=lm(O3o~.*.*.,datapp) # modele volontairement tres complexe, interactions d'ordre 3 (complexite=length(regsurapp$coefficients)

score(datapp$O3o,datapp$O3p) # scores bruts de MOCAGE
score(datapp$O3o,fitted(regsimple))
score(datapp$O3o,fitted(regbic))
score(datapp$O3o,fitted(regbicint))
score(datapp$O3o,fitted(regsurapp))
# Sans surprise plus le modele est complexe, plus il est performant sur les donnees d'apprentissage,
# le biais est nul par construction.


score(datatest$O3o,datatest$O3p)
score(datatest$O3o,predict(regsimple,datatest))
score(datatest$O3o,predict(regbic,datatest))
score(datatest$O3o,predict(regbicint,datatest))
score(datatest$O3o,predict(regsurapp,datatest))
# Les scores se degradent sur test, des biais apparaissent, le modele le plus complexe etant le moins robuste.

# Pour avoir acces a la variabilite des estimateurs de scores (= sensibilite de l'estimateur a l'echantillonnage)
# on peut pratiquer de la validation croisee en tirant plusieurs fois de facon aleatoire des sous-echantillons d'apprentissage et test, permettant d'acceder au final a plusieurs
# estimations des scores et de comparer des boites a moustaches de scores (les ecarts etant juges significatifs si les boites n'ont pas de zones communes) :
source("CV.R") 
# Sur le graphe genere, scores RMSE sur fichier d'apprentissage en bleu puis sur fichier test en rouge, le modele complexe avec interactions est clairement sur-apprenti, 
# les modeles simple, bic et bicint sont robustes, le bicint etant significativement le meilleur sur test c'est le modele a proposer au final.

#Remarque : Principe de parcimonie
# Si plusieurs modeles menaient a des performances proches (ecart non significatif, aucun modele ne se distingue), 
# il faudrait alors proposer le modele de plus faible complexite, c'est un gage de robustesse

