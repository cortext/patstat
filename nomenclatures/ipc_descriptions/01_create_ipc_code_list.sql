-- ---------------------------------------------------------------------------------
-- Lionel Villard
-- 2017/04/12
-- Build a list of all IPC code that are inside patstat
-- more than 71 000 ipc codes in more than 8 min
-- ---------------------------------------------------------------------------------

USE `your_database`;

-- ---------------------------------------------------------------------------------
-- DROP TABLE section

DROP TABLE IF EXISTS `a03_01_all_ipc_codes`;

-- ---------------------------------------------------------------------------------
-- CREATE TABLE section

CREATE TABLE a03_01_all_ipc_codes 
	AS 
	SELECT ipc_class_symbol, MAX(ipc_version) AS last_ipc_version, COUNT(appln_id) AS NbApplbn 
	FROM tls209_appln_ipc
GROUP BY ipc_class_symbol
ORDER BY ipc_class_symbol ASC;