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

##  Result

You can use and modify any of these queries for your own purpose, for example the next one returns the number patents per year for each office, from the application year 2000 (including 2000)

```sql
SELECT 
    auth_name,
    patstatAvr2014.tls201_appln.appln_auth,
    COUNT(CASE
        WHEN YEAR(patstatAvr2014.tls201_appln.appln_filing_date) = 2000 THEN 1
        ELSE NULL
    END) AS '2000',
    '...' AS '...',
    COUNT(CASE
        WHEN YEAR(patstatAvr2014.tls201_appln.appln_filing_date) = 2012 THEN 1
        ELSE NULL
    END) AS '2012',
    COUNT(*) AS total
FROM
    patstatAvr2014.tls201_appln
        INNER JOIN
    nomen_appln_auth ON patstatAvr2014.tls201_appln.appln_auth = nomen_appln_auth.appln_auth
WHERE
    YEAR(patstatAvr2014.tls201_appln.appln_filing_date) >= '2000'
        AND patstatAvr2014.tls201_appln.appln_auth IN ('JP' , 'US', 'EP', 'AP')
GROUP BY patstatAvr2014.tls201_appln.appln_auth
ORDER BY total DESC;
```

And the result is something similar to

| appln_name | appln_auth | 2000 | ... | 2012 | total | 
| --- | --- | --- | --- | --- | --- |
| United States of America | US | 321117 | ... | 379385 | 6854690 | 
| Japan | JP | 452669 | ... | 220358 | 6317461 | 
| European Patent Office | EP | 126921 | ... | 88789 | 1963223 | 
| African Regional Intellectual Property Organization | AP | 304 | ... | 220 | 4955 | 

In this case you can modify the dates and the patent office list how you requieres.

