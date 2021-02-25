# Journals
  Department of Economics Journal Points
  Created by: J. Groves
  Created on: May 22, 2012


#Updates
  Updated on: March 16, 2015
      Had to change ISSN look up to new website
  Updated on: February 2, 2017
      Updated scrape commands
      Reworked CODE so that all in here. Only need to download from ScienceWeb
      the new year's ECON and FULL list and put them in sub-directory. Then reset
      the three years used. Also check on EIGENFACTOR page to see if new data 
      exists.
  Updated on: March 14, 2018
      Reformatted ABS lookup using the newest 2015 data. Also cleaned up some coding with AEA
  Updated on: May 28, 2019
       Updated ABS data using the 2018 Academic Journal Guide.
       Some coding updates in AEA ECONLIT section
       Removed all calculations for Quasi Economics Journals as those no longer exist
  Updated on: February 25, 2021
       Modernized code using tidyverse
       Updated the Web of Science data
       
       
       
#Instructions

   -Go to web of Science via NIU Library and choose Journal Citation Reports
   -Choose "Browse by Journal" and then choose :customize indicators: and choose ISSN, 5 Year Impact;              and AI scores then download. If you do not hit a category, it should download all.
   -Save download in ./Build/Data/JCRYEAR.csv with YEAR equal to year of report
   -ABS data must be downloaded from  https://charteredabs.org   username: jgroves password: Ao257bc! 
   -On May, 2019 Update, the entire AJG was saved into the ABS 2018.xlsx file and that is imported.
   

