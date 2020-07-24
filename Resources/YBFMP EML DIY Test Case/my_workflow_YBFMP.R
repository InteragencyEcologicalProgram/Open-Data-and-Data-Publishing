##################################################################################

#### EMLassemblyLine for Environmental Data Inititive (EDI) #####

#  Converting metadata to EML using R - Template created for IEP 

#  ><))'>  ><))'>  ><))'>  ><))'> ><))'>  ><))'>  ><))'>  ><))'> ><))'>  ><))'>  

##################################################################################

# Created by Brittany Davis (CDWR)
# contact me with questions at brittany.e.davis@water.ca.gov or 916-376-9756

#################################################################################

#install.packages("devtools")
library(devtools)
#install_github("EDIorg/EMLassemblyline")
library(EMLassemblyline)

#periodically delete and re-install EMLassemblyLine package, EDI is often updating and making tweeks

#YBFMP EXAMPLE

# (1.)  create a new folder or working directory and put your data files into it. All the EML template files will be added here, ina ddition to the final .xml document.
setwd(".")

# (2.) drop all final files-tables ready to publish in this directory. Be sure naming is is in proper format, e.g. name.of.(your) d@t@.file should be name_of_your_data_file

#You can't have any empty cells in the data tables so what I did was called in the tables and re-wrote them populating the emppty cells with NAs. If there are empty cells you will get an error code. The later you will add a descriptor for "NA" missing values in the files.

fish_WQ <- read.csv("YBFMP_fish_and_water_quality_data_1998_2018.csv")
summary(fish_WQ) # running a summary will show you all the columns and summarize the levels and show if you have NAs.
write.csv(fish_WQ,file="YBFMP_fish_and_water_quality_data_1998_2018.csv", row.names=FALSE, na="NA")

taxon <- read.csv("YBFMP_Fish_Taxonomy.csv")
summary(taxon)
write.csv(taxon,file="YBFMP_Fish_Taxonomy.csv", row.names=FALSE, na="NA")

effort<- read.csv("YBFMP_Trap_Effort.csv")
summary(effort)
write.csv(effort,file="YBFMP_Trap_Effort.csv", row.names=FALSE, na="NA")


#NOW YOU"RE READY TO BEGIN
#Follow steps in the word document and powerpoint I provided and generate your code. EDI on github can be a great additional resource.

# (3.) select INTELLECTUAL RIGHTS, IEP decided on "CCBY"
# (4.) identify types of data

# (5.) import core metadata templates

# View documentation for this function
?template_core_metadata

#Import EML core metadata templates, enter working directory path, license and the file types. 
template_core_metadata(path = ".",
                 license="CCBY",
                 file.type = ".txt")


# (6.) import metadata table attribute templates

# View documentation for this function
?template_table_attributes


template_table_attributes(path = ".",
                          data.table = c("YBFMP_fish_and_water_quality_data_07252018_QA.csv",
                                         "YBFMP_Fish_Taxonomy.csv",
                                         "YBFMP_Trap_Effort.csv",
                                         "YBFMP_Site_locations_latitude_and_longitude.csv"))
# data tables must be .csv files, xlx file types wil be coerced and no attribute files will be created


# (6.) SCRIPT WORKFLOW to create a metadata template for the future. You'll see "my_workflow.R" was generatedd in the working directory but at this time you propable already started you're own R-code, re-save this file in the directory.

# (7.) ABSTRACT > copy/paste abstract from word document to template abstract.txt. Use https://pteo.paranoiaworks.mobi/diacriticsremover/ to remove any non-unicode characters (sybmols, formatting, hyperlinks). Click remove Diacritics at the website.

# (8.) METHODS. add all methods into the method.txt file. For YBFMP include all gear type, equipment information, site information, and QA/QC protocols. Once written in the EDI metaddata template, copy/paste into the above website to remove and non-unicode characters.

# (9.) ADDITIONAL INFO, add any additional metadata information, I added a list of publications using the data

