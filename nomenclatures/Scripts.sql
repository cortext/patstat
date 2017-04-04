-- USE 'your_own_database_name';
USE 't_juan';


-- 1.1 Compare the codes from nomen_appln_auth table and the patstat table to find missing codes.

SELECT 
    patstatAvr2014.tls201_appln.*
FROM
    patstatAvr2014.tls201_appln
        LEFT JOIN
    nomen_appln_auth ON (patstatAvr2014.tls201_appln.appln_auth = nomen_appln_auth.appln_auth)
WHERE
    nomen_appln_auth.appln_auth IS NULL
GROUP BY patstatAvr2014.tls201_appln.appln_auth;

-- 1.2 Calculate the total number of patents for each appln_auth and order it.

SELECT 
    COUNT(*), patstatAvr2014.tls201_appln.appln_auth
FROM
    patstatAvr2014.tls201_appln
GROUP BY patstatAvr2014.tls201_appln.appln_auth
ORDER BY COUNT(*) DESC
 
-- http://www.thomsonfilehistories.com/docs/RESOURCES_Kind%20Codes%20by%20Country.pdf
-- http://ip-science.thomsonreuters.com/m/pdfs/dwpicovkinds/wipo_codes.pdf
 
/*
  2. Query the total amount of patents (applications) for the pan-African offices:

    - 2.1 : Number patents per year for each patent office from the application year 2000 (including 2000)
*/

SELECT 
    COUNT(*), appln_auth, YEAR(appln_filing_date) AS year_appln
FROM
    patstatAvr2014.tls201_appln
WHERE
    YEAR(appln_filing_date) >= '2000'
        AND appln_auth IN ('AP' , 'CF', 'OA')
GROUP BY YEAR(appln_filing_date) , appln_auth;

/*
  2. Query the total amount of patents (applications) for the pan-African offices:

    - 2.2: Based on 2.1, ipr_type = “PI” and appln_kind IN (“A”, “W”)

*/

SELECT 
    COUNT(*), appln_auth, YEAR(appln_filing_date) AS year_appln
FROM
    patstatAvr2014.tls201_appln
WHERE
    YEAR(appln_filing_date) >= '2000'
        AND appln_auth IN ('AP' , 'CF', 'OA')
        AND ipr_type = 'PI'
        AND appln_kind IN ('A' , 'W')
GROUP BY YEAR(appln_filing_date) , appln_auth;
