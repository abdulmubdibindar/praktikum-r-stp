##BASIC QUANTITATIVE RESEARCH METHODS FOR URBAN PLANNERS##
##R script##

##CHAPTER 7: DESCRIPTIVE STATISTICS AND VISUALIZING DATA##
library("foreign")
hts<-read.spss("HTS.household.10regions.sav",to.data.frame=TRUE)

#frequency table
table<-table(hts$hhsize)
table
prop.table(table)
ftable<-cbind(table,prop.table(table))
colnames(ftable)<-c("count","percentage")
ftable

#central tendency and dispersion
summary(hts$hhsize)
sd(hts$hhsize)
var(hts$hhsize)

#cross tabulation
xtab<-xtabs(~income_cat+anyvmt,data=hts)
xtab
addmargins(prop.table(xtab,1),2)

#informative graphs
hist(hts$hhsize,freq=FALSE)
lines(density(hts$hhsize,adjust=5), col="blue", lty="dotted", lwd=1) #add density line


##CHAPTER 8: CHI-SQUARE##
library("foreign")
hts<-read.spss("HTS.household.10regions.sav",to.data.frame=TRUE)

table<-table(hts$sf,hts$anywalk)
table
addmargins(prop.table(table,1),2)
chisq.test(hts$sf,hts$anywalk) #chi-square test

library(vcd)
assocstats(table) #symmetric measures for the chi-square test


##CHAPTER 9: CORRELATION##
library("foreign")
uza<-read.spss("UZA.sav",to.data.frame=TRUE)

cor(uza$lnlm,uza$lnvmt) #Pearson correlation coefficient
cor.test(uza$lnlm,uza$lnvmt) #Pearson correlation coefficient and p-value

library(ggm)
names(uza)
uza_par<-uza[,c("lnlm","lnvmt","lnfuel")]
pcor<-pcor(c(1,2,3),cov(uza_par)) #partial correlation coefficient
pcor
pcor.test(pcor,1,157)

cor.test(uza$vmt,uza$pop000,method="spearman") #Spearman correlation coefficient

#ICC
library(irr)
icc(cbind(uza$popden, uza$urbden),model="twoway") #Intraclass correlation coefficient

library(psych)
alpha(cbind(uza$popden, uza$urbden))$total$std.alpha #Cronbach's Alpha


##CHAPTER 10: DIFFERENCE OF MEANS TESTS (T-TESTS)##
library("foreign")
hts<-read.spss("HTS.household.10regions.sav",to.data.frame=TRUE)
hts_two<-hts[which(hts$region=="Seattle, WA"|hts$region=="Kansas City, MO"),]
hist(hts_two$lnvmt[which(hts_two$region=="Seattle, WA")])
hist(hts_two$lnvmt[which(hts_two$region=="Kansas City, MO")])

t.test(hts_two$lnvmt~hts_two$region)
t.test(hts_two$lnvmt~hts_two$region,alternative="greater")


##CHAPTER 11: ANALYSIS OF VARIANCE (ANOVA)##
library("foreign")
uza<-read.spss("UZA.sav",to.data.frame=TRUE)

boxplot<-boxplot(uza$lntpm~uza$region,main="UZA data",xlab="Region",ylab="Transit passenger miles (log)")

outliers = boxplot$out
uza[uza$lntpm %in% outliers,c(1,2)]
uza2<-uza[-c(28,84,88),]

hist(uza2$lntpm)

fit<-aov(uza2$lntpm~uza2$region)
summary(fit)
bartlett.test(lntpm ~ region, data=uza2)
TukeyHSD(fit)
plot(TukeyHSD(fit))


##CHAPTER 12: LINEAR REGRESSION##
library("foreign")
uza<-read.spss("UZA.sav",to.data.frame=TRUE)

plot(uza$vmt~uza$lm)

lm1<-lm(lnvmt~lnlm+lnpop000+lntpm+lnfuel+lninc000+lncompact,data=uza)
summary(lm1)

library(lmtest)
dwtest(lm1)

hist(lm1$residuals,freq=F)
lines(density(lm1$residuals,adjust=2))
plot(lm1$residuals~lm1$fitted.values)


##CHAPTER 13: LOGISTIC REGRESSION##
library("foreign")
hts<-read.spss("HTS.household.10regions.sav",to.data.frame=TRUE)

glm1<-glm(anyvmt~hhsize+hhworker+lnhhincome+entropy+stopden+pct4way,data=hts,family=binomial())
summary(glm1)

library(mlogit)
hts2<-subset(hts,htype!="other");hts2$htype<-factor(hts2$htype)
mlogit1 <- mlogit(htype ~ 1|hhsize+hhworker+lnhhincome+actden+entropy+pct4way+stopden, data = hts2,
                  shape="wide", reflevel = "single family detached")
summary(mlogit1)

