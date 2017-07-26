CREATE DEFINER=`gnupablo`@`%` FUNCTION `t_juan`.`surname_detect`(myString VARCHAR(300)) RETURNS varchar(300) CHARSET utf8
    READS SQL DATA
BEGIN
	
    DECLARE done INT DEFAULT FALSE;    
    DECLARE Tag VARCHAR(15);
    DECLARE surn VARCHAR(50);
    DECLARE regex VARCHAR(300);
    
    
    DECLARE curs CURSOR FOR 
        SELECT surname FROM surname;
     -- declare NOT FOUND handler
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
  	OPEN curs;
  	
  	get_surname: LOOP
  		FETCH curs INTO surn;
  		
  		
  		SET regex = CONCAT('( |^)',surn,'([^a-zA-Z0-9_]|$)');
  		IF myString regexp(regex) THEN 
  		 	SET Tag = 'person';
  		END IF;
   	    
  		IF Tag = 'person' THEN
			LEAVE get_surname;
   	    END IF;
   	    
   	   IF done THEN 
 			LEAVE get_surname;
 	   END IF;

        END LOOP;
   
        CLOSE curs;

    RETURN Tag;
END 
