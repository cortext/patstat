-- ---------------------------------------------------------------------------------
-- Gnupablo and Lionel Villard
-- 2017/04/07
-- Examples of queries for the nomenclature patent offices names
--
-- ---------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------
-- Database

USE `your_database`;


-- 1.1 Compare the codes from nomen_appln_auth table and the patstat table to find missing codes.

SELECT 
    *
FROM
    tls201_appln AS a
        LEFT JOIN
    nomen_appln_auth AS b 
    ON a.appln_auth = b.appln_auth
WHERE
    b.appln_auth IS NULL
GROUP BY a.appln_auth;

-- 1.2 Calculate the total number of patents for each appln_auth and order it.

SELECT 
    COUNT(*),a.appln_auth
FROM
    tls201_appln AS a
GROUP BY a.appln_auth
ORDER BY COUNT(*) DESC;
 
/*
  2. Query the total amount of patents (applications) by patent office:

    - 2.1 : Number patents per year for each patent office from the application year 2000 (including 2000)
*/

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
    tls201_appln AS a
        INNER JOIN
    nomen_appln_auth AS b 
    ON a.appln_auth = b.appln_auth
WHERE
    YEAR(a.appln_filing_date) >= '2000'
    AND a.appln_auth IN ('JP' , 'US', 'EP', 'AP')
GROUP BY a.appln_auth
ORDER BY total DESC;

/*
  2. Query the total amount of patents (applications) by patent office:

    - 2.2: Based on 2.1, ipr_type = “PI” and appln_kind IN (“A”, “W”)

*/

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
    tls201_appln AS a
        INNER JOIN
    nomen_appln_auth AS b 
    ON a.appln_auth = b.appln_auth
WHERE
    YEAR(a.appln_filing_date) >= '2000'
    AND a.appln_auth IN ('JP' , 'US', 'EP', 'AP')
    AND a.ipr_type = 'PI'
    AND a.appln_kind IN ('A' , 'W')
GROUP BY a.appln_auth
ORDER BY total DESC;
