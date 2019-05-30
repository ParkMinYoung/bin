setwd("~/문서/mutationprofile")


lung = read.delim("Lung100.somaticMutation.table",header=T,row.names=1)
tcga_luad = read.delim(file="luad_total.txt",header=T,row.names=1)
tcga_lusc = read.delim(file="lusc_total.txt",header=T,row.names=1)
lluad=tcga_luad[c(1,2,3),]
llusc=tcga_lusc[c(1,2,3),]
tcga_luad = as.matrix(tcga_luad[-c(1,2,3),])
tcga_lusc = as.matrix(tcga_lusc[-c(1,2,3),])


for(i in 1:length(tcga_luad[,1])){
  tcga_luad[i,which(tcga_luad[i,]!="0")] = 1
  tcga_luad[i,which(tcga_luad[i,]=="0")] = 0
}
for(i in 1:length(tcga_lusc[,1])){
  tcga_lusc[i,which(tcga_lusc[i,]!="0")] = 1
  tcga_lusc[i,which(tcga_lusc[i,]=="0")] = 0
}

test=as.data.frame(apply(tcga_luad,1,as.numeric))
(colSums(test)[order(colSums(test))])[(dim(test)[2]-49):dim(test)[2]]
luadlist = colnames(test[,order(colSums(test))][,which(colSums(test[,order(colSums(test))]) >= 16)])
test1=as.data.frame(apply(tcga_lusc,1,as.numeric))
(colSums(test1)[order(colSums(test1))])[(dim(test1)[2]-49):dim(test1)[2]]
lusclist=colnames(test1[,order(colSums(test1))][,which(colSums(test1[,order(colSums(test1))])>=18)])
lunglist = rownames(lung[order(rowSums(lung)),][which(rowSums(lung[order(rowSums(lung)),])>3),])

merlist = c(luadlist,lusclist,lunglist)
merlist = unique(merlist)

luadtest = test[,which(colnames(test)%in%merlist)]
lusctest = test1[,which(colnames(test1)%in%merlist)]
lungdata = lung[which(rownames(lung)%in%merlist),]


row.names(luadtest) = colnames(tcga_luad)
row.names(lusctest) = colnames(tcga_lusc)
luadtest = t(luadtest)
lusctest = t(lusctest)
lungdata=as.data.frame(lungdata[order(rownames(lungdata)),])
luadtest=as.data.frame(luadtest[order(rownames(luadtest)),])
lusctest=as.data.frame(lusctest[order(rownames(lusctest)),])
luadtest$symbol = rownames(luadtest)
lungdata$symbol = rownames(lungdata)
lusctest$symbol = rownames(lusctest)

lung_luad = merge(lungdata, luadtest, by.x="symbol", by.y="symbol", all=T)
lung_luad[is.na(lung_luad)] = 0
lung_luad_lusc = merge(lung_luad,lusctest,by.x="symbol", by.y="symbol", all=T)
lung_luad_lusc[is.na(lung_luad_lusc)] = 0
row.names(lung_luad_lusc) = lung_luad_lusc[,1]
mergedata = lung_luad_lusc[order(row.names(lung_luad_lusc)),-1]


tcgalist1=as.data.frame(apply(lluad,1,as.character))
row.names(tcgalist1)=colnames(lluad)
tcgalist2=as.data.frame(apply(llusc,1,as.character))
row.names(tcgalist2)=colnames(llusc)

color.map <- function(tabacco) { if (tabacco == "smoker") 1 else 2 }
patientcolors1 <- unlist(lapply(tcgalist1$tabacco, color.map))
patientcolors2 <- unlist(lapply(tcgalist2$tabacco, color.map))
patientcolors = c(rep(2,length(lungdata[1,])-1),patientcolors1,patientcolors2)

color.map2 <- function(gender) {if (gender == "MALE") 1 else 2}
patientcolors3 <- unlist(lapply(tcgalist1$gender, color.map2))
patientcolors4 <- unlist(lapply(tcgalist2$gender, color.map2))
patientgendercolors = c(rep(2,length(lungdata[1,])-1),patientcolors3,patientcolors4)


color.map3 <- function(race) { if (race == "WHITE") 2 else if (race == "ASIAN") 1 else 3 }
patientcolors5 <- unlist(lapply(tcgalist1$race, color.map3))
patientcolors6 <- unlist(lapply(tcgalist2$race, color.map3))
patientracecolor = c(rep(1,length(lungdata[1,])-1),patientcolors5,patientcolors6)

patientstudycolor = c(rep(1,length(lungdata[1,])-1),rep(2,(dim(luadtest)[2])-1),rep(3,dim(lusctest)[2]-1))

gene1 = as.data.frame(matrix(1,length(rownames(lungdata)),1))
rownames(gene1) = rownames(lungdata)
gene1$symbol = rownames(lungdata)
gene2 = as.data.frame(matrix(1,length(rownames(test)),1))
rownames(gene2) = rownames(test)
gene2$symbol = rownames(test)
gene3 = as.data.frame(matrix(1,length(rownames(test1)),1))
rownames(gene3) = rownames(test1)
gene3$symbol = rownames(test1)

gene = merge(gene1,gene2,by.x="symbol", by.y="symbol", all=T)
gene[is.na(gene)] = 0
gene = merge(gene,gene3,by.x="symbol", by.y="symbol", all=T)
gene[is.na(gene)] = 0
rownames(gene) = gene$symbol
gene = gene[,-1]
colnames(gene) = c("lung","luad","lusc")


studylist <- colnames(mergedata)


push <- function(l, x) {
  assign(l, append(eval(as.name(l)), x), envir=parent.frame())
}
list=vector()

for(i in 1:length(test[1,])){
  push("list",paste("LUAD",i))
}
for(i in 1:length(test1[1,])){
  push("list",paste("LUSC",i))
}

smokedata=mergedata
geneoreder = order(rowSums(mergedata))
#geneoreder = merlist
#####################################################################################
#sort by smoke
#all / race(asian)/ gender(female)

for(i in 1:length(colnames(mergedata))){
  if(grepl("Pat",colnames(mergedata)[i]) == 1){
    mergedata[which(mergedata[,i]!=0),i] = 2
  }
  for(j in 1:length(rownames(tcgalist1))){
    if(colnames(mergedata)[i] == rownames(tcgalist1)[j]){
      if(tcgalist1[j,2] == 'smoker'){
        mergedata[which(mergedata[,i]!=0),i] = 1
      }
      else{
        mergedata[which(mergedata[,i]!=0),i] = 2
      }
    }
  }
  for(j in 1:length(rownames(tcgalist2))){
    if(colnames(mergedata)[i] == rownames(tcgalist2)[j]){
      if(tcgalist2[j,2] == 'smoker'){
        mergedata[which(mergedata[,i]!=0),i] = 1
      }
      if(tcgalist2[j,2] == 'non-smoker'){
        mergedata[which(mergedata[,i]!=0),i] = 2
      }
    }
  }
}

####################################################################################
#sort by smoke _ famale & male

mer = (as.matrix(smokedata[geneoreder,order(patientcolors)]))

#mergedata -> 1: smoke, 2: non-smoke

smokepe = cbind(rowSums(mer[,which(patientcolors[order(patientcolors)] == 1)]), rowSums(mer[,which(patientcolors[order(patientcolors)] == 2)]))
smokerper = smokepe/rowSums(smokepe)

raceper = cbind(rowSums(mer[,patientracecolor[order(patientcolors)] == 1]), rowSums(mer[,patientracecolor[order(patientcolors)] == 2]), rowSums(mer[,patientracecolor[order(patientcolors)] == 3]))
raceperdata = raceper/rowSums(raceper)

studyper = cbind(rowSums(mer[,patientstudycolor[order(patientcolors)]==1]),rowSums(mer[,patientstudycolor[order(patientcolors)]==2]),rowSums(mer[,patientstudycolor[order(patientcolors)]==3]))
studyperdata = studyper/rowSums(studyper)

genddata = cbind(rowSums(mer[,patientgendercolors[order(patientcolors)]==1]),rowSums(mer[,patientgendercolors[order(patientcolors)]==2]))
genderdata = genddata/rowSums(genddata)


png("sort_by_smoke.png",width = 3000, height = 2000)

