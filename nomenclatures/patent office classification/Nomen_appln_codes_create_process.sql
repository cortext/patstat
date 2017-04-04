-- ---------------------------------------------------------------------------------
-- Gnupablo
-- 23/01/2016
-- Create statement with the all explained process    
-- ---------------------------------------------------------------------------------

USE `t_juan`;

DROP TABLE IF EXISTS `nomen_appln_auth`;

CREATE TABLE `nomen_appln_auth` (
  `appln_auth` varchar(2) COLLATE utf8_unicode_ci NOT NULL,
  `appln_name` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `nomen_appln_auth` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `status` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`appln_auth`),
  KEY `appln_auth` (`appln_auth`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- We created a cvs file from the txt file (https://wiki.epfl.ch/patstat/documents/country/country_codes.txt) 
-- and later it was imported into "nomen_appln_auth" table

LOAD DATA LOCAL INFILE 'D:\nomen_appln_auth.csv' INTO TABLE nomen_appln_auth FIELDS TERMINATED BY ',';

-- From the query 1.1 we realized that left some deprecate codes from the patstatAvr2014.tls201_appln
-- then we instert this codes with this insert statement

INSERT INTO nomen_appln_auth (nomen_appln_auth.appln_auth)
SELECT patstatAvr2014.tls201_appln.appln_auth
FROM patstatAvr2014.tls201_appln
    LEFT JOIN nomen_appln_auth ON (patstatAvr2014.tls201_appln.appln_auth = nomen_appln_auth.appln_auth)
WHERE nomen_appln_auth.appln_auth IS NULL
GROUP BY patstatAvr2014.tls201_appln.appln_auth;
  
-- Finally we insert manually the next additional information

LOCK TABLES `nomen_appln_auth` WRITE;
/*!40000 ALTER TABLE `nomen_appln_auth` DISABLE KEYS */;
INSERT INTO `nomen_appln_auth` VALUES ('CS','Serbia and Montenegro',NULL,'deprecate'),('ZZ','Unknown',NULL,'unknown'),('11','Unknown',NULL,'deprecate'),('AA','Unknown',NULL,'deprecate'),('DD','German Democratic Republic',NULL,'deprecate'),('RE','Unknown',NULL,'deprecate'),('RH','Unknown',NULL,'deprecate'),('SU','Soviet Union',NULL,'deprecate'),('TP','Unknown',NULL,'deprecate'),('U9','Unknown',NULL,'deprecate'),('W0','Unknown',NULL,'deprecate'),('XH','Unknown',NULL,'deprecate'),('XP','Unknown',NULL,'deprecate'),('YU','Yugoslavia',NULL,'deprecate'),('ZR','Unknown',NULL,'deprecate');
/*!40000 ALTER TABLE `nomen_appln_auth` ENABLE KEYS */;
UNLOCK TABLES;