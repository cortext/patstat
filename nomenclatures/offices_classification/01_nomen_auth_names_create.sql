-- ---------------------------------------------------------------------------------
-- Gnupablo
-- Lionel Villard
-- 2016/04/05
-- Building the nomenclature table of complete names of all patent offices 
-- that are in Patstat
-- ---------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------
-- Database

USE `your_database`;

-- ---------------------------------------------------------------------------------
-- DROP TABLE section

DROP TABLE IF EXISTS `nomen_appln_auth`;

-- ---------------------------------------------------------------------------------
-- CREATE TABLE section

CREATE TABLE `nomen_appln_auth` (
  `appln_auth` varchar(2) COLLATE utf8_unicode_ci NOT NULL,
  `auth_name` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `nomen_appln_auth` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `status` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`appln_auth`),
  KEY `appln_auth` (`appln_auth`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ---------------------------------------------------------------------------------
-- Core section

-- We created a cvs file from the txt file (https://wiki.epfl.ch/patstat/documents/country/country_codes.txt) 
-- and later it was imported into "nomen_appln_auth" table

LOAD DATA LOCAL INFILE '...\/nomen_appln_auth.csv' INTO TABLE nomen_appln_auth FIELDS TERMINATED BY ',';

UPDATE `nomen_appln_auth` SET `nomen_appln_auth`='' WHERE `appln_auth`='EH';



-- Deprecate codes from tls201_appln
-- then we instert this codes with this insert statement

INSERT INTO nomen_appln_auth (nomen_appln_auth.appln_auth)
SELECT a.appln_auth
FROM tls201_appln AS a
    LEFT JOIN nomen_appln_auth AS b ON a.appln_auth = b.appln_auth
WHERE b.appln_auth IS NULL
GROUP BY a.appln_auth;
  
-- Finally we insert manually the patent authority names that are missing
-- i.e. appln_auth that exite in patstat but not in the csv list 

LOCK TABLES `nomen_appln_auth` WRITE;
/*!40000 ALTER TABLE `nomen_appln_auth` DISABLE KEYS */;
INSERT INTO `nomen_appln_auth` VALUES ('CS','Serbia and Montenegro','','deprecate'),('ZZ','Unknown','','unknown'),('11','Unknown','','deprecate'),('AA','Unknown','','deprecate'),('DD','German Democratic Republic','','deprecate'),('RE','Unknown','','deprecate'),('RH','Unknown','','deprecate'),('SU','Soviet Union','','deprecate'),('TP','Unknown','','deprecate'),('U9','Unknown','','deprecate'),('W0','Unknown','','deprecate'),('XH','Unknown','','deprecate'),('XP','Unknown','','deprecate'),('YU','Yugoslavia','','deprecate'),('ZR','Unknown','','deprecate');
/*!40000 ALTER TABLE `nomen_appln_auth` ENABLE KEYS */;
UNLOCK TABLES;