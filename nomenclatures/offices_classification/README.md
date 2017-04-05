# Enriching Patstat : Patent Office names nomenclature
Ressources (usefull queries and examples) and scripts to add a Patent offices name nomenclature table, based on the names provided by [EPFL](https://wiki.epfl.ch/patstat/documents/country/country_codes.txt).

##  01_nomen_auth_names_create.sql
Inside the file we explained all process for the different tasks that was done to create and update the patent offices nomenclature table.

##  02_nomen_auth_names_dump.sql
The easiest way to import the structure and the data from the updated patents offices nomenclature table.

##  03_nomen_auth_names_stat.sql
Exploitation of the table built, with examples to show some basic descriptive statistics.

* 1.1 Compare the codes from nomen_appln_auth table and the patstat table to find a missing codes.  
* 1.2 Calculate the total number of patents for each appln_auth and order it.
* 2.1 Number patents per year for each patent office (Pan-AFRICA offices) from the application year 2000 (including 2000)
* 2.2 Based on 2.1, ipr_type = “PI” and appln_kind IN (“A”, “W”)

##  Example: number of applications per year and per patent office (only with a subselection of 4 offices)

You can use and modify any of these queries for your own purpose, for example the next one returns the number patents per year for each office, from the application year 2000 (including 2000).

```sql
SELECT 
    b.auth_name,
    a.appln_auth,
    COUNT(CASE
        WHEN YEAR(a.appln_filing_date) = 2000 THEN 1
        ELSE NULL
    END) AS '2000',
    '...' AS '...',
    COUNT(CASE
        WHEN YEAR(a.appln_filing_date) = 2012 THEN 1
        ELSE NULL
    END) AS '2012',
    COUNT(*) AS total
FROM
    patstatAvr2014.tls201_appln AS a
        INNER JOIN
    nomen_appln_auth AS b 
    ON a.appln_auth = b.appln_auth
WHERE
    YEAR(a.appln_filing_date) >= '2000'
    AND a.appln_auth IN ('JP' , 'US', 'EP', 'AP')
GROUP BY a.appln_auth
ORDER BY total DESC;
```

Number of application per year for JPO, USPTO, EPO and African Regional Intellectual Property Organization

| auth_name | appln_auth | 2000 | ... | 2012 | total | 
| --- | --- | --- | --- | --- | --- |
| United States of America | US | 321117 | ... | 379385 | 6854690 | 
| Japan | JP | 452669 | ... | 220358 | 6317461 | 
| European Patent Office | EP | 126921 | ... | 88789 | 1963223 | 
| African Regional Intellectual Property Organization | AP | 304 | ... | 220 | 4955 | 

Modify the query (years, patent offices list) to produce someting more relevant for you.
