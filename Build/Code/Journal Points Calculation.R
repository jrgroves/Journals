#Make sure to read the README file for instructions for data and a list of updates

rm(list=ls())
library(rvest)
library(tidyverse)

  
  
######################
#Lists of relevant URLs

myurl.aea <- "https://www.aeaweb.org/econlit/journal_list.php"

######################
#AEA ECONLIT Journal List

site <- read_html(myurl.aea)

d<-html_nodes(site,".journaldesc")%>%
   html_text()

#This begins the extraction for the ECONLIT ISSNs
d<-strsplit(d,"\\n")
  n<-length(d) #obtains the size of the list
  for(val in seq(1:n)){
    Journal<-trimws(d[[val]][1])
    ISSN<-trimws(d[[val]][2])
      ISSN<-gsub("ISSN: ","",ISSN)
    temp<-data.frame(Journal,ISSN)
    ifelse(val==1,AEA<-temp,AEA<-rbind(AEA,temp))
    rm(temp)
  }
rm(d, site)
  
  
#Fix Missing ISSNs 
  
  #Use this code once to pull out and save the missing journals so web search can be done 
  #manually at https://portal.issn.org/
  # sub<-AEA %>%
  #      subset(ISSN=="ISSN:")
  # write.csv(sub,file="./Build/Data/sub.csv")
  #readline(prompt="Press [enter] after looking up missing ISSNs")
  
  sub<-read.csv(file="./Build/Data/sub.csv",as.is=TRUE)
    sub$X<-NULL
  AEA<-rbind(AEA,sub)
    AEA<-AEA %>%
        subset(ISSN!="ISSN:") %>%
          distinct(Journal, ISSN, .keep_all = TRUE)
    
  AEA$Econ<-1

######################
    
#Read in American Business School Data from csv file created (see instructions above)
  ABS<-read.csv(file="./Build/Data/ABS 2018.csv",as.is=TRUE)
  ABS$ABS<-ABS$AJG.2018
  ABS$ABS[which(ABS$ABS<ABS$AJG.2015)]<-ABS$AJG.2015[which(ABS$ABS<ABS$AJG.2015)]
  ABS<-ABS[c("ISSN","Journal.Title","ABS")]
  
######################
#Use the JCR data from Web of Science (see instructions) for last three years
  i<-1
  for(x in seq(2017,2019)){
    temp<-read.csv(paste0("./Build/Data/JCR",x,".csv"), header=TRUE, as.is=TRUE)
      names(temp)<-c("Rank","Journal","ISSN",paste0("JIF",i), paste0("IF",i),paste0("AI",i))
      temp<-temp %>% 
        select(-Rank) %>%
          subset(ISSN!="")
  ifelse(i==1,JCR<-temp,JCR<-merge(JCR,temp,by="ISSN"))
  i<-i+1
  rm(temp)
  }
  JCR<-JCR %>%
    distinct(ISSN, .keep_all = TRUE) %>%
      select(-Journal.x, -Journal.y) %>%
        mutate(across(starts_with("IF"), as.numeric))  %>%
        mutate(across(starts_with("AI"), as.numeric)) %>%
        mutate(across(starts_with("JIF"), as.numeric)) %>%
          group_by(ISSN) %>%
            mutate(A=mean(c(AI1,AI2,AI3), na.rm=TRUE)) %>%
              mutate(I=mean(c(IF1,IF2,IF3), na.rm=TRUE)) %>%
                mutate(T=mean(c(JIF1,JIF2,JIF3), na.rm=TRUE)) %>%
                  select(ISSN, Journal, I, A, T)
  
  
####################################
  
#Merger Data
  
Journals<-merge(AEA,ABS,by="ISSN",all=TRUE)
  Journals<-Journals %>%
      mutate(Journal=coalesce(Journal,Journal.Title)) %>%
        select(ISSN,Journal,Econ,ABS)
  
  
Journals<-merge(Journals,JCR,by="ISSN",all.x=TRUE)
  Journals<-Journals %>%
    select(ISSN,Journal.x,Econ,ABS,I,A,T) %>%
      rename(Journal=Journal.x) 

######################

#Create Base Points

Points<-Journals %>%
    mutate(Q=case_when(
      is.na(Econ) ~ 25,
      Econ==1 ~ 50)) %>%
    mutate(Z = case_when(
      is.na(A) ~ I^.7,
      is.na(I) ~ A^.7,
      is.na(A) & is.na(I) ~ T^.7,
      A >= 0 & I >= 0 ~ (A*I)^.35)) %>%
    mutate(B.Points=Q*Z) %>%
    select(-Q, -Z)
  
#Apply Special Rules

Points <- Points %>% 
    replace_na(list(Econ=0, ABS=0))%>%
    mutate(Points = case_when(
      is.na(B.Points) & Econ==1 ~ 20,      #All Economics Journals get min of 20 Points
    )) %>%
   mutate(Points = case_when(           #Application of Minimums for ABS
      B.Points < 120  & ABS==5 ~ 120,             #ABS Min for 4*
      B.Points < 90   & ABS==4 ~ 90,              #ABS Min for 4
      B.Points < 60   & ABS==3 ~ 60,              #ABS Min for 3
      B.Points < 40   & ABS==2 ~ 40,              #ABS Min for 2
      B.Points < 20   & ABS==1 ~ 20,              #ABS Min for 1
      TRUE ~ Points                     #All others keep base points
      )) %>%
   mutate(Points = case_when(
     B.Points > 150 & Econ == 1 & ABS > 3 ~ 150,    #No Econ Journal gets more than 150 Points
     B.Points > 150 & Econ == 1 & ABS < 4 ~ 120,    #ABS must be 4 or 5 for more than 120
     B.Points > 120 & Econ == 1 & ABS < 4 ~ 120,
     B.Points > 120 & Econ == 0 ~ 120,
     TRUE ~ Points))%>%
   mutate(Points = case_when(
     is.na(Points) ~ B.Points,
     TRUE ~ Points
   ))
  
#Apply Classifications

Points <- Points %>%

  mutate(Level = case_when(
    Points >  0   & Points < 20  ~ "Level V",
    Points >= 20  & Points < 40  ~ "Level IV",
    Points >= 40  & Points < 60  ~ "Level III",
    Points >= 60  & Points < 90  ~ "Level II",
    Points >= 90  & Points < 120 ~ "Level I-C",
    Points >= 120 & Points < 150 ~ "Level I-B",
    Points ==150 ~ "Level I-A",
    TRUE         ~ "No Level")) %>%
  select(Level, Points, Journal, ISSN, Econ, ABS, I, A, T, B.Points) %>%
  arrange(desc(Econ), desc(Points), Journal)

#Output Results
write.csv(Points,"./Build/Output/POINTS.csv", row.names = FALSE)
  
