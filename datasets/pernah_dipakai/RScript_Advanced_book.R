##ADVANCED QUANTITATIVE RESEARCH METHODS FOR URBAN PLANNERS##
##R script##

##CHAPTER 4: POISSON AND NEGATIVE BINOMIAL REGRESSION ANALYSIS##
library("foreign")
hts<-read.spss("HTS.household.10regions.sav",to.data.frame=TRUE)

hist(hts$autotrips,freq=F,xlab="auto trips",main="Histogram of auto trips")
lines(density(hts$autotrips,adjust=3),col="red")

glm2<-glm(autotrips~hhsize+hhworker+hhincome+actden+stopden+emp30t,data=hts,family=poisson(link = "log"))
summary(glm2)

library(AER)
dispersiontest(glm2)

library(MASS)
glm.nb1<-glm.nb(autotrips~hhsize+hhworker+hhincome+actden+stopden+emp30t,data=hts)
summary(glm.nb1)

glm.nb0<-glm.nb(autotrips~1,data=hts)
anova(glm.nb1,glm.nb0)


##CHAPTER 5: FACTOR ANALYSIS##
library("foreign")
uza<-read.spss("UZA.sav",to.data.frame=TRUE)

uza_den<-uza[,c("popden","empden","pct1500","pct12500","urbden")]

library(psych)
cor(uza_den)
KMO(uza_den)
cortest.bartlett(uza_den)

fa.parallel(uza_den, fa="pc", n.iter=100,
            show.legend=FALSE, main="Scree plot with parallel analysis")

pc <- principal(uza_den, nfactors=1, score=T)
pc

head(pc$scores)
uza.pc<-cbind(uza,pc$scores)
uza.pc$density_factor<-uza.pc$PC1*25+100
print(head(uza.pc[,c("urbanarea","PC1","density_factor")]))


##CHAPTER 6: CLUSTER ANALYSIS##
library("foreign")
uza<-read.spss("UZA.sav",to.data.frame=TRUE)
options("scipen"=100, "digits"=4)

uza_cl<-data.frame(scale(uza[,c("pop000","inc000","area","flm","tpm","compact")]))
d<-dist(uza_cl)

uza_hc<-hclust(d,method="ward.D2")
uza$hc_clust<-cutree(uza_hc,4)

plot(uza_hc,cex=0.5)
rect.hclust(uza_hc,k=4)

library(NbClust)
uza_nbclust <- NbClust(uza_cl, distance="euclidean",
                 min.nc=2, max.nc=10, method="ward.D2")

set.seed(1234)
uza_km<-kmeans(uza_cl,3,nstart=10)
uza_km$size
uza_km$centers
uza_cl$kmeans<-uza_km$cluster
head(uza_cl)


##CHAPTER 7: MULTILEVEL MODELING##
library(foreign)
hts<-read.spss("HTS.household.10regions.sav",to.data.frame=TRUE)
region<-read.spss("HTS.region.10regions.sav",to.data.frame=TRUE)
region$regname<-trimws(region$regname)
hts$regname<-as.character(hts$region)

library(dplyr)
hts.mlm<-left_join(hts,region,by="regname")
names(hts.mlm)

library(lme4)
library(lmerTest)
mlm.base<-lmer(lnvmt~(1|regname),data=hts.mlm)
summary(mlm.base)

mlm1<-lmer(lnvmt~veh+hhsize+lnhhincome+regpop+fuel+compact+(1|regname),data=hts.mlm)
summary(mlm1)

1- logLik(mlm1)/logLik(mlm.base)


##CHAPTER 8: STRUCTURAL EQUATION MODELING (SEM)##
library("foreign")
uza<-read.spss("UZA.sav",to.data.frame=TRUE)

library(lavaan)
model<-'
lnrtden ~ lnlrt + lnhrt + lnpop000
lntfreq ~ lnpop000
lntpm ~ lntfreq + lnrtden + lnpop000 + lninc000
lnpopden ~ lnpop000 + lnrtden + lntfreq + lnolm + lnflm + lnfuel
lnvmt ~ lntpm + lnpop000 + lnpopden + lninc000 + lnolm + lnflm + lnfuel
'

