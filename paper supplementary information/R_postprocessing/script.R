getwd() -> rootdir
dir.create("output")
dir.create("figures")
dir.create("renv")
library(TreeTools)
library(phangorn)
library(Claddis)
library(ggplot2)

setwd(paste(rootdir, "/functions", sep=""))
source("ancmat.R")
setwd(paste(rootdir, "/data", sep=""))
logfile <- read.table("placoderms.log", header=T)
matrix <- ReadMorphNexus("MATRIX_FIXED_HOMOLOGY1_NO_OUTGROUP.nex")
matrixplac <- ReadMorphNexus("MATRIX_FIXED_HOMOLOGY1_PLACODERMS.nex")
matrix0 <- ReadMorphNexus("MATRIX_FIXED_HOMOLOGY0_NO_OUTGROUP.nex")
matrix1 <- ReadMorphNexus("MATRIX_FIXED_HOMOLOGY1_NO_OUTGROUP.nex")
state2homoplasy0 <- read.table("2state_0homoplasy.txt", header=T)
state2homoplasy1 <- read.table("2state_1homoplasy.txt", header=T)
state2homoplasy2 <- read.table("2state_2homoplasy.txt", header=T)
state2homoplasy3 <- read.table("2state_3homoplasy.txt", header=T)
state2homoplasy4 <- read.table("2state_4homoplasy.txt", header=T)
state2homoplasy5 <- read.table("2state_5homoplasy.txt", header=T)
state2homoplasy6 <- read.table("2state_6homoplasy.txt", header=T)
state2homoplasy7 <- read.table("2state_7homoplasy.txt", header=T)
state2homoplasy8 <- read.table("2state_8homoplasy.txt", header=T)
state2homoplasy9 <- read.table("2state_9homoplasy.txt", header=T)
state3homoplasy0 <- read.table("3state_0homoplasy.txt", header=T)
state3homoplasy1 <- read.table("3state_1homoplasy.txt", header=T)
state3homoplasy2 <- read.table("3state_2homoplasy.txt", header=T)
state3homoplasy3 <- read.table("3state_3homoplasy.txt", header=T)
state3homoplasy4 <- read.table("3state_4homoplasy.txt", header=T)
state3homoplasy5 <- read.table("3state_5homoplasy.txt", header=T)
state3homoplasy6 <- read.table("3state_6homoplasy.txt", header=T)
homology0state2homoplasy0 <- read.table("homology0_2state_0homoplasy.txt", header=T)
homology0state2homoplasy1 <- read.table("homology0_2state_1homoplasy.txt", header=T)
homology0state2homoplasy2 <- read.table("homology0_2state_2homoplasy.txt", header=T)
homology1state2homoplasy0 <- read.table("homology1_2state_0homoplasy.txt", header=T)
homology1state2homoplasy1 <- read.table("homology1_2state_1homoplasy.txt", header=T)
homology1state2homoplasy2 <- read.table("homology1_2state_2homoplasy.txt", header=T)
load("partitionpositions.Rdata")
seq(201, 2001, 20) -> ind
setdiff(ind, which(logfile$homology==0)[which(which(logfile$homology==0) %in% ind)]) -> ind
length(ind) -> nanc
length(ind) + 108 -> nmat


ancmat(ind) -> ancestormatrix2
rbind(matrix$Matrix_1$Matrix, ancestormatrix2) -> matrix$Matrix_1$Matrix

####PLOT MDS####
setwd(paste(rootdir, "/figures", sep=""))
MorphMatrix2PCoA(matrix) -> m
pdf(file="mds.pdf")
plot(m$vectors[,1:2], pch=20, cex=0.7, col="grey")
chull(m$vectors[109:nmat,1:2]) -> ancchull
ancchull+108 -> ancchull
polygon(m$vectors[ancchull, ],col=rgb(0.93,0.93,0.93), border=NA)
points(m$vectors[,1:2], pch=20, cex=0.7, col="grey")
points(m$vectors[1:108,1:2], pch=20, cex=0.9)
points(m$vectors[35:36,1:2], pch=20, cex=1.4, col="purple")
#text(x=m$vectors[,1], y=m$vectors[,2]+0.01, labels=rownames(m$vectors), cex=0.3)
chull(m$vectors[1:34, 1:2]) -> placodermchull
c(placodermchull, placodermchull[1]) -> placodermchull
lines(m$vectors[placodermchull, ], col="#609630", lwd=2)

chull(m$vectors[38:77, 1:2]) -> chondrichthyanchull
c(chondrichthyanchull, chondrichthyanchull[1])+37 -> chondrichthyanchull
lines(m$vectors[chondrichthyanchull, ], col="#d9b516", lwd=2)


