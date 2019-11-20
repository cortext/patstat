delimiter $$
CREATE DEFINER=``@`` FUNCTION `normalise_specialChars`(myString text) RETURNS text CHARSET utf8
    READS SQL DATA
    DETERMINISTIC
BEGIN
  DECLARE output text;
    SET output = REPLACE(myString,';',' ');
    SET output =  REPLACE(output,'.',' ');
	SET output =  REPLACE(output,'<P>',' ');
	SET output =  REPLACE(output,'</P>',' ');
	SET output =  REPLACE(output,'<IMAGE>',' ');
	SET output =  REPLACE(output,'<SP>',' ');
	SET output =  REPLACE(output,'</SP>',' ');
	SET output =  REPLACE(output,'<sub>',' ');
	SET output =  REPLACE(output,'</sub>',' ');
	SET output =  REPLACE(output,'<sup>',' ');
	SET output =  REPLACE(output,'</sup>',' ');
	SET output =  REPLACE(output,'<i>',' ');
	SET output =  REPLACE(output,'</i>',' ');
	SET output =  REPLACE(output,'<CHEM>',' ');
	SET output =  REPLACE(output,'</CHEM>',' ');
	SET output =  REPLACE(output,'?',' ');
	SET output =  REPLACE(output,':',' ');
	SET output =  REPLACE(output,':',' ');
	SET output =  REPLACE(output,'<',' ');
	SET output =  REPLACE(output,'>',' ');
	SET output =  REPLACE(output,'&',' and ');
	SET output =  REPLACE(output,'$',' ');
	SET output =  REPLACE(output,'\\',' ');
	SET output =  REPLACE(output,'\/',' ');
	SET output =  REPLACE(output,'\'',' ');
	SET output =  REPLACE(output,'\"',' ');
	SET output =  REPLACE(output,'{',' ');
	SET output =  REPLACE(output,'}',' ');
	SET output =  REPLACE(output,'[',' ');
	SET output =  REPLACE(output,']',' ');
	SET output =  REPLACE(output,'(',' ');
	SET output =  REPLACE(output,')',' ');
	SET output =  REPLACE(output,'\`',' ');
	SET output =  REPLACE(output,'!',' ');
	SET output =  REPLACE(output,'  ',' ');
	SET output =  REPLACE(output,'  ',' ');
	SET output =  REPLACE(output,'  ',' ');
  RETURN output;
END$$