split.screen(rbind(c(0.1,0.70,0.15, 0.80),c(0.1,0.7,0.805,0.815),c(0.1,0.7,0.815,0.825),c(0.1,0.7,0.825,0.835),c(0.1,0.7,0.835,0.845),c(0.075,0.725,0.845,0.875),c(0.705,0.735,0.125,0.825),c(0.735,0.765,0.125,0.825),c(0.765,0.795,0.125,0.825),c(0.795,0.825,0.125,0.825),c(0.825,0.99,0.1,0.94)))
screen(1)
par(mar = c(0, 0, 0, 0))
image(t(as.matrix(mergedata[geneoreder,order(patientcolors)])),axes=F,col=c("white","red","gray"))
grid(ncol(mergedata),nrow(mergedata),col="black",lty=1,lwd=1)
box(lwd=2)
axis(2,at=c(seq(0,1,by=(1/(length(mergedata[,1])-1)))),lab=c(row.names(mergedata[geneoreder,order(patientcolors)])),las=1)
axis(1,at=c(seq(0,1,by=(1/(length(mergedata[1,])-1)))),lab=c(colnames(mergedata[geneoreder,order(patientcolors)])),las=2)
#text(seq(0,1,by=(1/(length(mergedata[1,])-1))),par("usr")[3]-.5,,labels=c(xname,list),srt=45,pos=1,xpd=TRUE,cex=1)
screen(2)
par(mar = c(0, 0, 0, 0))
image(as.matrix(patientstudycolor[order(patientcolors)]),col=c("orange","green","blue"),axes=F)
box(lwd=2)
screen(3)
par(mar = c(0, 0, 0, 0))
image(as.matrix(patientracecolor[order(patientcolors)]),col=c("yellow","white","black"),axes=F)
box(lwd=2)
screen(4)
par(mar = c(0, 0, 0, 0))
image((as.matrix(patientgendercolors[order(patientcolors)])),col=c("brown","pink"),axes=F)
box(lwd=2)
screen(5)
par(mar = c(0, 0, 0, 0))
image((as.matrix(patientcolors[order(patientcolors)])),col=c("red","gray"),axes=F)
box(lwd=2)
screen(6)
par(mar = c(0, 0, 0, 0))
barplot(colSums(mergedata[,order(patientcolors)]),space=0,xaxt='n')
screen(7)
par(mar = c(0, 0, 0, 0))
barplot(t(studyperdata),col=c("orange","green","blue"),space=0,horiz=T,yaxt='n',xaxt='n')
screen(8)
par(mar = c(0, 0, 0, 0))
barplot(t(smokerper),col=c("red","gray"),space=0,horiz=T,yaxt='n',xaxt='n')
screen(9)
par(mar = c(0, 0, 0, 0))
barplot(t(raceperdata),col=c("yellow","white","black"),space=0,horiz=T,yaxt='n',xaxt='n')
screen(10)
par(mar = c(0, 0, 0, 0))
barplot(t(genderdata),col=c("brown","pink"),space=0,horiz=T,yaxt='n',xaxt='n')
screen(11)
par(mar = c(0, 0, 0, 0))
legend(x=0.1,y=1,c("lung100","TCGA luad","TCGA lusc","smoker","non smoker","asian","white","black","male","female"),col=c("orange","green","blue","red","gray","yellow","white","black","brown","pink"),cex=3,horiz=F,pch=15, bty="n")
dev.off()

###########################################
#sort by smoke _ only asian

mer = (as.matrix(smokedata[geneoreder,order(patientracecolor)][,patientracecolor[order(patientracecolor)] == 1]))
#patientracecolor로 정렬하고 나서 asian만 고르기 
#mergedata -> 1: smoke, 2: non-smoke

smokepe = cbind(rowSums(mer[,which(patientcolors[order(patientracecolor)][patientracecolor[order(patientracecolor)] == 1] == 1)]),rowSums(mer[,which(patientcolors[order(patientracecolor)][patientracecolor[order(patientracecolor)] == 1] == 2)]))
smokerper = smokepe/rowSums(smokepe)

raceper = cbind(rowSums(mer[,patientracecolor[order(patientracecolor)][patientracecolor[order(patientracecolor)] == 1] == 1]), rowSums(mer[,patientracecolor[order(patientracecolor)][patientracecolor[order(patientracecolor)] == 1] == 2]), rowSums(mer[,patientracecolor[order(patientracecolor)][patientracecolor[order(patientracecolor)] == 1] == 3]))
raceperdata = raceper/rowSums(raceper)

studyper = cbind(rowSums(mer[,patientstudycolor[order(patientracecolor)][patientracecolor[order(patientracecolor)] == 1]==1]),rowSums(mer[,patientstudycolor[order(patientracecolor)][patientracecolor[order(patientracecolor)] == 1]==2]),rowSums(mer[,patientstudycolor[order(patientracecolor)][patientracecolor[order(patientracecolor)] == 1]==3]))
studyperdata = studyper/rowSums(studyper)

sortdata = mergedata[geneoreder,order(patientracecolor)][,patientracecolor[order(patientracecolor)] == 1][,order(patientcolors[order(patientracecolor)][patientracecolor[order(patientracecolor)] == 1])]



png("asian_only_sort_by_smoke.png",width = 3000, height = 2000)
split.screen(rbind(c(0.1,0.70,0.15, 0.80),c(0.1,0.7,0.805,0.815),c(0.1,0.7,0.815,0.825),c(0.1,0.7,0.825,0.835),c(0.1,0.7,0.835,0.845),c(0.0725,0.7275,0.845,0.875),c(0.705,0.745,0.125,0.825),c(0.745,0.785,0.125,0.825),c(0.785,0.825,0.125,0.825),c(0.825,0.99,0.1,0.94)))
screen(1)
par(mar = c(0, 0, 0, 0))
image(t(as.matrix(sortdata)),axes=F,col=c("white","red","gray"))
grid(ncol(mergedata),nrow(mergedata),col="black",lty=1,lwd=1)
box(lwd=2)
axis(2,at=c(seq(0,1,by=(1/(length(sortdata[,1])-1)))),lab=c(row.names(sortdata)),las=1)
axis(1,at=c(seq(0,1,by=(1/(length(sortdata[1,])-1)))),lab=c(colnames(sortdata)),las=2)
#text(seq(0,1,by=(1/(length(mergedata[1,])-1))),par("usr")[3]-.5,,labels=c(xname,list),srt=45,pos=1,xpd=TRUE,cex=1)
screen(2)
par(mar = c(0, 0, 0, 0))
image(as.matrix(patientstudycolor[order(patientracecolor)][patientracecolor[order(patientracecolor)] == 1][order(patientcolors[order(patientracecolor)][patientracecolor[order(patientracecolor)] == 1])]),col=c("orange","green","blue"),axes=F)
box(lwd=2)
screen(3)
par(mar = c(0, 0, 0, 0))
image(as.matrix(patientracecolor[order(patientracecolor)][patientracecolor[order(patientracecolor)] == 1][order(patientcolors[order(patientracecolor)][patientracecolor[order(patientracecolor)] == 1])]),col=c("yellow"),axes=F)
box(lwd=2)
screen(4)
par(mar = c(0, 0, 0, 0))
image((as.matrix(patientgendercolors[order(patientracecolor)][patientracecolor[order(patientracecolor)] == 1][order(patientcolors[order(patientracecolor)][patientracecolor[order(patientracecolor)] == 1])])),col=c("brown","pink"),axes=F)
box(lwd=2)
screen(5)
par(mar = c(0, 0, 0, 0))
image((as.matrix(patientcolors[order(patientracecolor)][patientracecolor[order(patientracecolor)] == 1][order(patientcolors[order(patientracecolor)][patientracecolor[order(patientracecolor)] == 1])])),col=c("red","gray"),axes=F)
box(lwd=2)
screen(6)
par(mar = c(0, 0, 0, 0))
barplot(colSums(mergedata[,order(patientracecolor)][patientracecolor[order(patientracecolor)] == 1][order(patientcolors[order(patientracecolor)][patientracecolor[order(patientracecolor)] == 1])]),space=0,xaxt='n')
screen(7)
par(mar = c(0, 0, 0, 0))
barplot(t(studyperdata),col=c("orange","green","blue"),space=0,horiz=T,yaxt='n',xaxt='n')
screen(8)
par(mar = c(0, 0, 0, 0))
barplot(t(smokerper),col=c("red","gray"),space=0,horiz=T,yaxt='n',xaxt='n')
screen(9)
par(mar = c(0, 0, 0, 0))
barplot(t(raceperdata),col=c("yellow","white","black"),space=0,horiz=T,yaxt='n',xaxt='n')
screen(10)
par(mar = c(0, 0, 0, 0))
legend(x=0.1,y=1,c("lung100","TCGA luad","TCGA lusc","smoker","non smoker","asian","white","black","male","female"),col=c("orange","green","blue","red","gray","yellow","white","black","brown","pink"),cex=3,horiz=F,pch=15, bty="n")
dev.off()