chull(m$vectors[78:108, 1:2]) -> osteichthyanchull
c(osteichthyanchull, osteichthyanchull[1])+77 -> osteichthyanchull
lines(m$vectors[osteichthyanchull, ], col="#3e49cf", lwd=2)
dev.off()

###PLOT DENSITY####
rbind(matrixplac$Matrix_1$Matrix, ancestormatrix2) -> matrixplac$Matrix_1$Matrix
MorphMatrix2PCoA(matrixplac) -> mp

as.data.frame(mp$vectors[,1:2]) -> h
order <- data.frame(order=c(rep("antiarchs", 7), rep("petalichthyids",6), rep("arthrodires", 13), rep("ptyctodontids", 4), rep("acanthothoracids", 2), rep("rhenanids", 2), rep("maxillate placoderms", 2), rep("ancestor", nanc)))
cbind(h, order) -> h
chull(h[1:7,]) -> antiarchchull
c(antiarchchull, antiarchchull[1]) -> antiarchchull
chull(h[8:13,]) -> petalchull
c(petalchull, petalchull[1])+7 -> petalchull
chull(h[14:26,]) -> arthrochull
c(arthrochull, arthrochull[1])+13 -> arthrochull
chull(h[27:30,]) -> ptyctochull
c(ptyctochull, ptyctochull[1])+26 -> ptyctochull
chull(h[31:32,]) -> rhenchull
c(rhenchull, rhenchull[1])+30 -> rhenchull
chull(h[33:34,]) -> acanthchull
c(acanthchull, acanthchull[1])+32 -> acanthchull



pdf(file="density.pdf")
print(
ggplot(h[37:(36+nanc),], aes(x=Axis.1, y=Axis.2), ) +
stat_density_2d(aes(fill = ..level..), geom = "polygon") +
scale_fill_distiller(palette= "Greys", direction=1) +
geom_point(data = h[35:36,c(1,2)], mapping = aes(x = Axis.1, y = Axis.2,), col="purple") +
geom_point(data = h[1:34,c(1,2)], mapping = aes(x = Axis.1, y = Axis.2), col="#609630") +
geom_polygon(data=h[antiarchchull,], fill="#eb6c6c30") +
geom_polygon(data=h[petalchull,], fill="#89e0d530") +
geom_polygon(data=h[arthrochull,], fill="#4073c730") +
geom_polygon(data=h[ptyctochull,], fill="#a65ac730") +
geom_line(data=h[rhenchull,], col="#ab1156") +
geom_line(data=h[acanthchull,], col="#b58305") +
geom_line(data=h[35:36,], col="purple") +
theme_light()
)
dev.off()

###PLOT STRIPCHART###
list() -> sc
for(i in 109:nmat){
  m$Di[i,][1:108] -> sc[[i-108]]
}
pdf(file="stripchart.pdf")
stripchart(sc, pch=20, vertical=T, type="n", xaxt="n", ylab="Distance (Gower Coefficient)")
for(i in 1:length(sc)){
  points(rep(i,2), sc[[i]][35:36], col="purple", pch=20)
  points(i, sc[[i]][37], col="#00000040", pch=20)
  points(rep(i,34), sc[[i]][1:34], col="#60963040", pch=20)
  points(rep(i,40), sc[[i]][38:77], col="#d9b51640", pch=20)
  points(rep(i,31), sc[[i]][78:108], col="#3e49cf40", pch=20)
}
dev.off()


###PLOT PIECHART USING WHOLE POSTERIOR####
vector() -> mintax

for(i in 201:2001){
  i -> ind
  logfile$homology[i] -> state
  ancmat(ind, hom=state) -> ancestormatrix2
  if(state==0){
    matrix0 -> matrix
  }
  if(state==1){
    matrix1 -> matrix
  }
  rbind(matrix$Matrix_1$Matrix, ancestormatrix2) -> matrix$Matrix_1$Matrix
  MorphMatrix2PCoA(matrix) -> m2
  names(m2$Di[109,])[order(m2$Di[109,])[2]] -> mintax[i-200]
}
rownames(m$Di[1:108,]) -> taxnames
table(as.factor(mintax)) -> mintaxtab
rep(0,6) -> piedat
c("Entelognathus", "Qilinyu", "Janusiscus", "placoderms", "chondrichthyans", "osteichthyans") -> names(piedat)
mintaxtab[which(names(mintaxtab)=="Entelognathus_primordialis")] -> piedat[1]
mintaxtab[which(names(mintaxtab)=="Qilinyu_rostrata")] -> piedat[2]
mintaxtab[which(names(mintaxtab)=="Janusiscus_schultzei")] -> piedat[3]

