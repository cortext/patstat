-- ---------------------------------------------------------------------------------
--
-- Gnupablo and Lionel Villard
-- 2016/04/18
-- Building the ipc tables  
--
-- ---------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------
-- Database

USE `t_juan`;

-- ---------------------------------------------------------------------------------
-- DROP TABLE position

DROP TABLE IF EXISTS `ipc_position`;

-- ---------------------------------------------------------------------------------
-- CREATE TABLE position

CREATE TABLE `ipc_position` (
  `ipc_code` varchar(15) NOT NULL,
  `section` varchar(1000) DEFAULT NULL,
  `class` varchar(1000) DEFAULT NULL,
  `subclass` varchar(1000) DEFAULT NULL,
  `full_subclass` varchar(1000) DEFAULT NULL,
  `ipc_version` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ipc_code`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ---------------------------------------------------------------------------------
-- Building position from a csv file

LOAD DATA LOCAL INFILE '...\/01_ipc_position.output.csv' 
INTO TABLE ipc_position FIELDS TERMINATED BY "\t" LINES TERMINATED BY "\n"
(@ipc_code, @section, @class, @subclass, @full_subclass, @ipc_version)
SET
ipc_code = nullif(@ipc_code,''),
section = nullif(@section,''),
class = nullif(@class,''),
subclass = nullif(@subclass,''),
full_subclass = nullif(@full_subclass,''),
ipc_version = nullif(@ipc_version,'');


-- ---------------------------------------------------------------------------------
-- DROP TABLE description

DROP TABLE IF EXISTS `ipc_description`;

-- ---------------------------------------------------------------------------------
-- CREATE TABLE description

CREATE TABLE `ipc_description` (
  `ipc_code` varchar(15) NOT NULL,
  `ipc_position` varchar(100) DEFAULT NULL,
  `ipc_description` varchar(10000) DEFAULT NULL,
  `level` int(11) DEFAULT NULL,
  `ipc_version` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`ipc_code`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ---------------------------------------------------------------------------------
-- Building description from a csv file

LOAD DATA LOCAL INFILE '...\/02_ipc_description.output.csv' 
INTO TABLE ipc_description FIELDS TERMINATED BY "\t" LINES TERMINATED BY "\n"
(@ipc_code, @ipc_position, @ipc_description, @level, @ipc_version)
SET
ipc_code = nullif(@ipc_code,''),
ipc_position = nullif(@ipc_position,''),
ipc_description = nullif(@ipc_description,''),
level = nullif(@level,''),
ipc_version = nullif(@ipc_version,'');


-- ---------------------------------------------------------------------------------
-- DROP TABLE ipc

DROP TABLE IF EXISTS `ipc_synom`;

-- ---------------------------------------------------------------------------------
-- CREATE TABLE ipc_synom

CREATE TABLE `ipc_synom` (
  `ipc_code` varchar(15) NOT NULL,
  `description` varchar(1000) DEFAULT NULL,
  `ipc_version` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ipc_code`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ---------------------------------------------------------------------------------
-- Building ipc_synom from a csv file

LOAD DATA LOCAL INFILE '...\/03_ipc_list.output.csv' 
INTO TABLE ipc_synom FIELDS TERMINATED BY "\t" LINES TERMINATED BY "\n"
(@ipc_code, @description, @ipc_version)
SET
ipc_code = nullif(@ipc_code,''),
description = nullif(@description,''),
ipc_version = nullif(@ipc_version,'');


-- ---------------------------------------------------------------------------------
-- DROP TABLE ipc hierarchy

DROP TABLE IF EXISTS `ipc_hierarchy`;

-- ---------------------------------------------------------------------------------
-- CREATE TABLE ipc_hierarchy

CREATE TABLE `ipc_hierarchy` (
  `ipc_code` varchar(15) NOT NULL,
  `ancestor` varchar(15) NOT NULL,
  `parent` varchar(15) NOT NULL,
  `ipc_version` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ipc_code`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ---------------------------------------------------------------------------------
-- Building ipc hierarchy from a csv file

LOAD DATA LOCAL INFILE '...\/04_ipc_hierarchy.output.csv' 
INTO TABLE ipc_hierarchy FIELDS TERMINATED BY "\t" LINES TERMINATED BY "\n"
(@ipc_code, @ancestor, @parent, @ipc_version)
SET
ipc_code = nullif(@ipc_code,''),
ancestor = nullif(@ancestor,''),
parent = nullif(@parent,''),
ipc_version = nullif(@ipc_version,'');