##################################################################
#sort by smoke _ famale

mer = (as.matrix(smokedata[geneoreder,order(patientgendercolors)][,patientgendercolors[order(patientgendercolors)] == 2]))

#mergedata -> 1: smoke, 2: non-smoke

smokepe = cbind(rowSums(mer[,which(patientcolors[order(patientgendercolors)][patientgendercolors[order(patientgendercolors)] == 2] == 1)]),rowSums(mer[,which(patientcolors[order(patientgendercolors)][patientgendercolors[order(patientgendercolors)] == 2] == 2)]))
smokerper = smokepe/rowSums(smokepe)

raceper = cbind(rowSums(mer[,patientracecolor[order(patientgendercolors)][patientgendercolors[order(patientgendercolors)] == 2] == 1]), rowSums(mer[,patientracecolor[order(patientgendercolors)][patientgendercolors[order(patientgendercolors)] == 2] == 2]), rowSums(mer[,patientracecolor[order(patientgendercolors)][patientgendercolors[order(patientgendercolors)] == 2] == 3]))
raceperdata = raceper/rowSums(raceper)

studyper = cbind(rowSums(mer[,patientstudycolor[order(patientgendercolors)][patientgendercolors[order(patientgendercolors)] == 2]==1]),rowSums(mer[,patientstudycolor[order(patientgendercolors)][patientgendercolors[order(patientgendercolors)] == 2]==2]),rowSums(mer[,patientstudycolor[order(patientgendercolors)][patientgendercolors[order(patientgendercolors)] == 2]==3]))
studyperdata = studyper/rowSums(studyper)

sortdata = as.matrix(mergedata[geneoreder,order(patientgendercolors)])[,patientgendercolors[order(patientgendercolors)] == 2][,order(patientcolors[order(patientgendercolors)][patientgendercolors[order(patientgendercolors)] == 2])]

png("female_only_sort_by_smoke.png",width = 3000, height = 2000)
split.screen(rbind(c(0.1,0.70,0.15, 0.80),c(0.1,0.7,0.805,0.815),c(0.1,0.7,0.815,0.825),c(0.1,0.7,0.825,0.835),c(0.1,0.7,0.835,0.845),c(0.0725,0.7275,0.845,0.875),c(0.705,0.745,0.125,0.825),c(0.745,0.785,0.125,0.825),c(0.785,0.825,0.125,0.825),c(0.825,0.99,0.1,0.94)))
screen(1)
par(mar = c(0, 0, 0, 0))
image(t(sortdata),axes=F,col=c("white","red","gray"))
grid(ncol(mergedata),nrow(mergedata),col="black",lty=1,lwd=1)
box(lwd=2)
axis(2,at=c(seq(0,1,by=(1/(length(sortdata[,1])-1)))),lab=c(row.names(sortdata)),las=1)
axis(1,at=c(seq(0,1,by=(1/(length(colnames(sortdata))-1)))),lab=c(colnames(sortdata)),las=2)
#text(seq(0,1,by=(1/(length(mergedata[1,])-1))),par("usr")[3]-.5,,labels=c(xname,list),srt=45,pos=1,xpd=TRUE,cex=1)
screen(2)
par(mar = c(0, 0, 0, 0))
image(as.matrix(patientstudycolor[order(patientgendercolors)][patientgendercolors[order(patientgendercolors)] == 2][order(patientcolors[order(patientgendercolors)][patientgendercolors[order(patientgendercolors)] == 2])]),col=c("orange","green","blue"),axes=F)
box(lwd=2)
screen(3)
par(mar = c(0, 0, 0, 0))
image(as.matrix(patientracecolor[order(patientgendercolors)][patientgendercolors[order(patientgendercolors)] == 2][order(patientcolors[order(patientgendercolors)][patientgendercolors[order(patientgendercolors)] == 2])]),col=c("yellow","white","black"),axes=F)
box(lwd=2)
screen(4)
par(mar = c(0, 0, 0, 0))
image((as.matrix(patientgendercolors[order(patientgendercolors)][patientgendercolors[order(patientgendercolors)] == 2][order(patientcolors[order(patientgendercolors)][patientgendercolors[order(patientgendercolors)] == 2])])),col=c("pink"),axes=F)
box(lwd=2)
screen(5)
par(mar = c(0, 0, 0, 0))
image((as.matrix(patientcolors[order(patientgendercolors)][patientgendercolors[order(patientgendercolors)] == 2][order(patientcolors[order(patientgendercolors)][patientgendercolors[order(patientgendercolors)] == 2])])),col=c("red","gray"),axes=F)
box(lwd=2)
screen(6)
par(mar = c(0, 0, 0, 0))
barplot(colSums(mergedata[,order(patientgendercolors)][patientgendercolors[order(patientgendercolors)] == 2][order(patientcolors[order(patientgendercolors)][patientgendercolors[order(patientgendercolors)] == 2])]),space=0,xaxt='n')
screen(7)
par(mar = c(0, 0, 0, 0))
barplot(t(studyperdata),col=c("orange","green","blue"),space=0,horiz=T,yaxt='n',xaxt='n')
screen(8)
par(mar = c(0, 0, 0, 0))
barplot(t(smokerper),col=c("red","gray"),space=0,horiz=T,yaxt='n',xaxt='n')
screen(9)
par(mar = c(0, 0, 0, 0))
barplot(t(raceperdata),col=c("yellow","white","black"),space=0,horiz=T,yaxt='n',xaxt='n')
screen(10)
par(mar = c(0, 0, 0, 0))
legend(x=0.1,y=1,c("lung100","TCGA luad","TCGA lusc","smoker","non smoker","asian","white","black","male","female"),col=c("orange","green","blue","red","gray","yellow","white","black","brown","pink"),cex=3,horiz=F,pch=15, bty="n")
dev.off()






########################################################################.
#sort by gender

mergedata=smokedata


for(i in 1:length(colnames(mergedata))){
  if(grepl("Pat",colnames(mergedata)[i]) == 1){
    mergedata[which(mergedata[,i]!=0),i] = 2
  }
  for(j in 1:length(rownames(tcgalist1))){
    if(colnames(mergedata)[i] == rownames(tcgalist1)[j]){
      if(tcgalist1[j,1] == 'MALE'){
        mergedata[which(mergedata[,i]!=0),i] = 1
      }
      else{
        mergedata[which(mergedata[,i]!=0),i] = 2
      }
    }
  }
  for(j in 1:length(rownames(tcgalist2))){
    if(colnames(mergedata)[i] == rownames(tcgalist2)[j]){
      if(tcgalist2[j,1] == 'MALE'){
        mergedata[which(mergedata[,i]!=0),i] = 1
      }
      else{
        mergedata[which(mergedata[,i]!=0),i] = 2
      }
    }
  }
}

####################################################3
# all

mer = (as.matrix(smokedata[geneoreder,order(patientgendercolors)]))

#mergedata -> 1: smoke, 2: non-smoke

smokepe = cbind(rowSums(mer[,which(patientcolors[order(patientgendercolors)] == 1)]), rowSums(mer[,which(patientcolors[order(patientgendercolors)] == 2)]))
smokerper = smokepe/rowSums(smokepe)

raceper = cbind(rowSums(mer[,patientracecolor[order(patientgendercolors)] == 1]), rowSums(mer[,patientracecolor[order(patientgendercolors)] == 2]), rowSums(mer[,patientracecolor[order(patientgendercolors)] == 3]))
raceperdata = raceper/rowSums(raceper)