sum(mintaxtab[which(names(mintaxtab) %in% taxnames[1:34])]) -> piedat[4]
sum(mintaxtab[which(names(mintaxtab) %in% taxnames[38:77])]) -> piedat[5]
sum(mintaxtab[which(names(mintaxtab) %in% taxnames[78:108])]) -> piedat[6]

pdf(file="pie.pdf")
pie(piedat, cex=0.8, col=c("#7824bd", "#a57bc7", "#b5b5b5", "#609630", "#d9b516", "#3e49cf"))
dev.off()

bardat <- data.frame(taxon=names(piedat), posterior=piedat/sum(piedat))
pdf("bar.pdf")
print(
ggplot(data=bardat, aes(x=reorder(taxon, -posterior), y=posterior), xlab="taxon") +
  geom_bar(stat="identity", fill=c("#7824bd", "#7824bd", "#b5b5b5", "#609630", "#d9b516", "#3e49cf")) +
  theme_light() + xlab("taxon with shortest distance to reconstructed ancestor") +
  theme(axis.text.x = element_text(angle = 45, size=13, vjust=0.5), axis.text.y = element_text(size=13), axis.title.y=element_text(size=15), axis.title.x=element_text(size=15))
)
dev.off()

setwd(paste(rootdir, "/output", sep=""))

write.table(piedat/sum(piedat), file="piedat.txt", quote=F)


setdiff(which(logfile$homology==0), 1:200) -> ind
ancmat(ind, hom=0) -> ancestormatrix0
setdiff(which(logfile$homology==1), 1:200) -> ind
ancmat(ind, hom=1) -> ancestormatrix1
rbind(ancestormatrix0, ancestormatrix1) -> ancestormatrixall

tabulate <- function(vec){
  probs <- vector()
  length(which(vec==0))/length(vec) -> probs[1]
  length(which(vec==1))/length(vec) -> probs[2]
  length(which(vec==2))/length(vec) -> probs[3]
  return(probs)
}


charprobs <- data.frame(character=c(1:261,263:477,479:507), state0=rep(NA, 505,), state1=rep(NA, 505), state2=rep(NA, 505), max=rep(NA, 505))

for(i in 1:505){
  tabulate(ancestormatrixall[,i]) -> charprobs[i,2:4]
  max(tabulate(ancestormatrixall[,i])) -> charprobs[i,5]
}

write.table(charprobs, quote=F, file="character_probabilities.txt")

setwd(paste(rootdir, "/figures", sep=""))

pdf("traces.pdf", width=10)
par(mfrow=c(3,1))
par(mgp=c(1.5,0.5,0))
par(mar = c(0.8,2.5,1.5,0.2))
nf <- layout(matrix(c(1,2,3),ncol=1), widths=c(7,7,7), heights=c(2,1,2), TRUE)
logfile$hom00[201:2001] + logfile$hom01[201:2001] + logfile$hom02[201:2001] -> hom0all
logfile$hom10[201:2001] + logfile$hom11[201:2001] + logfile$hom12[201:2001] -> hom1all
plot(c(hom0all, hom1all), type="n", xlim=c(0, 1801), xaxt="n", main="Homology tree likelihood", ylab="log likelihood", xaxs="i", bty="l")
box(col="grey")
legend("bottom", c("homology 0","homology1"), fill=c("#a12810", "#143a91"), horiz=TRUE, cex=1.1, bty="n", border=c("#a12810", "#143a91"))
lines(hom0all, col="#a12810")
lines(hom1all, col="#143a91")
plot(logfile$homology[201:2001], type="n", xaxt="n", main="Homology state", at=c(0,1), ylab="", xaxs="i", ylim=c(-0.2, 1.2), bty="l")
box(col="grey")
lines(logfile$homology[201:2001], col="#204d31")
logfile$Multiplex_homoplasy0[201:2001] + logfile$Multiplex_homoplasy1[201:2001] + logfile$Multiplex_homoplasy2[201:2001] -> multiplexall
plot(c(multiplexall, hom0all, hom1all), type="n", xlim=c(0, 1801), xaxt="n", main="Homology multiplexer", ylab="log likelihood", xaxs="i", bty="l")
box(col="grey")
lines(hom0all, col="#a1281020")
lines(hom1all, col="#143a9120")
lines(multiplexall, col="#4f0a78")
dev.off()

setwd(paste(rootdir, "/renv", sep=""))
save.image()
