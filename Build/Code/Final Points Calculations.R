a<-read.table('c:/data/temp1.csv',header=T,sep=",")
b<-read.table('c:/data/temp2.csv',header=T,sep=",")

c<-merge(a,b,by.x="Journals",by.y="Journal.List",all=T)
d<-c[!is.na(c$Author),]
d<-d[d$Journals!="",]
d<-d[d$Author!="",]

load(file='~/Department Business/Journal Rankings/Main.Rdata')

test <- merge(Main,d,by.x="ISSN",by.y="ISSN",all=T,sort=T)
  test[,2]<-ifelse(is.na(test[,2]),as.character(test[,10]),as.character(test[,2]))


b<-ifelse(test[,13]>1,as.numeric((test[,3]*1.5)/test[,13]),test[,3])

final <- data.frame(test[,12],test[,1:2],test[,14],test[,3],b,test[,13],test[,4:9])
final[,6] <- ifelse(is.na(final[,6]),final[,4],final[,6])
final[,6] <- ifelse(final[,6]==0,final[,4],final[,6])

  names(final)<-c("Author","ISSN","Journal","Old Points","New Points (Raw)","New Points(Adj)","Number of Author","ABS Rank","Impact Factor",
                  "Five Year Impact","AI Score","Econ Journal","Quasi Journal")
write.csv(final,file='~/Department Business/Journal Rankings/Final Points.csv')
