#Eigenfactor for last three years, Typcially three years behind.
myurl.eig1 <- "http://eigenfactor.org/projects/journalRank/rankings.php?search=GY&year=2015&searchby=isicat&orderby=Eigenfactor"
myurl.eig2 <- "http://eigenfactor.org/projects/journalRank/rankings.php?search=GY&year=2014&searchby=isicat&orderby=Eigenfactor"
myurl.eig3 <- "http://eigenfactor.org/projects/journalRank/rankings.php?search=GY&year=2013&searchby=isicat&orderby=Eigenfactor"


######################

#This pulls names from the Eigenfactor.org webpage for Economics Base Year (NOTE: 2015 is last data published on web)

site <- read_html(myurl.eig1)

NAME<-html_nodes(site,".journal")%>%
  html_text()

NAME<-NAME[-1]
j<-nchar(NAME)

ISSN<-substring(NAME, first=j-8, last=j)
NAME<-substring(NAME, first=1, last=j-9)

EF<-html_nodes(site,".EF")%>%
  html_text()
EF<-EF[-1]
EF[which(EF=="<0.001")]<-NA

AI<-html_nodes(site,".AI")%>%
  html_text()
AI<-AI[-1]
AI<-AI[-1]

EFn<-AI[seq(2, length(AI), 2)]
EFn[which(EFn=="<0.1")]<-NA
AI<-AI[seq(1, length(AI), 2)]
AI[which(AI=="<0.1")]<-NA
EIG=1

EIGEN.1<-data.frame(NAME,ISSN,EF,AI,EFn,EIG)

#This pulls names from the Eigenfactor.org webpage for Economics Base yar -1

site <- read_html(myurl.eig2)

NAME<-html_nodes(site,".journal")%>%
  html_text()
NAME<-NAME[-1]
j<-nchar(NAME)

ISSN<-substring(NAME, first=j-8, last=j)
NAME<-substring(NAME, first=1, last=j-9)

EF<-html_nodes(site,".EF")%>%
  html_text()
EF<-EF[-1]
EF[which(EF=="<0.001")]<-NA

AI<-html_nodes(site,".AI")%>%
  html_text()
AI<-AI[-1]
AI<-AI[-1]

EFn<-AI[seq(2, length(AI), 2)]
EFn[which(EFn=="<0.1")]<-NA
AI<-AI[seq(1, length(AI), 2)]
AI[which(AI=="<0.1")]<-NA
EIG=1

EIGEN.2<-data.frame(NAME,ISSN,EF,AI,EFn,EIG)

#This pulls names from the Eigenfactor.org webpage for Economics Base year -2

site <- read_html(myurl.eig3)

NAME<-html_nodes(site,".journal")%>%
  html_text()
NAME<-NAME[-1]
j<-nchar(NAME)

ISSN<-substring(NAME, first=j-8, last=j)
NAME<-substring(NAME, first=1, last=j-9)

EF<-html_nodes(site,".EF")%>%
  html_text()
EF<-EF[-1]
EF[which(EF=="<0.001")]<-NA

AI<-html_nodes(site,".AI")%>%
  html_text()
AI<-AI[-1]
AI<-AI[-1]

EFn<-AI[seq(2, length(AI), 2)]
EFn[which(EFn=="<0.1")]<-NA
AI<-AI[seq(1, length(AI), 2)]
AI[which(AI=="<0.1")]<-NA
EIG=1

EIGEN.3<-data.frame(NAME,ISSN,EF,AI,EFn,EIG)

#Merge EIGEN data

EIGEN<-merge(EIGEN.1,EIGEN.2,by="ISSN",all=TRUE)
EIGEN<-merge(EIGEN,EIGEN.3,by="ISSN",all=TRUE)
EIGEN$Title<-as.character(EIGEN$NAME)
EIGEN$Title[which(is.na(EIGEN$Title))]<-as.character(EIGEN$NAME.x[which(is.na(EIGEN$Title))])
EIGEN$Title[which(is.na(EIGEN$Title))]<-as.character(EIGEN$NAME.y[which(is.na(EIGEN$Title))])

EIGEN$ai.x<-(as.numeric(as.character(EIGEN$AI.x)))
EIGEN$ai.y<-(as.numeric(as.character(EIGEN$AI.y)))
EIGEN$ai<-(as.numeric(as.character(EIGEN$AI)))

EIGEN$Journal<-EIGEN$Title
EIGEN$AI.E<-rowMeans(EIGEN[c("ai","ai.x","ai.y")],na.rm=TRUE,dims=1)
EIGEN<-EIGEN[c("ISSN","Journal","AI.E")] 

rm(list= ls()[!(ls() %in% c('AEA','EIGEN'))])
######################