results<-sem(model,data=uza)
summary(results,standardized=T,fit=T)


##Chapter 9. Spatial Econometrics##
#Step by Step 1: Spatial Data Analysis
install.packages(c("sp", "spdep", "spatialreg", "spgwr", "rgdal", "tmap", "RColorBrewer"))
library(sp)

hts = foreign::read.spss("HTS.household.10regions.sav", to.data.frame = TRUE)
class(hts)

str(hts)     # Identifying variables and their types
summary(hts) # Summary statistics

hts$lnvmt
mean(hts$lnvmt) # Mean
mean(hts$lnvmt, na.rm=TRUE) # Mean
sd(hts$lnvmt, na.rm=TRUE) # Standard deviation
var(hts$lnvmt, na.rm=TRUE) # Variance
median(hts$lnvmt, na.rm=TRUE) # Median
quantile(hts$lnvmt, na.rm=TRUE, c(0.25, 0.75)) # Quantiles (25 and 75 percentile)
help(mean)

hts.sp <- subset(hts, !is.na(intptlon10))
coordinates(hts.sp) <- ~intptlon10+intptlat10
class(hts.sp)
str(hts.sp)

proj4string(hts.sp) = CRS("+init=epsg:4326")
proj4string(hts.sp)

plot(hts.sp, pch=16, cex=.5, col=rgb(1, 0.55, 0, 0.2),
     axes=TRUE)  

library(rgdal)
ct.sp <- readOGR("./tract10/tract10.shp")
class(ct.sp)
proj4string(ct.sp)

hts.sp <- spTransform(hts.sp, CRS(proj4string(ct.sp)))
proj4string(hts.sp)

plot(ct.sp, lwd=1, lty=6, border="gray", axes=TRUE) 
plot(hts.sp, pch=16, cex=.5, col=rgb(1, 0.55, 0, 0.2), add=TRUE)

writeOGR(hts.sp, layer="hts.sp", 
         dsn="./shapefiles", 
         driver="ESRI Shapefile", 
         overwrite_layer=TRUE)

ct.sp$lnvmt = aggregate(hts.sp["lnvmt"], ct.sp, mean, na.rm=TRUE)$lnvmt
summary(ct.sp$lnvmt)

ct.sp = ct.sp[!is.na(ct.sp$lnvmt),]

library(tmap)
tm_shape(ct.sp) + tm_borders() 
tm_shape(ct.sp) + tm_borders() + tm_fill("darkorange") 

tm_shape(ct.sp) + 
  tm_fill(col = "lnvmt", palette = "Greens", style = "pretty", title = "log VMT")

library(spdep)
ct.nb.q <- poly2nb(ct.sp)
ct.nb.q
plot(ct.sp, border="darkgrey")
plot(ct.nb.q, coordinates(ct.sp), add=TRUE, col="blue", lwd=2)

ct.nb.r <- poly2nb(ct.sp, queen=FALSE)
plot(ct.sp, border="darkgrey")
plot(ct.nb.r, coordinates(ct.sp), add=TRUE, col="green", lwd=2)

ct.lw = nb2listw(ct.nb.q)
moran.test(ct.sp$lnvmt, ct.lw)

ct.locm <- localmoran(ct.sp$lnvmt, ct.lw)
head(ct.locm)

ct.sp$locmi = ct.locm[,"Z.Ii"]
map1 = tm_shape(ct.sp) + 
  tm_fill(col = "locmi", palette = "RdBu", style = "order")
ct.sp$locmip = ct.locm[,"Pr(z > 0)"]
breaks = c(0, 0.01, 0.05, 1)
map2 = tm_shape(ct.sp) + 
  tm_fill(col = "locmip", palette = "-Reds", breaks = breaks)
tmap_arrange(map1, map2)

ct.locg <- localG(ct.sp$lnvmt, ct.lw)

