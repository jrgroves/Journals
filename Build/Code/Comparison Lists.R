#This file pulls in various Economics Journal listings for comparison to the ECONLIT catalog
#Jeremy R. Groves
#Nov. 11, 2020

rm(list=ls())
library(tidyverse)
library(rvest)

#Journals from IDEA
  ideas<-read.csv("./Build/Data/ideas.csv", as.is=TRUE)
    ideas$IDEA<-"X"

#Jounrals from Scimago (https://www.scimagojr.com/)  
  sci<-read.csv("./Build/Data/scimag2019.csv", sep=";", as.is=TRUE)
    sci<-sci[which(sci$Type=="journal"),]
    sci<-sci[,c("Title","Issn")]  
      c<-as.data.frame(str_split(sci$Issn, ", ",simplify=TRUE))
        temp1<-data.frame(sci[,1],c[,1])
          names(temp1)<-c("Journal","ISBN")
        temp2<-data.frame(sci[,1],c[,2])
          temp2[which(temp2[,2]==""),2]<-NA
          names(temp2)<-c("Journal","ISBN")
          temp2<-temp2[!is.na(temp2[,2]),]
        temp3<-data.frame(sci[,1],c[,2])
          temp3[which(temp3[,2]==""),2]<-NA
          temp3<-temp3[!is.na(temp3[,2]),]
          names(temp3)<-c("Journal","ISBN")
          
      sci<-rbind(temp1,temp2,temp3)
        rm(temp1, temp2, temp3)
      sci$ISBN<-paste0(substr(sci$ISBN,1,4),"-",substr(sci$ISBN,5,8))    
          
  sci$SCIMAGO<-"X"

#Journals from EconLit
  aea.url<-read_html("https://www.aeaweb.org/econlit/journal_list.php")
  
  aea<-aea.url %>%
        html_nodes("div.journaldesc") %>%
        html_text() %>%
        str_split("\\n",simplify=TRUE) %>%
        as.data.frame()
  
  aea<-aea[,1:2]
    aea[,1]<-trimws(aea[,1]) #Trims white space  
    aea[,2]<-trimws(aea[,2]) #Trims white space
    
  names(aea)<-c("Journal","ISBN")
    aea$ISBN<-trimws(gsub("ISSN: ","",aea$ISBN))
    aea$AEA<-"X"

#Journal from Journal Citation Index: Web of Science
  jci<-read.csv("./Build/Data/jci2019.csv",as.is=TRUE, header=FALSE)[-1,] 
    names(jci)<-jci[1,]
    names(jci)[which(names(jci)=="ISSN")]<-"ISBN"
      jci<-jci[2:nrow(jci),]
    jci<-jci[,c("Full Journal Title","ISBN")]
    jci$JCI<-"X"
    
journals<-Reduce(function(x,y) merge(x,y,by="ISBN",all=TRUE), list(aea,sci,jci))

  journals$Title<-journals$Journal.x
    journals$Title[is.na(journals$Title)]<-journals$Journal.y[is.na(journals$Title)]
    journals$Title[is.na(journals$Title)]<-journals$`Full Journal Title`[is.na(journals$Title)]
    journals<-journals[which(journals$Title!=""),]
    journals<-journals[!is.na(journals$Title),]
  journals<-journals[,c("Title","ISBN","AEA","SCIMAGO","JCI")]
  journals<-journals[order(journals$AEA,journals$Title),]
  journals<-unique(journals)

write.csv(journals,file="./Build/Output/journals.csv",row.names = FALSE)
  
                 