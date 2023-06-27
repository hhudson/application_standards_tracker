-- The error 'ORA-12838: cannot read/modify an object after modifying it in parallel' can be solved with the following query
INSERT INTO DATABASECHANGELOGLOCK (ID, LOCKED) VALUES (1, 0)
/