studyper = cbind(rowSums(mer[,patientstudycolor[order(patientgendercolors)]==1]),rowSums(mer[,patientstudycolor[order(patientgendercolors)]==2]),rowSums(mer[,patientstudycolor[order(patientgendercolors)]==3]))
studyperdata = studyper/rowSums(studyper)

png("sort_by_gender.png",width = 3000, height = 2000)
split.screen(rbind(c(0.1,0.70,0.15, 0.80),c(0.1,0.7,0.805,0.815),c(0.1,0.7,0.815,0.825),c(0.1,0.7,0.825,0.835),c(0.1,0.7,0.835,0.845),c(0.0725,0.7275,0.845,0.875),c(0.705,0.745,0.125,0.825),c(0.745,0.785,0.125,0.825),c(0.785,0.825,0.125,0.825),c(0.825,0.99,0.1,0.94)))
screen(1)
par(mar = c(0, 0, 0, 0))
image(t(as.matrix(mergedata[geneoreder,order(patientgendercolors)])),axes=F,col=c("white","brown","pink"))
grid(ncol(mergedata),nrow(mergedata),col="black",lty=1,lwd=1)
box(lwd=2)
axis(2,at=c(seq(0,1,by=(1/(length(mergedata[,1])-1)))),lab=c(row.names(mergedata[geneoreder,order(patientgendercolors)])),las=1)
axis(1,at=c(seq(0,1,by=(1/(length(mergedata[1,])-1)))),lab=c(colnames(mergedata[geneoreder,order(patientgendercolors)])),las=2)
#text(seq(0,1,by=(1/(length(mergedata[1,])-1))),par("usr")[3]-.5,,labels=c(xname,list),srt=45,pos=1,xpd=TRUE,cex=1)
screen(2)
par(mar = c(0, 0, 0, 0))
image(as.matrix(patientstudycolor[order(patientgendercolors)]),col=c("orange","green","blue"),axes=F)
box(lwd=2)
screen(3)
par(mar = c(0, 0, 0, 0))
image(as.matrix(patientracecolor[order(patientgendercolors)]),col=c("yellow","white","black"),axes=F)
box(lwd=2)
screen(4)
par(mar = c(0, 0, 0, 0))
image((as.matrix(patientgendercolors[order(patientgendercolors)])),col=c("brown","pink"),axes=F)
box(lwd=2)
screen(5)
par(mar = c(0, 0, 0, 0))
image((as.matrix(patientcolors[order(patientgendercolors)])),col=c("red","gray"),axes=F)
screen(6)
par(mar = c(0, 0, 0, 0))
barplot(colSums(mergedata[,order(patientgendercolors)]),space=0,xaxt='n')
screen(7)
par(mar = c(0, 0, 0, 0))
barplot(t(studyperdata),col=c("orange","green","blue"),space=0,horiz=T,yaxt='n',xaxt='n')
screen(8)
par(mar = c(0, 0, 0, 0))
barplot(t(smokerper),col=c("red","gray"),space=0,horiz=T,yaxt='n',xaxt='n')
screen(9)
par(mar = c(0, 0, 0, 0))
barplot(t(raceperdata),col=c("yellow","white","black"),space=0,horiz=T,yaxt='n',xaxt='n')
screen(10)
par(mar = c(0, 0, 0, 0))
legend(x=0.1,y=1,c("lung100","TCGA luad","TCGA lusc","smoker","non smoker","asian","white","black","male","female"),col=c("orange","green","blue","red","gray","yellow","white","black","brown","pink"),cex=3,horiz=F,pch=15, bty="n")
dev.off()


############################################################################################################################################3
#sort by race

mergedata=smokedata


for(i in 1:length(colnames(mergedata))){
  if(grepl("Pat",colnames(mergedata)[i]) == 1){
    mergedata[which(mergedata[,i]!=0),i] = 1
  }
  for(j in 1:length(rownames(tcgalist1))){
    if(colnames(mergedata)[i] == rownames(tcgalist1)[j]){
      if(tcgalist1[j,3] == 'ASIAN'){
        mergedata[which(mergedata[,i]!=0),i] = 1
      }
      else if(tcgalist1[j,3] == 'WHITE'){
        mergedata[which(mergedata[,i]!=0),i] = 2
      }
      else{
        mergedata[which(mergedata[,i]!=0),i] = 3
      }
    }
  }
  for(j in 1:length(rownames(tcgalist2))){
    if(colnames(mergedata)[i] == rownames(tcgalist2)[j]){
      if(tcgalist2[j,3] == 'ASIAN'){
        mergedata[which(mergedata[,i]!=0),i] = 1
      }
      else if(tcgalist2[j,3] == 'WHITE'){
        mergedata[which(mergedata[,i]!=0),i] = 2
      }
      else{
        mergedata[which(mergedata[,i]!=0),i] = 3
      }
    }
  }
}

#######################################################
# all 

mer = (as.matrix(smokedata[geneoreder,order(patientracecolor)]))

#mergedata -> 1: smoke, 2: non-smoke

smokepe = cbind(rowSums(mer[,which(patientcolors[order(patientracecolor)] == 1)]), rowSums(mer[,which(patientcolors[order(patientracecolor)] == 2)]))
smokerper = smokepe/rowSums(smokepe)

raceper = cbind(rowSums(mer[,patientracecolor[order(patientracecolor)] == 1]), rowSums(mer[,patientracecolor[order(patientracecolor)] == 2]), rowSums(mer[,patientracecolor[order(patientracecolor)] == 3]))
raceperdata = raceper/rowSums(raceper)

studyper = cbind(rowSums(mer[,patientstudycolor[order(patientracecolor)]==1]),rowSums(mer[,patientstudycolor[order(patientracecolor)]==2]),rowSums(mer[,patientstudycolor[order(patientracecolor)]==3]))
studyperdata = studyper/rowSums(studyper)

png("sort_by_race.png",width = 3000, height = 2000)
split.screen(rbind(c(0.1,0.70,0.15, 0.80),c(0.1,0.7,0.805,0.815),c(0.1,0.7,0.815,0.825),c(0.1,0.7,0.825,0.835),c(0.1,0.7,0.835,0.845),c(0.0725,0.7275,0.845,0.875),c(0.705,0.745,0.125,0.825),c(0.745,0.785,0.125,0.825),c(0.785,0.825,0.125,0.825),c(0.825,0.99,0.1,0.94)))
screen(1)
par(mar = c(0, 0, 0, 0))
image(t(as.matrix(mergedata[geneoreder,order(patientracecolor)])),axes=F,col=c("gray","yellow","white","black"))
grid(ncol(mergedata),nrow(mergedata),col="black",lty=1,lwd=1)
box(lwd=2)
axis(2,at=c(seq(0,1,by=(1/(length(mergedata[,1])-1)))),lab=c(row.names(mergedata[geneoreder,order(patientracecolor)])),las=1)
axis(1,at=c(seq(0,1,by=(1/(length(mergedata[1,])-1)))),lab=c(colnames(mergedata[geneoreder,order(patientracecolor)])),las=2)
#text(seq(0,1,by=(1/(length(mergedata[1,])-1))),par("usr")[3]-.5,,labels=c(xname,list),srt=45,pos=1,xpd=TRUE,cex=1)
screen(2)
par(mar = c(0, 0, 0, 0))
image(as.matrix(patientstudycolor[order(patientracecolor)]),col=c("orange","green","blue"),axes=F)
box(lwd=2)
screen(3)
par(mar = c(0, 0, 0, 0))
image(as.matrix(patientracecolor[order(patientracecolor)]),col=c("yellow","white","black"),axes=F)
box(lwd=2)
screen(4)
par(mar = c(0, 0, 0, 0))
image((as.matrix(patientgendercolors[order(patientracecolor)])),col=c("brown","pink"),axes=F)
box(lwd=2)
screen(5)
par(mar = c(0, 0, 0, 0))
image((as.matrix(patientcolors[order(patientracecolor)])),col=c("red","gray"),axes=F)
screen(6)
par(mar = c(0, 0, 0, 0))
barplot(colSums(mergedata[,order(patientracecolor)]),space=0,xaxt='n')
screen(7)
par(mar = c(0, 0, 0, 0))
barplot(t(studyperdata),col=c("orange","green","blue"),space=0,horiz=T,yaxt='n',xaxt='n')
screen(8)
par(mar = c(0, 0, 0, 0))
barplot(t(smokerper),col=c("red","gray"),space=0,horiz=T,yaxt='n',xaxt='n')
screen(9)
par(mar = c(0, 0, 0, 0))
barplot(t(raceperdata),col=c("yellow","white","black"),space=0,horiz=T,yaxt='n',xaxt='n')
screen(10)
par(mar = c(0, 0, 0, 0))
legend(x=0.1,y=1,c("lung100","TCGA luad","TCGA lusc","smoker","non smoker","asian","white","black","male","female"),col=c("orange","green","blue","red","gray","yellow","white","black","brown","pink"),cex=3,horiz=F,pch=15, bty="n")
dev.off()


