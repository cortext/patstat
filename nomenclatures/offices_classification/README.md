# Enriching Patstat : Patent Office names nomenclature
Ressources (usefull queries and examples) and scripts to add a Patent offices name nomenclature table, based on the names provided by [EPFL](https://wiki.epfl.ch/patstat/documents/country/country_codes.txt).

##  01_nomen_auth_names_create
SQL script file where we explain all the different steps that have been done to setup and update the patent offices nomenclature table.

##  02_nomen_auth_names_dump
The easiest way to import the structure and the data from the updated patents offices nomenclature table.

##  03_nomen_auth_names_stat
Exploitation of the table built, with examples to show some basic descriptive statistics.

* 1.1 Compare the codes from nomen_appln_auth table and the patstat table to find a missing codes.  
* 1.2 Calculate the total number of patents for each appln_auth and order it.
* 2.1 Number patents per year for each patent office (Pan-AFRICA offices) from the application year 2000 (including 2000)
* 2.2 Based on 2.1, ipr_type = “PI” and appln_kind IN (“A”, “W”)

##  What is inside
```sql
CREATE TABLE `nomen_appln_auth` (
  `appln_auth` varchar(2) COLLATE utf8_unicode_ci NOT NULL,
  `auth_name` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `acronym` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `status` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`appln_auth`),
  KEY `i01` (`auth_name` ASC),
  KEY `i02` (`appln_auth` ASC, `auth_name` ASC)
)
```
Where status can take: 
* **'in use'** all code (i.e. country codes or patent office codes) that are in use, following the ISO Norm [ISO 3166-1 alpha-2](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2);
* **'deprecate'** all `appln_auth` that are not any more in use (e.g. 'CS' for 'Serbia and Montenegro' or 'SU' for 'Soviet Union' or 'DD' for 'German Democratic Republic'). Depending on the time stamp you are looking for, some of this code represent a large amount of patents (e.g. 'DD' or 'SU');
* **'unknown'** only for a few patents with 'ZZ' as `appln_auth`.

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

Modify the query (years, patent offices list) according to what to want to calculate.