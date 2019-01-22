 USE `your_database`;

-- STEP 1 Create table with probably legal entities where inventors sequence is equal than 1 
CREATE TABLE entities_recognition_probably_legal AS
SELECT doc_std_name_id,
       doc_std_name,
       person_id,
       person_name,
       invt_seq_nr
FROM applt_addr_ifris
WHERE invt_seq_nr = 0
GROUP BY doc_std_name_id;
 
-- STEP 2 Create table with unkown entities where inventors sequence is different than 0
CREATE TABLE entities_recognition_unkown AS
SELECT doc_std_name_id,
       doc_std_name,
       person_id,
       person_name,
       invt_seq_nr
FROM applt_addr_ifris
WHERE invt_seq_nr > 0
GROUP BY doc_std_name_id;

-- Cleaning repeated data
DELETE
FROM entities_recognition_unkown
WHERE doc_std_name_id IN
    (SELECT doc_std_name_id
     FROM entities_recognition_probably_legal);

-- STEP 3  Create table with probably individuals where source is different than “Missing”
CREATE TABLE entities_recognition_probably_person AS
SELECT doc_std_name_id,
       doc_std_name,
       person_id,
       person_name,
       invt_seq_nr
FROM entities_recognition_unkown
WHERE doc_std_name_id IN
    (SELECT doc_std_name_id
     FROM invt_addr_ifris
     WHERE SOURCE <> "MISSING");

-- Cleaning repeated data
DELETE
FROM entities_recognition_unkown
WHERE doc_std_name_id IN
    (SELECT doc_std_name_id
     FROM entities_recognition_probably_person);

-- STEP 4 Insert the applicants with no more than 1 application
INSERT INTO entities_recognition_probably_person
SELECT a.doc_std_id,
       a.doc_std_name,
       a.person_id,
       a.person_name,
       a.invt_seq_nr
FROM entities_recognition_unkown AS a
INNER JOIN applt_addr_ifris AS b ON a.doc_std_name_id = b.doc_std_name_id
GROUP BY doc_std_name_id
HAVING COUNT(a.doc_std_name_id) < 2;

-- Cleaning data
DELETE
FROM entities_recognition_unkown
WHERE doc_std_name_id IN
    (SELECT doc_std_name_id
     FROM entities_recognition_probably_person);

-- STEP 5 Insert into probably person when the probably 
-- legal applicant has not more than 20 applications
INSERT INTO entities_recognition_probably_person
SELECT a.doc_std_id,
       a.doc_std_name,
       a.person_id,
       a.person_name,
       a.invt_seq_nr
FROM entities_recognition_probably_legal AS a
INNER JOIN applt_addr_ifris AS b ON a.doc_std_name_id = b.doc_std_name_id
WHERE a.doc_std_name_id IN
    (SELECT doc_std_name_id
     FROM invt_addr_ifris)
GROUP BY doc_std_name_id
HAVING COUNT(a.doc_std_name_id) < 21
ORDER BY COUNT(a.doc_std_name_id) DESC;

-- Cleaning data
DELETE
FROM entities_recognition_probably_legal
WHERE doc_std_name_id IN
    (SELECT doc_std_name_id
     FROM entities_recognition_probably_person);

-- STEP 6 From probably legal to probably person set
INSERT INTO entities_recognition_probably_person
SELECT a.doc_std_id,
       a.doc_std_name,
       a.person_id,
       a.person_name,
       a.invt_seq_nr
FROM entities_recognition_probably_legal AS a
INNER JOIN applt_addr_ifris AS b ON a.doc_std_name_id = b.doc_std_name_id
WHERE (a.person_name LIKE "%,%"
       OR a.person_name LIKE "%;%")
  AND (a.doc_std_name_id IN
         (SELECT doc_std_name_id
          FROM invt_addr_ifris))
GROUP BY doc_std_name_id
HAVING Count(a.doc_std_name_id) < 200;

-- Cleaning data
DELETE
FROM entities_recognition_probably_legal
WHERE doc_std_name_id IN
    (SELECT doc_std_name_id
     FROM entities_recognition_probably_person);

-- STEP 7 Creating temporal table
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
