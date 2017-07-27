CREATE DEFINER=`gnupablo`@`%` FUNCTION `t_juan`.`individual_detection`(myString VARCHAR(300)) RETURNS varchar(15) CHARSET utf8
    READS SQL DATA
    DETERMINISTIC
BEGIN
    DECLARE Tag VARCHAR(15);
    
          IF myString regexp('( |^)GEB([^a-zA-Z0-9_]|$)') THEN SET  Tag = 'natural person';
    ELSEIF myString regexp('( |^)DECEASED([^a-zA-Z0-9_]|$)') THEN SET  Tag = 'natural person';
    ELSEIF myString regexp('( |^)DECEDE([^a-zA-Z0-9_]|$)') THEN SET  Tag = 'natural person';
    ELSEIF myString regexp('( |^)DESEASED([^a-zA-Z0-9_]|$)') THEN SET  Tag = 'natural person';
    ELSEIF myString regexp('( |^)DIPL([^a-zA-Z0-9_]|$)') THEN SET  Tag = 'natural person';
    ELSEIF myString regexp('( |^)DIPL BETRIEBSWIRT([^a-zA-Z0-9_]|$)') THEN SET  Tag = 'natural person';
    ELSEIF myString regexp('( |^)DIPL CHEM([^a-zA-Z0-9_]|$)') THEN SET  Tag = 'natural person';
    ELSEIF myString regexp('( |^)DIPL GEOGR([^a-zA-Z0-9_]|$)') THEN SET  Tag = 'natural person';
    ELSEIF myString regexp('( |^)DIPL ING([^a-zA-Z0-9_]|$)') THEN SET  Tag = 'natural person';
    ELSEIF myString regexp('( |^)DIPL ING([^a-zA-Z0-9_]|$)') THEN SET  Tag = 'natural person';
    ELSEIF myString regexp('( |^)DIPL PHYS([^a-zA-Z0-9_]|$)') THEN SET  Tag = 'natural person';
    ELSEIF myString regexp('( |^)DIPL PHYS([^a-zA-Z0-9_]|$)') THEN SET  Tag = 'natural person';
    ELSEIF myString regexp('( |^)DIPL WIRTSCH ING([^a-zA-Z0-9_]|$)') THEN SET  Tag = 'natural person';
    ELSEIF myString regexp('( |^)DOTT ING([^a-zA-Z0-9_]|$)') THEN SET  Tag = 'natural person';
    ELSEIF myString regexp('( |^)DR([^a-zA-Z0-9_]|$)') THEN SET  Tag = 'natural person';
    ELSEIF myString regexp('( |^)EPOSE([^a-zA-Z0-9_]|$)') THEN SET  Tag = 'natural person';
    ELSEIF myString regexp('( |^)EPOUSE([^a-zA-Z0-9_]|$)') THEN SET  Tag = 'natural person';
    ELSEIF myString regexp('( |^)EPSE([^a-zA-Z0-9_]|$)') THEN SET  Tag = 'natural person';
    ELSEIF myString regexp('( |^)GEBOREN([^a-zA-Z0-9_]|$)') THEN SET  Tag = 'natural person';
    ELSEIF myString regexp('( |^)GEBORENE([^a-zA-Z0-9_]|$)') THEN SET  Tag = 'natural person';
    ELSEIF myString regexp('( |^)GES VERTRETEN DURCH([^a-zA-Z0-9_]|$)') THEN SET  Tag = 'natural person';
    ELSEIF myString regexp('( |^)GRAD([^a-zA-Z0-9_]|$)') THEN SET  Tag = 'natural person';
    ELSEIF myString regexp('( |^)HERITIERE([^a-zA-Z0-9_]|$)') THEN SET  Tag = 'natural person';
    ELSEIF myString regexp('( |^)ING([^a-zA-Z0-9_]|$)') THEN SET  Tag = 'natural person';
    ELSEIF myString regexp('( |^)ING GRAD([^a-zA-Z0-9_]|$)') THEN SET  Tag = 'natural person';
    ELSEIF myString regexp('( |^)ING DIPL([^a-zA-Z0-9_]|$)') THEN SET  Tag = 'natural person';
    ELSEIF myString regexp('( |^)JR([^a-zA-Z0-9_]|$)') THEN SET  Tag = 'natural person'; 
    ELSEIF myString regexp('( |^)LA SUCCESSION([^a-zA-Z0-9_]|$)') THEN SET  Tag = 'natural person';
    ELSEIF myString regexp('( |^)LEGAL([^a-zA-Z0-9_]|$)') THEN SET  Tag = 'natural person';
    ELSEIF myString regexp('( |^)LEGALLY REPR([^a-zA-Z0-9_]|$)') THEN SET  Tag = 'natural person';
    ELSEIF myString regexp('( |^)LEGALLY REPRESENTED([^a-zA-Z0-9_]|$)') THEN SET  Tag = 'natural person';
    ELSEIF myString regexp('( |^)LEGALY REPRESENTED BY([^a-zA-Z0-9_]|$)') THEN SET  Tag = 'natural person';
    ELSEIF myString regexp('( |^)NEE([^a-zA-Z0-9_]|$)') THEN SET  Tag = 'natural person';
    ELSEIF myString regexp('( |^)PHD([^a-zA-Z0-9_]|$)') THEN SET  Tag = 'natural person';
    ELSEIF myString regexp('( |^)PROF([^a-zA-Z0-9_]|$)') THEN SET  Tag = 'natural person';
    ELSEIF myString regexp('( |^)REPRESENTATIVE OF([^a-zA-Z0-9_]|$)') THEN SET  Tag = 'natural person';
    ELSEIF myString regexp('( |^)REPRESENTEE PAR SON LEGAL([^a-zA-Z0-9_]|$)') THEN SET  Tag = 'natural person';
    ELSEIF myString regexp('( |^)VERSTORBEN([^a-zA-Z0-9_]|$)') THEN SET  Tag = 'natural person';
    ELSEIF myString regexp('( |^)VERSTORBEN ERFINDERS([^a-zA-Z0-9_]|$)') THEN SET  Tag = 'natural person';
    ELSEIF myString regexp('( |^)VERSTORBENEN ERFINDERS([^a-zA-Z0-9_]|$)') THEN SET  Tag = 'natural person';
    ELSEIF myString regexp('( |^)VERTRETEN DURCH([^a-zA-Z0-9_]|$)') THEN SET  Tag = 'natural person';

    END IF;
    RETURN Tag;
END 
