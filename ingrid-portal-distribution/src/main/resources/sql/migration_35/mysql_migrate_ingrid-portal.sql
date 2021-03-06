
-- Update Jetspeed 2.1 to 2.1.2
-- ============================

-- ---------------------------------------------------------------------------
-- ADMIN_ACTIVITY
-- ---------------------------------------------------------------------------
drop table if exists ADMIN_ACTIVITY;

CREATE TABLE ADMIN_ACTIVITY
(
  ACTIVITY VARCHAR(40),
  CATEGORY VARCHAR(40),
  ADMIN VARCHAR(80),
  USER_NAME VARCHAR(80),
  TIME_STAMP TIMESTAMP,
  IPADDRESS VARCHAR(80),
  ATTR_NAME VARCHAR(40),
  ATTR_VALUE_BEFORE VARCHAR(80),
  ATTR_VALUE_AFTER VARCHAR(80),
  DESCRIPTION VARCHAR(128));

-- ---------------------------------------------------------------------------
-- USER_ACTIVITY
-- ---------------------------------------------------------------------------
drop table if exists USER_ACTIVITY;

CREATE TABLE USER_ACTIVITY
(
  ACTIVITY VARCHAR(40),
  CATEGORY VARCHAR(40),
  USER_NAME VARCHAR(80),
  TIME_STAMP TIMESTAMP,
  IPADDRESS VARCHAR(80),
  ATTR_NAME VARCHAR(40),
  ATTR_VALUE_BEFORE VARCHAR(80),
  ATTR_VALUE_AFTER VARCHAR(80),
  DESCRIPTION VARCHAR(128));


-- Update Jetspeed 2.1.2 to 2.1.3
-- ==============================

-- Schon vorhanden !?
-- CREATE INDEX IX_PREFS_NODE_1 ON PREFS_NODE (PARENT_NODE_ID);
-- CREATE INDEX IX_PREFS_NODE_2 ON PREFS_NODE (FULL_PATH);
-- CREATE INDEX IX_FKPPV_1 ON PREFS_PROPERTY_VALUE (NODE_ID);

ALTER TABLE PREFS_NODE ADD CONSTRAINT FK_PREFS_NODE_1 FOREIGN KEY (PARENT_NODE_ID) REFERENCES PREFS_NODE (NODE_ID) ON DELETE CASCADE;
ALTER TABLE PREFS_PROPERTY_VALUE ADD CONSTRAINT FK_PREFS_PROPERTY_VALUE_1 FOREIGN KEY (NODE_ID) REFERENCES PREFS_NODE (NODE_ID) ON DELETE CASCADE;


-- Update Jetspeed 2.1.3 to 2.1.4
-- ==============================

ALTER TABLE PARAMETER MODIFY PARAMETER_VALUE MEDIUMTEXT NULL;

ALTER TABLE FRAGMENT ADD FRAGMENT_STRING_ID VARCHAR(80);
ALTER TABLE FRAGMENT ADD UNIQUE (FRAGMENT_STRING_ID);


-- Already update InGrid Portal Database Version (though not finished yet)
-- =======================================================================

UPDATE ingrid_lookup SET item_value = '3.5.0', item_date = NOW() WHERE ingrid_lookup.item_key ='ingrid_db_version';