######################################################################3
#sort by datadet

mergedata=smokedata


for(i in 1:length(colnames(mergedata))){
  if(grepl("Pat",colnames(mergedata)[i]) == 1){
    mergedata[which(mergedata[,i]!=0),i] = 1
  }
  for(j in 1:length(rownames(tcgalist1))){
    if(colnames(mergedata)[i] == rownames(tcgalist1)[j]){
      mergedata[which(mergedata[,i]!=0),i] = 2
    }
  }
  for(j in 1:length(rownames(tcgalist2))){
    if(colnames(mergedata)[i] == rownames(tcgalist2)[j]){
        mergedata[which(mergedata[,i]!=0),i] = 3
    }
  }
}

##########################################################################3
#sort by dataset _ all


mer = (as.matrix(smokedata[geneoreder,order(patientstudycolor)]))

#mergedata -> 1: smoke, 2: non-smoke

smokepe = cbind(rowSums(mer[,which(patientcolors[order(patientstudycolor)] == 1)]), rowSums(mer[,which(patientcolors[order(patientstudycolor)] == 2)]))
smokerper = smokepe/rowSums(smokepe)

raceper = cbind(rowSums(mer[,patientracecolor[order(patientstudycolor)] == 1]), rowSums(mer[,patientracecolor[order(patientstudycolor)] == 2]), rowSums(mer[,patientracecolor[order(patientstudycolor)] == 3]))
raceperdata = raceper/rowSums(raceper)

studyper = cbind(rowSums(mer[,patientstudycolor[order(patientstudycolor)]==1]),rowSums(mer[,patientstudycolor[order(patientstudycolor)]==2]),rowSums(mer[,patientstudycolor[order(patientstudycolor)]==3]))
studyperdata = studyper/rowSums(studyper)

png("sort_by_dataset.png",width = 3000, height = 2000)
split.screen(rbind(c(0.1,0.70,0.15, 0.80),c(0.1,0.7,0.805,0.815),c(0.1,0.7,0.815,0.825),c(0.1,0.7,0.825,0.835),c(0.1,0.7,0.835,0.845),c(0.0725,0.7275,0.845,0.875),c(0.705,0.745,0.125,0.825),c(0.745,0.785,0.125,0.825),c(0.785,0.825,0.125,0.825),c(0.825,0.99,0.1,0.94)))
screen(1)
par(mar = c(0, 0, 0, 0))
image(t(as.matrix(mergedata[geneoreder,order(patientstudycolor)])),axes=F,col=c("white","orange","green","blue"))
grid(ncol(mergedata),nrow(mergedata),col="black",lty=1,lwd=1)
box(lwd=2)
axis(2,at=c(seq(0,1,by=(1/(length(mergedata[,1])-1)))),lab=c(row.names(mergedata[geneoreder,order(patientstudycolor)])),las=1)
axis(1,at=c(seq(0,1,by=(1/(length(mergedata[1,])-1)))),lab=c(colnames(mergedata[geneoreder,order(patientstudycolor)])),las=2)
#text(seq(0,1,by=(1/(length(mergedata[1,])-1))),par("usr")[3]-.5,,labels=c(xname,list),srt=45,pos=1,xpd=TRUE,cex=1)
screen(2)
par(mar = c(0, 0, 0, 0))
image(as.matrix(patientstudycolor[order(patientstudycolor)]),col=c("orange","green","blue"),axes=F)
box(lwd=2)
screen(3)
par(mar = c(0, 0, 0, 0))
image(as.matrix(patientracecolor[order(patientstudycolor)]),col=c("yellow","white","black"),axes=F)
box(lwd=2)
screen(4)
par(mar = c(0, 0, 0, 0))
image((as.matrix(patientgendercolors[order(patientstudycolor)])),col=c("brown","pink"),axes=F)
box(lwd=2)
screen(5)
par(mar = c(0, 0, 0, 0))
image((as.matrix(patientcolors[order(patientstudycolor)])),col=c("red","gray"),axes=F)
screen(6)
par(mar = c(0, 0, 0, 0))
barplot(colSums(mergedata[,order(patientstudycolor)]),space=0,xaxt='n')
screen(7)
par(mar = c(0, 0, 0, 0))
barplot(t(studyperdata),col=c("orange","green","blue"),space=0,horiz=T,yaxt='n',xaxt='n')
screen(8)
par(mar = c(0, 0, 0, 0))
barplot(t(smokerper),col=c("red","gray"),space=0,horiz=T,yaxt='n',xaxt='n')
screen(9)
par(mar = c(0, 0, 0, 0))
barplot(t(raceperdata),col=c("yellow","white","black"),space=0,horiz=T,yaxt='n',xaxt='n')
screen(10)
par(mar = c(0, 0, 0, 0))
legend(x=0.1,y=1,c("lung100","TCGA luad","TCGA lusc","smoker","non smoker","asian","white","black","male","female"),col=c("orange","green","blue","red","gray","yellow","white","black","brown","pink"),cex=3,horiz=F,pch=15, bty="n")
dev.off()


##########################################################################3
# sort by datset _ asian

mer = (as.matrix(smokedata[geneoreder,order(patientracecolor)][,patientracecolor[order(patientracecolor)] == 1]))
#patientracecolor로 정렬하고 나서 asian만 고르기 
#mergedata -> 1: smoke, 2: non-smoke

smokepe = cbind(rowSums(mer[,which(patientcolors[order(patientracecolor)][patientracecolor[order(patientracecolor)] == 1] == 1)]),rowSums(mer[,which(patientcolors[order(patientracecolor)][patientracecolor[order(patientracecolor)] == 1] == 2)]))
smokerper = smokepe/rowSums(smokepe)

raceper = cbind(rowSums(mer[,patientracecolor[order(patientracecolor)][patientracecolor[order(patientracecolor)] == 1] == 1]), rowSums(mer[,patientracecolor[order(patientracecolor)][patientracecolor[order(patientracecolor)] == 1] == 2]), rowSums(mer[,patientracecolor[order(patientracecolor)][patientracecolor[order(patientracecolor)] == 1] == 3]))
raceperdata = raceper/rowSums(raceper)

studyper = cbind(rowSums(mer[,patientstudycolor[order(patientracecolor)][patientracecolor[order(patientracecolor)] == 1]==1]),rowSums(mer[,patientstudycolor[order(patientracecolor)][patientracecolor[order(patientracecolor)] == 1]==2]),rowSums(mer[,patientstudycolor[order(patientracecolor)][patientracecolor[order(patientracecolor)] == 1]==3]))
studyperdata = studyper/rowSums(studyper)

sortdata = mergedata[geneoreder,order(patientracecolor)][,patientracecolor[order(patientracecolor)] == 1][order(patientstudycolor[order(patientracecolor)][patientracecolor[order(patientracecolor)] == 1])]