# (10.) KEYWORDS, fill out table and text file. Be sure to include "Interagency Ecological Program for the San Francisco Bay Delta Estuary

# (11.) PERSONNEL, fill out table and text file, see comments in intructions and word template

# (12.) ATTRIBUTES, fill all attribute files, copy/paste text from file into an excel file to add all descripters. 
#Make sure to check the attribute class is correct for the type of data.
#Some data attributes may need to be changed from "categorical" to "character" class.
#For example, ID_CommonName was originally classified as a "categorical" attribute so we changed it to a "character" class.
#You will need to define each category of a "categorical" class attribute in the next step, so make sure this designation is appropriate for the data.  

#use the standard units from the R dictionary, if not in the dictionary you will need to fill out the custom unit text file. 
#I had to do this for turbidity "microSeimenPerCentimeter"
#View the standard unit dictionary of the Ecological Metadata Language schema in the RStudio source window.
view_unit_dictionary()

# (13.) CLOSE ALL FILES, some function will error out and not product categorical variable files if open.

# (14.) Define categroical variables, reads the attribute files generated in the working directory and creates additional text files for you to define each categorical variable.
template_categorical_variables(path = ".")

#re-run until all error codes and warnings are removed, for example all trailing characters such a SpCnd of 312 versus 311.99000. reduce to single decimals. The consul results should be clean for the final eml assembly to work correctly.
#Fill out catvar.txt files. Copy/paste text from file into an excel file to add all descriptors. 

# (15.) Extract locations for all sites with specific coordinate information if needed. 
# geographic_coverage.txt file is only used if you want your data displayed by a series of points on EDI, 
#Yolo has one general area that we will include in the make_eml function as a general geographic bounding box, 
#so there is no need to create the geographic coverage template, otherwise you will get a replication error when you run the make_eml function. 

?template_geographic_coverage()

#Example code if we wanted to use it.
template_geographic_coverage(path=".",
                    data.file="YBFMP_Site_locations_latitude_and_longitude.csv",
                                lat.col="LatitudeLocation",
                                lon.col="LongitudeLocation",
                                site.col="StationCode")


# (16.) MAKE EML!!!! This will combine all the generated data tables, attribute files, catvar files, and other text files together into your machine readble xml file.  See word document for more descriptions of each line.
make_eml(path = ".", 
         dataset.title = "Interagency Ecological Program: Fish catch and water quality data from the Sacramento River floodplain and tidal slough, collected by the Yolo Bypass Fish Monitoring Program, 1998-2018.", 
         temporal.coverage = c("1998-01-01", "2018-06-30"), 
         geographic.description = "Yolo Bypass tidal slough and seasonal floodplain in Sacramento California USA",
         geographic.coordinates = c("38.79395205", "-121.5368316", "38.23466149","-121.8073699"),        # This arguement creates a bounding box instead of creating points from the geographic_coverage.txt metadata file
         maintenance.description = "ongoing",
         data.table = c("YBFMP_fish_and_water_quality_data_1998_2018.csv",
                        "YBFMP_Fish_Taxonomy.csv",
                        "YBFMP_Trap_Effort.csv", 
                        "YBFMP_Site_locations_latitude_and_longitude.csv"), 
         data.table.description = c("Fish catch and water quality data from the Yolo Bypass Fish Monitoring Program",
                                    "Taxon table for species including native or invasive classification",
                                    "Table of hours fished for effort estimations",
                                    "Site location table including coordinates"), 
         data.table.quote.character = c("\"", "\"","\"","\""),
         data.table.url = c("","","",""), 
         user.domain ="EDI",
         user.id="iep",
         package.id="edi.233.1")

#while trying to create the eml, if you dont have a reserved edi package id just leave it blank ="").

#The output in the consule will tell you if you passed or failed the EML validation. If you failed you need to fix errors until valid.
#Somer errors can be manually fixed in an xml editor if needed. I used a free download of "editit_xmleditor"


