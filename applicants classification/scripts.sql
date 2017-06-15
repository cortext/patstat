 
 -- STEP 1 Inventors sequence equal to 1 
 
CREATE TABLE prob_legal AS 
SELECT  appln.doc_std_name_id,patstatAvr2014.tls208_doc_std_nms.doc_std_name,appln.person_id,appln.person_name,appln.invt_seq_nr
 FROM    patstatAvr2014.applt_addr_ifris as appln
 INNER JOIN patstatAvr2014.tls208_doc_std_nms ON appln.doc_std_name_id = patstatAvr2014.tls208_doc_std_nms.doc_std_name_id
 WHERE   appln.invt_seq_nr = 0 
 GROUP BY doc_std_name_id;
 
 
-- STEP 2 Inventors sequence different to 0

CREATE TABLE known AS 
SELECT  appln.doc_std_name_id,patstatAvr2014.tls208_doc_std_nms.doc_std_name,appln.person_id,appln.person_name,appln.invt_seq_nr
 FROM    patstatAvr2014.applt_addr_ifris as appln
 INNER JOIN patstatAvr2014.tls208_doc_std_nms ON appln.doc_std_name_id = patstatAvr2014.tls208_doc_std_nms.doc_std_name_id
 WHERE appln.invt_seq_nr > 0 
 GROUP BY doc_std_name_id;

-- CLEAN REPEATED DATA
DELETE FROM known WHERE known.doc_std_name_id in (SELECT  prob_lega.doc_std_name_id FROM prob_lega);

-- STEP 3  Where source is different to “Missing”

CREATE TABLE prob_person AS
 SELECT  person_id, person_name, doc_std_id, doc_std_name_id, invt_seq_nr
 FROM    t_juan.set1
 WHERE   doc_std_id IN (SELECT invt_addr_ifris.doc_std_name_id FROM patstatAvr2014.invt_addr_ifris WHERE source <> "MISSING");
 
-- CLEAN REPEATED DATA
DELETE FROM known WHERE known.doc_std_name_id in (SELECT prob_person.doc_std_name_id FROM prob_person); 
