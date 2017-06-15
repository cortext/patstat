 
 -- STEP 1 Inventors sequence equal to 1 
 
CREATE TABLE prob_legal AS 
SELECT  appln.doc_std_name_id,patstatAvr2014.tls208_doc_std_nms.doc_std_name,appln.person_id,appln.person_name,appln.invt_seq_nr
 FROM    patstatAvr2014.applt_addr_ifris as appln
 INNER JOIN patstatAvr2014.tls208_doc_std_nms ON appln.doc_std_name_id = patstatAvr2014.tls208_doc_std_nms.doc_std_name_id
 WHERE   appln.invt_seq_nr = 0 
 GROUP BY doc_std_name_id;
 
