-- Authors: xmrkviv00, xjaluvo00
-- Assignment no. 21: Knihovna 1 
-- Part 4
DROP MATERIALIZED VIEW mat_immediate;
DROP MATERIALIZED VIEW mat_deferred;

CREATE MATERIALIZED VIEW mat_immediate
BUILD IMMEDIATE
REFRESH ON DEMAND
AS
SELECT * FROM xjaluvo00.Users;

CREATE MATERIALIZED VIEW mat_deferred
BUILD DEFERRED 
REFRESH ON DEMAND
AS
SELECT * FROM xjaluvo00.Users;

-- Has records imported upon creation
SELECT * FROM mat_immediate;
-- Doesn't have records imported upon creation
SELECT * FROM mat_deferred;

BEGIN
    DBMS_MVIEW.REFRESH('mat_deferred');
END;
/

-- Now it has records
SELECT * FROM mat_deferred;

-- This would be same for mat_deferred and mat_immediate as both refresh on demand
-- Inserting new user, the view 'mat_immediate' will not get updated until it asks for update 
-- @note using the trigger 
INSERT INTO xjaluvo00.Users (username, fname, lname, password, email, phone_number, street, city, PIN, user_role, staff_position)
VALUES ('MaterializedNickName', 'Tralalero', 'Tralala', 'asdjhfjajwekjkndjkasnasXCSewew', 'jaws@example.com', '777777777', 'Na Mocarku 21', 'Ostrava', '72400', 'Reader', NULL);

-- This doesn't have 'Tralalero' 'Tralala'
SELECT * FROM mat_immediate;
-- This has 'Tralalero' 'Tralala'
SELECT * FROM xjaluvo00.Users;

-- Updating the view
BEGIN 
    DBMS_MVIEW.REFRESH('mat_immediate');
END; 
/

-- Now the view has 'Tralalero' 'Tralala' as well
SELECT * FROM mat_immediate;

-- clean up
DELETE FROM xjaluvo00.Users 
WHERE username = 'MaterializedNickName';