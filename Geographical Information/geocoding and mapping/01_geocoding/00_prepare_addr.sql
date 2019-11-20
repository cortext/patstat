USE patstatAvr2017_lab;
-- ---------------------
-- inv
-- ---------------------

DROP TABLE IF EXISTS `04_addr_list`;

CREATE TABLE `04_addr_list` (
  `adr_final` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `adr_final_norm` varchar(550) COLLATE utf8_unicode_ci NOT NULL,
  `adr_final_norm_trim` varchar(550) COLLATE utf8_unicode_ci NOT NULL,
  `iso_ctry` varchar(2) COLLATE utf8_unicode_ci DEFAULT NULL,
  `nbpat` int(10) DEFAULT '0',
  PRIMARY KEY (`iso_ctry`,`adr_final`(300)),
  KEY `iadr` (`adr_final`(100)),
  KEY `iadrnorm` (`adr_final_norm`(100)),
  KEY `iadrnormtrim` (`adr_final_norm_trim`(100)),
  KEY `ictry` (`iso_ctry`),
  KEY `inbpat` (`nbpat`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

ALTER TABLE `04_addr_list` DISABLE KEYS;

INSERT IGNORE INTO `04_addr_list` SELECT 
    a.adr_final,
    norm_addr(normalise_specialChars(CONCAT(a.adr_final, ', ', c.lib_ctry_harm))) AS Addr,
	'',
	a.iso_ctry,
    COUNT(a.appln_id) AS NbPat
FROM
    patstatAvr2017.invt_addr_ifris AS a
        LEFT JOIN
    patstatAvr2017.nomen_country_continent AS c ON a.iso_ctry = c.ctry_harm
WHERE adr_final IS NOT NULL AND adr_final <> ""
GROUP BY  a.iso_ctry, a.adr_final;

ALTER TABLE `04_addr_list` ENABLE KEYS;

UPDATE `04_addr_list` 
SET 
    adr_final_norm = norm_addr(normalise_specialChars(adr_final))
WHERE
    adr_final_norm = '';

DELETE FROM `04_addr_list`
WHERE adr_final_norm = '';

-- ---------------------
-- applt
-- ---------------------

ALTER TABLE `04_addr_list` DISABLE KEYS;

INSERT IGNORE  INTO `04_addr_list` SELECT 
    a.adr_final,
    norm_addr(normalise_specialChars(CONCAT(a.adr_final, ', ', c.lib_ctry_harm))) AS Addr,
	'',
	a.iso_ctry,
    COUNT(a.appln_id) AS NbPat
FROM
    patstatAvr2017.applt_addr_ifris AS a
        LEFT JOIN
    patstatAvr2017.nomen_country_continent AS c ON a.iso_ctry = c.ctry_harm
WHERE adr_final IS NOT NULL AND adr_final <> "" 
GROUP BY a.iso_ctry, a.adr_final;

ALTER TABLE `04_addr_list` ENABLE KEYS;

UPDATE `04_addr_list` 
SET 
    adr_final_norm = norm_addr(normalise_specialChars(adr_final))
WHERE
    adr_final_norm = '';

-- ------------------------------
-- Cleaning step
-- ------------------------------

DELETE FROM `04_addr_list`
WHERE adr_final_norm = '';

DELETE FROM `04_addr_list`
WHERE
	 adr_final LIKE '%deceased%' OR
	 adr_final LIKE '%Deceased%' OR
	 adr_final LIKE '%décédé%' OR
	 adr_final LIKE '%verstorben%';

DELETE FROM `04_addr_list`
WHERE
	adr_final = '.' OR 
	adr_final = '///,///' OR 
	adr_final = ' ;  ; ' OR 
	adr_final = ' .' OR 
	adr_final = '  ;  ; ' OR 
	adr_final = ' ;  ; ' OR 
	adr_final = '.,.' OR 
	adr_final = "' ',' '" OR 
	adr_final = '/' OR 
	adr_final = '/,/' OR 
	adr_final = ' ;  ; ' OR 
	adr_final = ' .' OR 
	adr_final = ' ;  ; ' OR 
	adr_final = '.,.' OR 
	adr_final = ';' OR 
	adr_final = '.,.' OR 
	adr_final = '...,...' OR 
	adr_final = '...' OR 
	adr_final = '....,....' OR 
	adr_final = '/' OR 
	adr_final = '//,//' OR 
	adr_final = '///,//' OR 
	adr_final = ' ;  ; ' OR
	adr_final = '..,..,CO' OR
	adr_final = '----'	OR
	adr_final = ' ; CH ; ' OR
	adr_final = '-' OR
	adr_final = '¨' OR
	adr_final = '_' OR
	adr_final = '---' OR
	adr_final = '-----' OR
	adr_final = '-C-, -C-'
	;

UPDATE `04_addr_list` 
SET `adr_final_norm_trim` = TRIM(`adr_final_norm`);
