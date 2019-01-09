 
 -- STEP 1 Inventors sequence equal to 1 
 
CREATE TABLE prob_legal AS 
SELECT appln.doc_std_name_id, tls208_doc_std_nms.doc_std_name, appln.person_id,appln.person_name,appln.invt_seq_nr
 FROM applt_addr_ifris as appln
 INNER JOIN tls208_doc_std_nms ON appln.doc_std_name_id = tls208_doc_std_nms.doc_std_name_id
 WHERE   appln.invt_seq_nr = 0 
 GROUP BY doc_std_name_id;
 
 
-- STEP 2 Inventors sequence different to 0

CREATE TABLE known AS 
SELECT appln.doc_std_name_id, tls208_doc_std_nms.doc_std_name,appln.person_id,appln.person_name,appln.invt_seq_nr
 FROM  applt_addr_ifris as appln
 INNER JOIN tls208_doc_std_nms ON appln.doc_std_name_id = tls208_doc_std_nms.doc_std_name_id
 WHERE appln.invt_seq_nr > 0 
 GROUP BY doc_std_name_id;

-- CLEAN REPEATED DATA
DELETE FROM known WHERE known.doc_std_name_id in (SELECT  prob_lega.doc_std_name_id FROM prob_legal);

-- STEP 3  Where source is different to “Missing”

CREATE TABLE prob_person AS
 SELECT  person_id, person_name, doc_std_id, doc_std_name_id, invt_seq_nr
 FROM    t_juan.set1
 WHERE   doc_std_id IN (SELECT invt_addr_ifris.doc_std_name_id FROM invt_addr_ifris WHERE source <> "MISSING");
 
-- CLEAN REPEATED DATA
DELETE FROM known WHERE known.doc_std_name_id in (SELECT prob_person.doc_std_name_id FROM prob_person); 

-- STEP 4 The applicants with no more than 1 application

INSERT INTO prob_person
SELECT   
		 a.person_id,
		 a.person_name,	 
		 a.doc_std_name_id,
		 a.doc_std_name,
		 a.invt_seq_nr
FROM     unkown as a
INNER JOIN applt_addr_ifris AS b ON a.doc_std_name_id = b.doc_std_name_id  
GROUP BY doc_std_name_id
HAVING   COUNT(a.doc_std_name_id) < 2

-- CLEAN REPEATED DATA
DELETE FROM known WHERE known.doc_std_name_id in (SELECT prob_person.doc_std_name_id FROM prob_person); 

-- STEP 5 From probable legal to probable person set

INSERT INTO prob_person
SELECT   
		 a.person_id,
		 a.person_name,	 
		 a.doc_std_name_id,
		 a.doc_std_name,
		 a.invt_seq_nr
FROM     prob_legal as a
INNER JOIN applt_addr_ifris AS b ON a.doc_std_name_id = b.doc_std_name_id  
WHERE a.doc_std_name_id IN (SELECT doc_std_name_id FROM invt_addr_ifris)
GROUP BY doc_std_name_id
HAVING   COUNT(a.doc_std_name_id) < 21
ORDER BY COUNT(a.doc_std_name_id) DESC 


-- CLEAN REPEATED DATA
DELETE FROM prob_legal WHERE prob_legal.doc_std_name_id in (SELECT doc_std_name_id FROM prob_person); 

-- STEP 6 From probable legal to probable person set2

INSERT INTO prob_person
  SELECT   
		 a.person_id,
		 a.person_name,	 
		 a.doc_std_name_id,
		 a.doc_std_name,
		 a.invt_seq_nr
FROM     prob_legal as a
INNER JOIN applt_addr_ifris AS b ON a.doc_std_name_id = b.doc_std_name_id  
WHERE (a.person_name LIKE "%,%" OR a.person_name LIKE "%;%") AND (a.doc_std_name_id IN (SELECT doc_std_name_id FROM invt_addr_ifris))
GROUP BY doc_std_name_id
HAVING   COUNT(a.doc_std_name_id) < 200

-- CLEAN REPEATED DATA
DELETE FROM prob_legal WHERE prob_legal in (SELECT prob_person.doc_std_name_id FROM prob_person); 


-- STEP 7 Create temporal table

CREATE TABLE temporal AS
 SELECT
	   a.person_id,
	   a.person_name,	 
	   a.doc_std_name_id,
	   a.invt_seq_nr,
	   a.cnt,
	   b.cnt as cnt2
	FROM (
	  SELECT 
	  person_id,
	  person_name,	 
	  doc_std_name_id,
	  invt_seq_nr,
	  count(*) as cnt
	  from applt_addr_ifris
	  where invt_seq_nr < 1
	  GROUP BY doc_std_name_id
	) AS a
	INNER JOIN (
	  SELECT 
	  doc_std_name_id,
	  count(*) as cnt
	  from applt_addr_ifris
	  where invt_seq_nr > 0
	  GROUP BY doc_std_name_id
	) AS b ON a.doc_std_name_id = b.doc_std_name_id
HAVING (a.cnt*100 / (b.cnt + a.cnt)) < 20 

-- CLEAN REPEATED DATA
DELETE FROM prob_legal WHERE prob_legal.doc_std_name_id in (SELECT doc_std_name_id FROM temporal); 