png("asian_only_sort_by_dataset.png",width = 3000, height = 2000)
split.screen(rbind(c(0.1,0.70,0.15, 0.80),c(0.1,0.7,0.805,0.815),c(0.1,0.7,0.815,0.825),c(0.1,0.7,0.825,0.835),c(0.1,0.7,0.835,0.845),c(0.0725,0.7275,0.845,0.875),c(0.705,0.745,0.125,0.825),c(0.745,0.785,0.125,0.825),c(0.785,0.825,0.125,0.825),c(0.825,0.99,0.1,0.94)))
screen(1)
par(mar = c(0, 0, 0, 0))
image(t(as.matrix(sortdata)),axes=F,col=c("white","orange","green","blue"))
grid(ncol(mergedata),nrow(mergedata),col="black",lty=1,lwd=1)
box(lwd=2)
axis(2,at=c(seq(0,1,by=(1/(length(sortdata[,1])-1)))),lab=c(row.names(sortdata)),las=1)
axis(1,at=c(seq(0,1,by=(1/(length(sortdata[1,])-1)))),lab=c(colnames(sortdata)),las=2)
#text(seq(0,1,by=(1/(length(mergedata[1,])-1))),par("usr")[3]-.5,,labels=c(xname,list),srt=45,pos=1,xpd=TRUE,cex=1)
screen(2)
par(mar = c(0, 0, 0, 0))
image(as.matrix(patientstudycolor[order(patientracecolor)][patientracecolor[order(patientracecolor)] == 1][order(patientstudycolor[order(patientracecolor)][patientracecolor[order(patientracecolor)] == 1])]),col=c("orange","green","blue"),axes=F)
box(lwd=2)
screen(3)
par(mar = c(0, 0, 0, 0))
image(as.matrix(patientracecolor[order(patientracecolor)][patientracecolor[order(patientracecolor)] == 1][order(patientstudycolor[order(patientracecolor)][patientracecolor[order(patientracecolor)] == 1])]),col=c("yellow"),axes=F)
box(lwd=2)
screen(4)
par(mar = c(0, 0, 0, 0))
image((as.matrix(patientgendercolors[order(patientracecolor)][patientracecolor[order(patientracecolor)] == 1][order(patientstudycolor[order(patientracecolor)][patientracecolor[order(patientracecolor)] == 1])])),col=c("brown","pink"),axes=F)
box(lwd=2)
screen(5)
par(mar = c(0, 0, 0, 0))
image((as.matrix(patientcolors[order(patientracecolor)][patientracecolor[order(patientracecolor)] == 1][order(patientstudycolor[order(patientracecolor)][patientracecolor[order(patientracecolor)] == 1])])),col=c("red","gray"),axes=F)
box(lwd=2)
screen(6)
par(mar = c(0, 0, 0, 0))
barplot(colSums(mergedata[,order(patientracecolor)][patientracecolor[order(patientracecolor)] == 1][order(patientstudycolor[order(patientracecolor)][patientracecolor[order(patientracecolor)] == 1])]),space=0,xaxt='n')
screen(7)
par(mar = c(0, 0, 0, 0))
barplot(t(studyperdata),col=c("orange","green","blue"),space=0,horiz=T,yaxt='n',xaxt='n')
screen(8)
par(mar = c(0, 0, 0, 0))
barplot(t(smokerper),col=c("red","gray"),space=0,horiz=T,yaxt='n',xaxt='n')
screen(9)
par(mar = c(0, 0, 0, 0))
barplot(t(raceperdata),col=c("yellow","white","black"),space=0,horiz=T,yaxt='n',xaxt='n')
screen(10)
par(mar = c(0, 0, 0, 0))
legend(x=0.1,y=1,c("lung100","TCGA luad","TCGA lusc","smoker","non smoker","asian","white","black","male","female"),col=c("orange","green","blue","red","gray","yellow","white","black","brown","pink"),cex=3,horiz=F,pch=15, bty="n")
dev.off()



################################################################################
#sort by dataset _ female

mer = (as.matrix(smokedata[geneoreder,order(patientgendercolors)][,patientgendercolors[order(patientgendercolors)] == 2]))

#mergedata -> 1: smoke, 2: non-smoke

smokepe = cbind(rowSums(mer[,which(patientcolors[order(patientgendercolors)][patientgendercolors[order(patientgendercolors)] == 2] == 1)]),rowSums(mer[,which(patientcolors[order(patientgendercolors)][patientgendercolors[order(patientgendercolors)] == 2] == 2)]))
smokerper = smokepe/rowSums(smokepe)

raceper = cbind(rowSums(mer[,patientracecolor[order(patientgendercolors)][patientgendercolors[order(patientgendercolors)] == 2] == 1]), rowSums(mer[,patientracecolor[order(patientgendercolors)][patientgendercolors[order(patientgendercolors)] == 2] == 2]), rowSums(mer[,patientracecolor[order(patientgendercolors)][patientgendercolors[order(patientgendercolors)] == 2] == 3]))
raceperdata = raceper/rowSums(raceper)

studyper = cbind(rowSums(mer[,patientstudycolor[order(patientgendercolors)][patientgendercolors[order(patientgendercolors)] == 2]==1]),rowSums(mer[,patientstudycolor[order(patientgendercolors)][patientgendercolors[order(patientgendercolors)] == 2]==2]),rowSums(mer[,patientstudycolor[order(patientgendercolors)][patientgendercolors[order(patientgendercolors)] == 2]==3]))
studyperdata = studyper/rowSums(studyper)

sortdata = as.matrix(mergedata[geneoreder,order(patientgendercolors)])[,patientgendercolors[order(patientgendercolors)] == 2][,order(patientstudycolor[order(patientgendercolors)][patientgendercolors[order(patientgendercolors)] == 2])]


png("female_only_sort_by_dataset.png",width = 3000, height = 2000)
split.screen(rbind(c(0.1,0.70,0.15, 0.80),c(0.1,0.7,0.805,0.815),c(0.1,0.7,0.815,0.825),c(0.1,0.7,0.825,0.835),c(0.1,0.7,0.835,0.845),c(0.0725,0.7275,0.845,0.875),c(0.705,0.745,0.125,0.825),c(0.745,0.785,0.125,0.825),c(0.785,0.825,0.125,0.825),c(0.825,0.99,0.1,0.94)))
screen(1)
par(mar = c(0, 0, 0, 0))
image(t(sortdata),axes=F,col=c("white","orange","green","blue"))
grid(ncol(sortdata),nrow(sortdata),col="black",lty=1,lwd=1)
box(lwd=2)
axis(2,at=c(seq(0,1,by=(1/(length(sortdata[,1])-1)))),lab=c(row.names(sortdata)),las=1)
axis(1,at=c(seq(0,1,by=(1/(length(colnames(sortdata))-1)))),lab=c(colnames(sortdata)),las=2)
#text(seq(0,1,by=(1/(length(mergedata[1,])-1))),par("usr")[3]-.5,,labels=c(xname,list),srt=45,pos=1,xpd=TRUE,cex=1)
screen(2)
par(mar = c(0, 0, 0, 0))
image(as.matrix(patientstudycolor[order(patientgendercolors)][patientgendercolors[order(patientgendercolors)] == 2][order(patientstudycolor[order(patientgendercolors)][patientgendercolors[order(patientgendercolors)] == 2])]),col=c("orange","green","blue"),axes=F)
box(lwd=2)
screen(3)
par(mar = c(0, 0, 0, 0))
image(as.matrix(patientracecolor[order(patientgendercolors)][patientgendercolors[order(patientgendercolors)] == 2][order(patientstudycolor[order(patientgendercolors)][patientgendercolors[order(patientgendercolors)] == 2])]),col=c("yellow","white","black"),axes=F)
box(lwd=2)
screen(4)
par(mar = c(0, 0, 0, 0))
image((as.matrix(patientgendercolors[order(patientgendercolors)][patientgendercolors[order(patientgendercolors)] == 2][order(patientstudycolor[order(patientgendercolors)][patientgendercolors[order(patientgendercolors)] == 2])])),col=c("pink"),axes=F)
box(lwd=2)
screen(5)
par(mar = c(0, 0, 0, 0))
image((as.matrix(patientcolors[order(patientgendercolors)][patientgendercolors[order(patientgendercolors)] == 2][order(patientstudycolor[order(patientgendercolors)][patientgendercolors[order(patientgendercolors)] == 2])])),col=c("red","gray"),axes=F)
box(lwd=2)
screen(6)
par(mar = c(0, 0, 0, 0))
barplot(colSums(mergedata[,order(patientgendercolors)][patientgendercolors[order(patientgendercolors)] == 2][order(patientstudycolor[order(patientgendercolors)][patientgendercolors[order(patientgendercolors)] == 2])]),space=0,xaxt='n')
screen(7)
par(mar = c(0, 0, 0, 0))
barplot(t(studyperdata),col=c("orange","green","blue"),space=0,horiz=T,yaxt='n',xaxt='n')
screen(8)
par(mar = c(0, 0, 0, 0))
barplot(t(smokerper),col=c("red","gray"),space=0,horiz=T,yaxt='n',xaxt='n')
screen(9)
par(mar = c(0, 0, 0, 0))
barplot(t(raceperdata),col=c("yellow","white","black"),space=0,horiz=T,yaxt='n',xaxt='n')
screen(10)
par(mar = c(0, 0, 0, 0))
legend(x=0.1,y=1,c("lung100","TCGA luad","TCGA lusc","smoker","non smoker","asian","white","black","male","female"),col=c("orange","green","blue","red","gray","yellow","white","black","brown","pink"),cex=3,horiz=F,pch=15, bty="n")
dev.off()



