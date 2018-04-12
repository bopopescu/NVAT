CREATE DEFINER=`root`@`localhost` PROCEDURE `LINK_INTRUDER_ACTIONS`(IN id1 int, IN id2 int)
BEGIN

DECLARE cid1, cid2 int default -1;
DECLARE int_id1, int_id2 int default -1;
DECLARE small_id int;

SELECT 
    common_id, intruder_id
INTO cid1 , int_id1 FROM
    intruder_in_action
WHERE
    id = id1;

SELECT 
    common_id, intruder_id
INTO cid2 , int_id2 FROM
    intruder_in_action
WHERE
    id = id2;

IF cid1 is null AND cid2 is null THEN
	IF int_id1 < int_id2 THEN
		set  small_id = int_id1;
	else
		set small_id = int_id2;
	end if;
    
	UPDATE intruder_in_action 
SET 
    common_id = small_id
WHERE
    id IN (id1 , id2);
ELSEIF cid1 is null then
	update intruder_in_action set common_id = cid2 where id in (id1);
ELSEIF cid2 is null then
	update intruder_in_action set common_id = cid1 where id in (id2);
ELSE
	IF cid1 < cid2 THEN
		set  small_id = cid1;
	else
		set small_id = cid2;
	end if;
    
	UPDATE intruder_in_action 
SET 
    common_id = small_id
WHERE
    common_id IN (cid1 , cid2);
END IF;

END