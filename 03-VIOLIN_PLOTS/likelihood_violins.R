files<-list.files(pattern='likelihoods.csv')
for(i in sequence(length(files))){
  data<- read.csv(files[i])
  bootstraps<-c(data[1])
  best<-data[1,2]
  meta<-data[1,3]
  subop<-data[4]
  names(bootstraps)<-names(subop)
  all<-rbind(bootstraps, best, meta, subop)
  avg<- sapply(all, mean, na.rm=TRUE)
  for (f in bootstraps){
    dis<- avg/f
  }
  for (j in subop){
    subdis<-avg/j
  }
  bratio<-avg/best
  mratio<-avg/meta
  result<-c(dis, bratio, mratio)
  out.files <- gsub("\\.csv$", ".bproportions.csv", files) 
  write.csv(result, out.files[i], row.names=FALSE)
  subresults<-c(subdis, bratio, mratio)
  out<-gsub("\\.csv$", ".sproportions.csv", files)
  write.csv(subresults, out[i], row.names=FALSE)
}

library(ggplot2)
library(reshape)
library(Hmisc)
temp = list.files(pattern=".bproportions.csv")
myfiles = lapply(temp, read.delim)
dat<-data.frame(myfiles)
colnames(dat)<-c("ML005129a", "ML00555a", "ML00955a", "ML02771a", "ML049014a", "ML070218","ML092610a", "ML102910a", "ML120721a", "ML177319a", "ML42441a", "ML49231a")
ord<-dat[order(dat[102,])]
mdat<-melt(ord, measure.vars=grep("^ML", names(ord), value=TRUE))
bpoint<-ord[101,]
mpoint<-ord[102,]
md<-melt(bpoint, measure.vars=grep("^ML", names(ord), value=TRUE))
mp<-melt(mpoint, measure.vars=grep("^ML", names(ord), value=TRUE))
p <- ggplot(mdat, aes(x=variable, y=value)) + geom_violin()
p + geom_point(data=md, aes(x=variable, y=value), size=3, color="red") + geom_point(data=mp, aes(x=variable, y=value), size=3, color="blue") + xlab("Genes") + ylab("Likelihood Proportions")


subtemp=list.files(pattern=".sproportions.csv")
subfiles= lapply(subtemp, read.delim)
subdat<-data.frame(subfiles)
colnames(subdat)<-c("ML005129a", "ML00555a", "ML00955a", "ML02771a", "ML049014a", "ML070218","ML092610a", "ML102910a", "ML120721a", "ML177319a", "ML42441a", "ML49231a")
subord<-subdat[order(subdat[102,])]
msub<-melt(subord, measure.vars=grep("^ML", names(subord), value=TRUE))
bestsub<-subord[101,]
metasub<-subord[102,]
mb<-melt(bestsub, measure.vars=grep("^ML", names(subord), value=TRUE))
mm<-melt(metasub, measure.vars=grep("^ML", names(subord), value=TRUE))
q<-ggplot(msub,aes(x=variable, y=value)) +scale_y_continuous(limits = c(0.98,1.02), breaks=c(0.99,1.00, 1.01), expand=c(0,0)) + geom_violin() 
q + geom_point(data=mb, aes(x=variable, y=value), size=3, color="red") + geom_point(data=mm, aes(x=variable, y=value), size=3, color="blue") + xlab("Genes") + ylab("Likelihood Proportions")