##################################################################
#sort by dataset _ non smoker

mer = (as.matrix(smokedata[geneoreder,order(patientcolors)][,patientcolors[order(patientcolors)] == 2]))

#mergedata -> 1: smoke, 2: non-smoke

smokepe = (rowSums(mer[,which(patientcolors[order(patientcolors)][patientcolors[order(patientcolors)] == 2] == 2)]))
smokerper = smokepe/(smokepe)

raceper = cbind(rowSums(mer[,which(patientracecolor[order(patientcolors)][patientcolors[order(patientcolors)] == 2] == 1)]), rowSums(mer[,which(patientracecolor[order(patientcolors)][patientcolors[order(patientcolors)] == 2] == 2)]),(mer[,which(patientracecolor[order(patientcolors)][patientcolors[order(patientcolors)] == 2] == 3)]))
raceperdata = raceper/rowSums(raceper)

studyper = cbind(rowSums(mer[,(patientstudycolor[order(patientcolors)][patientcolors[order(patientcolors)] == 2]==1)]),rowSums(mer[,(patientstudycolor[order(patientcolors)][patientcolors[order(patientcolors)] == 2]==2)]),(mer[,(patientstudycolor[order(patientcolors)][patientcolors[order(patientcolors)] == 2] == 3)]))
studyperdata = studyper/rowSums(studyper)

sortdata= (as.matrix(mergedata[geneoreder,order(patientcolors)])[,patientcolors[order(patientcolors)] == 2])[,order(patientstudycolor[order(patientcolors)][patientcolors[order(patientcolors)] == 2])]

png("non_smoke_only_sort_by_dataset.png",width = 3000, height = 2000)
split.screen(rbind(c(0.1,0.70,0.15, 0.80),c(0.1,0.7,0.805,0.815),c(0.1,0.7,0.815,0.825),c(0.1,0.7,0.825,0.835),c(0.1,0.7,0.835,0.845),c(0.0725,0.7275,0.845,0.875),c(0.705,0.745,0.125,0.825),c(0.745,0.785,0.125,0.825),c(0.785,0.825,0.125,0.825),c(0.825,0.99,0.1,0.94)))
screen(1)
par(mar = c(0, 0, 0, 0))
image(t(sortdata),axes=F,col=c("white","orange","green","blue"))
grid(ncol(mergedata),nrow(mergedata),col="black",lty=1,lwd=1)
box(lwd=2)
axis(2,at=c(seq(0,1,by=(1/(length(sortdata[,1])-1)))),lab=c(row.names(sortdata)),las=1)
axis(1,at=c(seq(0,1,by=(1/(length(sortdata[1,])-1)))),lab=c(colnames(sortdata)),las=2)
#text(seq(0,1,by=(1/(length(mergedata[1,])-1))),par("usr")[3]-.5,,labels=c(xname,list),srt=45,pos=1,xpd=TRUE,cex=1)
screen(2)
par(mar = c(0, 0, 0, 0))
image(as.matrix(patientstudycolor[order(patientcolors)][patientcolors[order(patientcolors)] == 2][order(patientstudycolor[order(patientcolors)][patientcolors[order(patientcolors)] == 2])]),col=c("orange","green","blue"),axes=F)
box(lwd=2)
screen(3)
par(mar = c(0, 0, 0, 0))
image(as.matrix(patientracecolor[order(patientcolors)][patientcolors[order(patientcolors)] == 2][order(patientstudycolor[order(patientcolors)][patientcolors[order(patientcolors)] == 2])]),col=c("yellow","white","black"),axes=F)
box(lwd=2)
screen(4)
par(mar = c(0, 0, 0, 0))
image((as.matrix(patientgendercolors[order(patientcolors)][patientcolors[order(patientcolors)] == 2][order(patientstudycolor[order(patientcolors)][patientcolors[order(patientcolors)] == 2])])),col=c("brown","pink"),axes=F)
box(lwd=2)
screen(5)
par(mar = c(0, 0, 0, 0))
image((as.matrix(patientcolors[order(patientcolors)][patientcolors[order(patientcolors)] == 2][order(patientstudycolor[order(patientcolors)][patientcolors[order(patientcolors)] == 2])])),col=c("gray"),axes=F)
box(lwd=2)
screen(6)
par(mar = c(0, 0, 0, 0))
barplot(colSums(mergedata[,order(patientcolors)][patientcolors[order(patientcolors)] == 2][order(patientstudycolor[order(patientcolors)][patientcolors[order(patientcolors)] == 2])]),space=0,xaxt='n')
screen(7)
par(mar = c(0, 0, 0, 0))
barplot(t(studyperdata),col=c("orange","green","blue"),space=0,horiz=T,yaxt='n',xaxt='n')
screen(8)
par(mar = c(0, 0, 0, 0))
barplot(t(smokerper),col=c("gray"),space=0,horiz=T,yaxt='n',xaxt='n')
screen(9)
par(mar = c(0, 0, 0, 0))
barplot(t(raceperdata),col=c("yellow","white","black"),space=0,horiz=T,yaxt='n',xaxt='n')
screen(10)
par(mar = c(0, 0, 0, 0))
legend(x=0.1,y=1,c("lung100","TCGA luad","TCGA lusc","smoker","non smoker","asian","white","black","male","female"),col=c("orange","green","blue","red","gray","yellow","white","black","brown","pink"),cex=3,horiz=F,pch=15, bty="n")
dev.off()




###########################################################
#sort by dataset _ smoke only 

mer = (as.matrix(smokedata[geneoreder,order(patientcolors)][,patientcolors[order(patientcolors)] == 1]))

#mergedata -> 1: smoke, 2: non-smoke

smokepe = (rowSums(mer[,which(patientcolors[order(patientcolors)] == 1)]))
smokerper = smokepe/(smokepe)

raceper = cbind(rowSums(mer[,patientracecolor[order(patientcolors)][patientcolors[order(patientcolors)] == 1] == 1]), rowSums(mer[,patientracecolor[order(patientcolors)][patientcolors[order(patientcolors)] == 1] == 2]), rowSums(mer[,patientracecolor[order(patientcolors)][patientcolors[order(patientcolors)] == 1] == 3]))
raceperdata = raceper/rowSums(raceper)

studyper = cbind(rowSums(mer[,patientstudycolor[order(patientcolors)][patientcolors[order(patientcolors)] == 1] == 1]),rowSums(mer[,patientstudycolor[order(patientcolors)][patientcolors[order(patientcolors)] == 1] == 2]),rowSums(mer[,patientstudycolor[order(patientcolors)][patientcolors[order(patientcolors)] == 1]==3]))
studyperdata = studyper/rowSums(studyper)

sortdata = as.matrix(mergedata[geneoreder,order(patientcolors)])[,patientcolors[order(patientcolors)] == 1][,order(patientstudycolor[order(patientcolors)][patientcolors[order(patientcolors)] == 1])]

