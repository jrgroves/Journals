# Journals
Department of Economics Journal Rankings

Nov. 12:
  Need to figure out why the SCI has mulitple ISSNs
  Need to figure out why AEA is missing ISSN
  Figure out a way to fill in missing ISSNs
  See if IDEAs has ISSN anywhere because now they do not
  Need to be able to obtain metrics for all journals
  

Methodology:

For AEA Econlit journal list, the website https://www.aeaweb.org/econlit/journal_list.php
is read and then the journal names and ISSNs are pulled. For those missing ISSNs we looked
up the ISSNs on https://portal.issn.org. For those still missing ISSNs the journals have a
very limited run that is tracted with AEA so those journals are deleted.

For the Repec/IDEAS list, the journal list at https://ideas.repec.org/top/top.journals.all.html
is copied and cleaned in excel and then loaded directly into R. This was due to the complications
in getting a clean version into R directly. The other problem with this dataset is there are no ISSNs 
listed so we are required to join on name
