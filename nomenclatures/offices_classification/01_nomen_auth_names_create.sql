-- ---------------------------------------------------------------------------------
-- Gnupablo and Lionel Villard
-- 2016/04/05
-- Building the nomenclature table of names of all patent offices 
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
  `acronym` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `status` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`appln_auth`),
  KEY `i01` (`auth_name` ASC),
  KEY `i02` (`appln_auth` ASC, `auth_name` ASC)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ---------------------------------------------------------------------------------
-- Building section

-- We created a cvs file from the txt file (https://wiki.epfl.ch/patstat/documents/country/country_codes.txt) 
-- and later it was imported into "nomen_appln_auth" table

LOAD DATA LOCAL INFILE '...\/nomen_appln_auth.csv' INTO TABLE nomen_appln_auth FIELDS TERMINATED BY ',';

-- Deprecate codes from tls201_appln
-- then we instert this codes with this insert statement

INSERT INTO nomen_appln_auth (nomen_appln_auth.appln_auth)
SELECT a.appln_auth
FROM tls201_appln AS a
    LEFT JOIN nomen_appln_auth AS b ON a.appln_auth = b.appln_auth
WHERE b.appln_auth IS NULL
GROUP BY a.appln_auth;


-- ---------------------------------------------------------------------------------
-- Cleaning section

-- Finally we insert the patent authority names that are missing
-- i.e. addind new appln_auth that exist in patstat but not in the csv list 

LOCK TABLES `nomen_appln_auth` WRITE;
ALTER TABLE `nomen_appln_auth` DISABLE KEYS;

UPDATE `nomen_appln_auth` SET `auth_name`='Serbia and Montenegro', `status`='deprecate' WHERE `appln_auth` ='CS';
UPDATE `nomen_appln_auth` SET `auth_name`='Unknown', `status`='unknown' WHERE `appln_auth` ='ZZ';
UPDATE `nomen_appln_auth` SET `auth_name`='Unknown', `status`='deprecate' WHERE `appln_auth` ='11';
UPDATE `nomen_appln_auth` SET `auth_name`='Unknown', `status`='deprecate' WHERE `appln_auth` ='AA';
UPDATE `nomen_appln_auth` SET `auth_name`='German Democratic Republic', `status`='deprecate' WHERE `appln_auth` ='DD';
UPDATE `nomen_appln_auth` SET `auth_name`='Unknown', `status`='deprecate' WHERE `appln_auth` ='RE';
UPDATE `nomen_appln_auth` SET `auth_name`='Unknown', `status`='deprecate' WHERE `appln_auth` ='RH';
UPDATE `nomen_appln_auth` SET `auth_name`='Soviet Union', `status`='deprecate' WHERE `appln_auth` ='SU';
UPDATE `nomen_appln_auth` SET `auth_name`='Unknown', `status`='deprecate' WHERE `appln_auth` ='TP';
UPDATE `nomen_appln_auth` SET `auth_name`='Unknown', `status`='deprecate' WHERE `appln_auth` ='U9';
UPDATE `nomen_appln_auth` SET `auth_name`='Unknown', `status`='deprecate' WHERE `appln_auth` ='W0';
UPDATE `nomen_appln_auth` SET `auth_name`='Unknown', `status`='deprecate' WHERE `appln_auth` ='XH';
UPDATE `nomen_appln_auth` SET `auth_name`='Unknown', `status`='deprecate' WHERE `appln_auth` ='XP';
UPDATE `nomen_appln_auth` SET `auth_name`='Yugoslavia', `status`='deprecate' WHERE `appln_auth` ='YU';
UPDATE `nomen_appln_auth` SET `auth_name`='Unknown', `status`='deprecate' WHERE `appln_auth` ='ZR';

-- Useful information, acronyms and cleaning
UPDATE `nomen_appln_auth` SET `nomen_appln_auth`='' WHERE `appln_auth`='EH';
UPDATE `nomen_appln_auth` SET `acronym`='' WHERE `appln_auth`='IR';
UPDATE `nomen_appln_auth` SET `acronym`='' WHERE `appln_auth`='VG';
UPDATE `nomen_appln_auth` SET `acronym`='INPI' WHERE `appln_auth`='FR';
UPDATE `nomen_appln_auth` SET `acronym`='SIPO' WHERE `appln_auth`='CN';
UPDATE `nomen_appln_auth` SET `auth_name`='Japan Patent Office', `acronym`='JPO' WHERE `appln_auth`='JP';
UPDATE `nomen_appln_auth` SET `auth_name`='World Intellectual Property Organization' WHERE `appln_auth`='WO';
UPDATE `nomen_appln_auth` SET `acronym`='IPO' WHERE `appln_auth`='GB';
UPDATE `nomen_appln_auth` SET `auth_name`='German Patent and Trade Mark Office', `acronym`='DPMA' WHERE `appln_auth`='DE';
UPDATE `nomen_appln_auth` SET `auth_name`='United States Patent and Trademark Office', `acronym`='USPTO' WHERE `appln_auth`='US';

ALTER TABLE `nomen_appln_auth` ENABLE KEYS;
UNLOCK TABLES;