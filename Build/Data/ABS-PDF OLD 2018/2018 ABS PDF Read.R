#Reads the ABS PDF file for Economics 2018


rm(list=ls())

library(tm)
library(stringr)
library(tesseract)
library(pdftools)
library(reshape2)

setwd("C:/Users/ta0jrg1/Documents/Department Business/Journal Rankings/Data/ABS")


test<-pdf_text("2018ABS.pdf")
test2 <- strsplit(test, "\n")

for(i in 1:19){
  
  working<-test2[[i]]                 #Pulls out the page from the list
  b <- strsplit(working, "\r")        #Breaks into individual lines
  ifelse(i<=1,b<-b[-2],b)
  x<-length(b)
  
  for(j in seq(5,x,1)){ 
    
      sst1 <- unlist(strsplit(unlist(b[j]), ""))


      ISBN<-paste(sst1[11:14], collapse = "")

      ifelse(i<=1,
             Field<-trimws(paste(sst1[21:25], collapse = "")),
             Field<-trimws(paste(sst1[17:21], collapse = "")))
      
      ifelse(i<=1,
             Journal<-trimws(paste(sst1[25:57], collapse = "")),
             Journal<-trimws(paste(sst1[22:57], collapse = ""))) #)
                        
            Journal<-gsub("NA","",Journal)
      ABS18<-ifelse(i<=1,
                    trimws(paste(sst1[60:67], collapse = "")),
                    trimws(paste(sst1[60:67], collapse = "")))
      ABS15<-ifelse(i<=1,
                    trimws(paste(sst1[74:77], collapse = "")),
                    trimws(paste(sst1[70:77], collapse = "")))
      ABS10<-ifelse(i<=1,
                    trimws(paste(sst1[84:87], collapse = "")),
                    trimws(paste(sst1[80:87], collapse = "")))
      ABS09<-ifelse(i<=1,
                    trimws(paste(sst1[94:97], collapse = "")),
                    trimws(paste(sst1[90:97], collapse = "")))
      
      M<-data.frame(ISBN,gsub("NA","",Field),Journal,gsub("NA","",ABS18),gsub("NA","",ABS15),gsub("NA","",ABS10),gsub("NA","",ABS09))
        
      ifelse(j <= 5 & i <= 1, ABS<-M, ABS<-rbind(ABS,M))
      
  }
}

working<-test2[[20]]                 #Pulls out the page from the list
  x<-length(working)-1
  b <- strsplit(working, "\r")        #Breaks into individual lines

for(j in seq(5,x,1)){ 
  
  sst1 <- unlist(strsplit(unlist(b[j]), ""))
  ISBN<-paste(sst1[12:15], collapse = "")
  Field<-trimws(paste(sst1[17:22], collapse = ""))
  Journal<-trimws(paste(sst1[23:57], collapse = ""))
    Journal<-gsub("NA","",Journal)
  ABS18<-trimws(paste(sst1[60:67], collapse = ""))
  ABS15<-trimws(paste(sst1[70:77], collapse = ""))
  ABS10<-trimws(paste(sst1[80:87], collapse = ""))
  ABS09<-trimws(paste(sst1[90:97], collapse = ""))
  
  M<-data.frame(ISBN,gsub("NA","",Field),Journal,gsub("NA","",ABS18),gsub("NA","",ABS15),gsub("NA","",ABS10),gsub("NA","",ABS09))
  
 ABS<-rbind(ABS,M)
}
  
c<-which(ABS$ISBN=="    ")
d<-c-1
ABS$Journal<-as.character(ABS$Journal)

for(i in seq(1,length(d),1)){
  ABS$Journal[d[i]]<-paste(ABS$Journal[d[i]],ABS$Journal[c[i]],sep=" ")
  }
ABS<-ABS[which(ABS$ISBN!="    "),]

ABS$ISBN<-as.character(ABS$ISBN)

x<-nrow(ABS)

for(i in seq(1,x,2)){
  ABS$Journal[[i]]<-paste(ABS$Journal[[i]],ABS$Journal[[i+1]],sep=" ")
}
for(i in seq(1,x,2)){
  ABS$ISBN[[i]]<-paste(ABS$ISBN[[i]],ABS$ISBN[[i+1]],sep="-")
}

names(ABS)<-c("ISSN","Field","Journal","ABS2018","ABS2015","ABS2010","ABS2009")
ABS<-ABS[which(ABS$Field!=""),]
save(ABS,file="ABS.RData")