ct.sp$locg = ct.locg
summary(ct.locg)
breaks = c(-5,-1.96, 1.96, 5)
map2 = tm_shape(ct.sp) + 
  tm_fill(col = "locmip", palette = "-Reds", breaks = breaks)
tm_shape(ct.sp) + tm_borders() +
  tm_fill(col = "locg", palette = "-RdBu", breaks = breaks, title = "G-index") + 
  tm_legend(bg.color = "white")

#Step by Step 2: Spatial Econometrics
library(spatialreg)
cthh.sp = aggregate(hts.sp[c("lnvmt", "hhsize", 
                             "hhworker", "hhincome", 
                             "emp10a", "emp30t", 
                             "jobpop", "actden", 
                             "entropy", "intden", 
                             "pct4way")], 
                    ct.sp, mean, na.rm=TRUE)

cthh.sp = cthh.sp[complete.cases(cthh.sp@data),]
summary(ct.sp$lnvmt)

lnvmt.lm = lm(lnvmt ~., cthh.sp)
summary(lnvmt.lm)

cthh.nb = poly2nb(cthh.sp)
cthh.lw = nb2listw(cthh.nb)
cthh.sp$lmres = residuals(lnvmt.lm)
moran.test(cthh.sp$lmres, cthh.lw)

tm_shape(cthh.sp) + 
  tm_fill(col = "lmres", palette = "PRGn", style = "quantile", title = "LM residuals") + 
  tm_legend(bg.color = "white")

cthh.sp = cthh.sp[,-12]
summary(lm.LMtests(lnvmt.lm, cthh.lw, test=c("LMerr","LMlag")))
lnvmt.splag <- lagsarlm(lnvmt ~ ., 
                        data=cthh.sp@data, listw=cthh.lw)
summary(lnvmt.splag)


moran.test(residuals(lnvmt.splag), listw = cthh.lw)

lnvmt.sperr <- errorsarlm(lnvmt ~ ., 
                          data=cthh.sp@data, listw=cthh.lw)
summary(lnvmt.sperr)

lnvmt.ev = SpatialFiltering(lnvmt ~ ., 
                            data=cthh.sp, nb=cthh.nb, style="W",
                            alpha = 0.25, ExactEV = FALSE)
lnvmt.ev

ev.sel <- fitted(lnvmt.ev)
lnvmt.sf = lm(lnvmt ~ . + ev.sel, cthh.sp)
summary(lnvmt.sf)

require(knitr)
mod = c("Linear Model", "Spatial Lag", "Spatial Error", "Spatial Filter")
aics = c(AIC(lnvmt.lm), AIC(lnvmt.splag), AIC(lnvmt.sperr), AIC(lnvmt.sf))
kable(data.frame(Model = mod, AIC = aics))

moran.test(residuals(lnvmt.sf), cthh.lw)

library(spgwr)
lnvmt.bw <- gwr.sel(lnvmt ~ .,
                    data = cthh.sp, adapt = TRUE, gweight = gwr.Gauss, 
                    longlat = TRUE, method = "cv", verbose=TRUE) 
lnvmt.bw

lnvmt.gwr <- gwr(lnvmt ~ ., data = cthh.sp, 
                 adapt = lnvmt.bw, gweight = gwr.Gauss, hatmatrix = TRUE)
lnvmt.gwr

tm_shape(lnvmt.gwr$SDF) + 
  tm_fill(col = "localR2", palette = "Reds", style = "quantile", title = "local R2")

map1 = tm_shape(lnvmt.gwr$SDF) + 
  tm_fill(col = "hhsize", palette = "Reds", style = "quantile")
map2 = tm_shape(lnvmt.gwr$SDF) + 
  tm_fill(col = "hhincome", palette = "Reds", style = "quantile")
map3 = tm_shape(lnvmt.gwr$SDF) + 
  tm_fill(col = "entropy", palette = "Reds", style = "quantile")
map4 = tm_shape(lnvmt.gwr$SDF) + 
  tm_fill(col = "intden", palette = "Reds", style = "quantile")
tmap_arrange(map1, map2, map3, map4)

