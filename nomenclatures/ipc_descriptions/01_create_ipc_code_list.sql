-- ---------------------------------------------------------------------------------
-- Lionel Villard
-- 2017/04/12
-- Build a list of all IPC code that are inside patstat
-- more than 71 000 ipc codes 
-- Time : around 15 min
-- ---------------------------------------------------------------------------------

USE `your_database`;

-- ---------------------------------------------------------------------------------
-- DROP TABLE section

DROP TABLE IF EXISTS `a03_01_all_ipc_codes`;

-- ---------------------------------------------------------------------------------
-- CREATE TABLE section

CREATE TABLE a03_01_all_ipc_codes 
	AS 
	SELECT ipc_class_symbol, MAX(ipc_version) AS last_ipc_version, COUNT(appln_id) AS NbAppln 
	FROM tls209_appln_ipc
GROUP BY ipc_class_symbol
ORDER BY ipc_class_symbol ASC;

-- ---------------------------------------------------------------------------------
-- Count number of distinct ipc code and volume of applications

SELECT 
    last_ipc_version,
    COUNT(ipc_class_symbol) AS NbDistinctIPCcodes,
    SUM(NbAppln) AS NbAppln
FROM
    a03_01_all_ipc_codes
GROUP BY last_ipc_version;