png("smoke_only_sort_by_dataset.png",width = 3000, height = 2000)
split.screen(rbind(c(0.1,0.70,0.15, 0.80),c(0.1,0.7,0.805,0.815),c(0.1,0.7,0.815,0.825),c(0.1,0.7,0.825,0.835),c(0.1,0.7,0.835,0.845),c(0.0725,0.7275,0.845,0.875),c(0.705,0.745,0.125,0.825),c(0.745,0.785,0.125,0.825),c(0.785,0.825,0.125,0.825),c(0.825,0.99,0.1,0.94)))
screen(1)
par(mar = c(0, 0, 0, 0))
image(t(sortdata),axes=F,col=c("white","orange","green","blue"))
grid(ncol(mergedata),nrow(mergedata),col="black",lty=1,lwd=1)
box(lwd=2)
axis(2,at=c(seq(0,1,by=(1/(length(sortdata[,1])-1)))),lab=c(row.names(sortdata)),las=1)
axis(1,at=c(seq(0,1,by=(1/(length(sortdata[1,])-1)))),lab=c(colnames(sortdata)),las=2)
#text(seq(0,1,by=(1/(length(mergedata[1,])-1))),par("usr")[3]-.5,,labels=c(xname,list),srt=45,pos=1,xpd=TRUE,cex=1)
screen(2)
par(mar = c(0, 0, 0, 0))
image(as.matrix(patientstudycolor[order(patientcolors)][patientcolors[order(patientcolors)] == 1][order(patientstudycolor[order(patientcolors)][patientcolors[order(patientcolors)] == 1])]),col=c("green","blue"),axes=F)
box(lwd=2)
screen(3)
par(mar = c(0, 0, 0, 0))
image(as.matrix(patientracecolor[order(patientcolors)][patientcolors[order(patientcolors)] == 1][order(patientstudycolor[order(patientcolors)][patientcolors[order(patientcolors)] == 1])]),col=c("yellow","white","black"),axes=F)
box(lwd=2)
screen(4)
par(mar = c(0, 0, 0, 0))
image((as.matrix(patientgendercolors[order(patientcolors)][patientcolors[order(patientcolors)] == 1][order(patientstudycolor[order(patientcolors)][patientcolors[order(patientcolors)] == 1])])),col=c("brown","pink"),axes=F)
box(lwd=2)
screen(5)
par(mar = c(0, 0, 0, 0))
image((as.matrix(patientcolors[order(patientcolors)][patientcolors[order(patientcolors)] == 1][order(patientstudycolor[order(patientcolors)][patientcolors[order(patientcolors)] == 1])])),col=c("red","gray"),axes=F)
box(lwd=2)
screen(6)
par(mar = c(0, 0, 0, 0))
barplot(colSums(mergedata[,order(patientcolors)][patientcolors[order(patientcolors)] == 1][order(patientstudycolor[order(patientcolors)][patientcolors[order(patientcolors)] == 1])]),space=0,xaxt='n')
screen(7)
par(mar = c(0, 0, 0, 0))
barplot(t(studyperdata),col=c("white","green","blue"),space=0,horiz=T,yaxt='n',xaxt='n')
screen(8)
par(mar = c(0, 0, 0, 0))
barplot(t(smokerper),col=c("red","gray"),space=0,horiz=T,yaxt='n',xaxt='n')
screen(9)
par(mar = c(0, 0, 0, 0))
barplot(t(raceperdata),col=c("yellow","white","black"),space=0,horiz=T,yaxt='n',xaxt='n')
screen(10)
par(mar = c(0, 0, 0, 0))
legend(x=0.1,y=1,c("lung100","TCGA luad","TCGA lusc","smoker","non smoker","asian","white","black","male","female"),col=c("orange","green","blue","red","gray","yellow","white","black","brown","pink"),cex=3,horiz=F,pch=15, bty="n")
dev.off()




write.table(row.names(mergedata),file="genelist.txt",row.names=F,quote=F,col.names=F)





mut_matrix <- functionz(smokedata,mergedata,geneoreder,mutorder){
  mer = (as.matrix(smokedata[geneoreder,order(mutorder)]))
  smokepe = cbind(rowSums(mer[,which(patientcolors[order(mutorder)] == 1)]), rowSums(mer[,which(patientcolors[order(mutorder)] == 2)]))
  smokerper = smokepe/rowSums(smokepe)
  raceper = cbind(rowSums(mer[,patientracecolor[order(mutorder)] == 1]), rowSums(mer[,patientracecolor[order(mutorder)] == 2]), rowSums(mer[,patientracecolor[order(mutorder)] == 3]))
  raceperdata = raceper/rowSums(raceper)
  studyper = cbind(rowSums(mer[,patientstudycolor[order(mutorder)]==1]),rowSums(mer[,patientstudycolor[order(mutorder)]==2]),rowSums(mer[,patientstudycolor[order(mutorder)]==3]))
  studyperdata = studyper/rowSums(studyper)
  genddata = cbind(rowSums(mer[,patientgendercolors[order(mutorder)]==1]),rowSums(mer[,patientgendercolors[order(mutorder)]==2]))
  genderdata = genddata/rowSums(genddata)
  split.screen(rbind(c(0.1,0.70,0.15, 0.80),c(0.1,0.7,0.805,0.815),c(0.1,0.7,0.815,0.825),c(0.1,0.7,0.825,0.835),c(0.1,0.7,0.835,0.845),c(0.075,0.725,0.845,0.875),c(0.705,0.735,0.125,0.825),c(0.735,0.765,0.125,0.825),c(0.765,0.795,0.125,0.825),c(0.795,0.825,0.125,0.825),c(0.825,0.99,0.1,0.94)))
  screen(1)
  par(mar = c(0, 0, 0, 0))
  image(t(as.matrix(mergedata[geneoreder,order(mutorder)])),axes=F,col=c("white","red","gray"))
  grid(ncol(mergedata),nrow(mergedata),col="black",lty=1,lwd=1)
  box(lwd=2)
  axis(2,at=c(seq(0,1,by=(1/(length(mergedata[,1])-1)))),lab=c(row.names(mergedata[geneoreder,order(mutorder)])),las=1)
  axis(1,at=c(seq(0,1,by=(1/(length(mergedata[1,])-1)))),lab=c(colnames(mergedata[geneoreder,order(mutorder)])),las=2)
  #text(seq(0,1,by=(1/(length(mergedata[1,])-1))),par("usr")[3]-.5,,labels=c(xname,list),srt=45,pos=1,xpd=TRUE,cex=1)
  screen(2)
  par(mar = c(0, 0, 0, 0))
  image(as.matrix(patientstudycolor[order(mutorder)]),col=c("orange","green","blue"),axes=F)
  box(lwd=2)
  screen(3)
  par(mar = c(0, 0, 0, 0))
  image(as.matrix(patientracecolor[order(mutorder)]),col=c("yellow","white","black"),axes=F)
  box(lwd=2)
  screen(4)
  par(mar = c(0, 0, 0, 0))
  image((as.matrix(patientgendercolors[order(mutorder)])),col=c("brown","pink"),axes=F)
  box(lwd=2)
  screen(5)
  par(mar = c(0, 0, 0, 0))
  image((as.matrix(patientcolors[order(mutorder)])),col=c("red","gray"),axes=F)
  box(lwd=2)
  screen(6)
  par(mar = c(0, 0, 0, 0))
  barplot(colSums(mergedata[,order(mutorder)]),space=0,xaxt='n')
  screen(7)
  par(mar = c(0, 0, 0, 0))
  barplot(t(studyperdata),col=c("orange","green","blue"),space=0,horiz=T,yaxt='n',xaxt='n')
  screen(8)
  par(mar = c(0, 0, 0, 0))
  barplot(t(smokerper),col=c("red","gray"),space=0,horiz=T,yaxt='n',xaxt='n')
  screen(9)
  par(mar = c(0, 0, 0, 0))
  barplot(t(raceperdata),col=c("yellow","white","black"),space=0,horiz=T,yaxt='n',xaxt='n')
  screen(10)
  par(mar = c(0, 0, 0, 0))
  barplot(t(genderdata),col=c("brown","pink"),space=0,horiz=T,yaxt='n',xaxt='n')
  screen(11)
  par(mar = c(0, 0, 0, 0))
  legend(x=0.1,y=1,c("lung100","TCGA luad","TCGA lusc","smoker","non smoker","asian","white","black","male","female"),col=c("orange","green","blue","red","gray","yellow","white","black","brown","pink"),cex=3,horiz=F,pch=15, bty="n")
}


