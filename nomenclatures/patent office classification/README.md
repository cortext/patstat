# Setting up a MySQL database from the Patents office nomenclatures 
MySQL script to build the Patent offices nomenclatures database, based on the text file from (https://wiki.epfl.ch/patstat/documents/country/country_codes.txt).and a list of helpful queries for the research

##  Nomen_appln_codes_create_process.sql
Inside the file we explained all process from the different tasks that was done for create and update the patents office nomenclature table 

##  Nomen_appln_codes_dump.sql
The easiest way to import the structure and the data from the updated patents office nomenclatures table.

##  Scripts.sql
Here is the descriptions list for the queries that are inside the scripts.sql file

* 1.1 Compare the codes from nomen_appln_auth table and the patstat table to find a missing codes.  
* 1.2 Calculate the total number of patents for each appln_auth and order it.
* 2.1 Number patents per year for each patent office (Pan-AFRICA offices) from the application year 2000 (including 2000)
* 2.2 Based on 2.1, ipr_type = “PI” and appln_kind IN (“A”, “W”)

