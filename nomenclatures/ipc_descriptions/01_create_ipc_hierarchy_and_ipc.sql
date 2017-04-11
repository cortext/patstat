-- ---------------------------------------------------------------------------------
-- Gnupablo
-- 2016/04/11

-- Building the hierarchy table of all ipc codes
-- Create the list of ipc codes from https://worldwide.espacenet.com/classification/
-- with the t3as API
-- ---------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------
-- Database

USE `your_database`;

-- ---------------------------------------------------------------------------------
-- DROP TABLE section

DROP TABLE IF EXISTS `ipc_hierarchy`;

-- ---------------------------------------------------------------------------------
-- CREATE TABLE section

CREATE TABLE `ipc_hierarchy` (
	code varchar(100) NOT NULL,
	parent varchar(100) NULL,
	ancestor varchar(100) NULL,
	update_at TIMESTAMP NULL,
	created_at TIMESTAMP DEFAULT current_timestamp,
	CONSTRAINT ipc_hierarchy_PK PRIMARY KEY (code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci  

-- ---------------------------------------------------------------------------------
-- DROP TABLE section

DROP TABLE IF EXISTS `ipc`;

-- ---------------------------------------------------------------------------------
-- CREATE TABLE section

CREATE TABLE ipc (
	code varchar(100) NOT NULL,
	description varchar(500) NULL,
	version varchar(100) NULL,
	update_at TIMESTAMP NULL,
	created_at TIMESTAMP DEFAULT current_timestamp,
	CONSTRAINT ipc_PK PRIMARY KEY (code)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

