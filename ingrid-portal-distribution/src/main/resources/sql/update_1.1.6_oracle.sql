CREATE TABLE  ingrid_temp (
value NUMBER(10,0)
);

INSERT INTO ingrid_temp (VALUE) 
VALUES (
(SELECT parent_id FROM fragment WHERE name = 'ingrid-portal-apps::SearchCatalogThesaurus'));

INSERT INTO fragment (FRAGMENT_ID, PARENT_ID, PAGE_ID, NAME, TITLE, SHORT_TITLE, TYPE, SKIN, DECORATOR, STATE, PMODE, LAYOUT_ROW, LAYOUT_COLUMN, LAYOUT_SIZES, LAYOUT_X, LAYOUT_Y, LAYOUT_Z, LAYOUT_WIDTH, LAYOUT_HEIGHT, EXT_PROP_NAME_1, EXT_PROP_VALUE_1, EXT_PROP_NAME_2, EXT_PROP_VALUE_2, OWNER_PRINCIPAL) 
VALUES (
(SELECT max_key FROM ojb_hl_seq where tablename='SEQ_FRAGMENT'),
(SELECT value FROM ingrid_temp),
NULL, 'ingrid-portal-apps::SearchCatalogThesaurusResult', NULL, NULL, 'portlet', NULL, NULL, NULL, NULL, 0, 1, NULL, -1, -1, -1, -1, -1, NULL, NULL, NULL, NULL, NULL);

UPDATE ojb_hl_seq SET max_key=max_key+grab_size, version=version+1
WHERE tablename='SEQ_FRAGMENT';

DROP TABLE ingrid_temp PURGE; 



INSERT INTO ingrid_chron_eventtypes (id, form_value, query_value, sortkey) VALUES (13, 'ann', 'anniversary', 13);
INSERT INTO ingrid_chron_eventtypes (id, form_value, query_value, sortkey) VALUES (14, 'int', 'interYear', 14);
INSERT INTO ingrid_chron_eventtypes (id, form_value, query_value, sortkey) VALUES (15, 'obs', 'observation', 15);

UPDATE ingrid_chron_eventtypes SET form_value = 'leg', query_value = 'legal' WHERE form_value='law';
UPDATE ingrid_chron_eventtypes SET form_value = 'act', query_value = 'activity' WHERE form_value='ini';
UPDATE ingrid_chron_eventtypes SET query_value = 'natureOfTheYear' WHERE query_value='ofTheYear';

CREATE TABLE  eventtypes_temp (
	query_value VARCHAR2(155),
	sortkey NUMBER(13)
);

INSERT INTO eventtypes_temp SELECT query_value, sortkey FROM ingrid_chron_eventtypes;
UPDATE ingrid_chron_eventtypes SET sortkey = sortkey - 1 WHERE sortkey > (SELECT sortkey FROM eventtypes_temp WHERE eventtypes_temp.query_value='convention');
DELETE FROM ingrid_chron_eventtypes WHERE query_value='convention';

DELETE FROM eventtypes_temp;
INSERT INTO eventtypes_temp SELECT query_value, sortkey FROM ingrid_chron_eventtypes;
UPDATE ingrid_chron_eventtypes SET sortkey = sortkey - 1 WHERE sortkey > (SELECT sortkey FROM eventtypes_temp WHERE eventtypes_temp.query_value='guideline');
DELETE FROM ingrid_chron_eventtypes WHERE query_value='guideline';

DELETE FROM eventtypes_temp;
INSERT INTO eventtypes_temp SELECT query_value, sortkey FROM ingrid_chron_eventtypes;
UPDATE ingrid_chron_eventtypes SET sortkey = sortkey - 1 WHERE sortkey > (SELECT sortkey FROM eventtypes_temp WHERE eventtypes_temp.query_value='institution');
DELETE FROM ingrid_chron_eventtypes WHERE query_value='institution';

DELETE FROM eventtypes_temp;
INSERT INTO eventtypes_temp SELECT query_value, sortkey FROM ingrid_chron_eventtypes;
UPDATE ingrid_chron_eventtypes SET sortkey = sortkey - 1 WHERE sortkey > (SELECT sortkey FROM eventtypes_temp WHERE eventtypes_temp.query_value='marineAccident');
DELETE FROM ingrid_chron_eventtypes WHERE query_value='marineAccident';

DELETE FROM eventtypes_temp;
INSERT INTO eventtypes_temp SELECT query_value, sortkey FROM ingrid_chron_eventtypes;
UPDATE ingrid_chron_eventtypes SET sortkey = sortkey - 1 WHERE sortkey > (SELECT sortkey FROM eventtypes_temp WHERE eventtypes_temp.query_value='industrialAccident');
DELETE FROM ingrid_chron_eventtypes WHERE query_value='industrialAccident';

DROP TABLE eventtypes_temp PURGE; 



CREATE TABLE  ingrid_temp (
value NUMBER(10,0)
);

INSERT INTO ingrid_temp (VALUE) 
VALUES (
(SELECT parent_id FROM fragment WHERE name = 'ingrid-portal-apps::SearchCatalogThesaurus'));

INSERT INTO fragment (FRAGMENT_ID, PARENT_ID, PAGE_ID, NAME, TITLE, SHORT_TITLE, TYPE, SKIN, DECORATOR, STATE, PMODE, LAYOUT_ROW, LAYOUT_COLUMN, LAYOUT_SIZES, LAYOUT_X, LAYOUT_Y, LAYOUT_Z, LAYOUT_WIDTH, LAYOUT_HEIGHT, EXT_PROP_NAME_1, EXT_PROP_VALUE_1, EXT_PROP_NAME_2, EXT_PROP_VALUE_2, OWNER_PRINCIPAL) 
VALUES (
(SELECT max_key FROM ojb_hl_seq where tablename='SEQ_FRAGMENT'),
(SELECT value FROM ingrid_temp),
NULL, 'ingrid-portal-apps::InfoPortlet', NULL, NULL, 'portlet', NULL, 'ingrid-marginal-teaser', NULL, NULL, 1, 1, NULL, -1, -1, -1, -1, -1, NULL, NULL, NULL, NULL, NULL);

INSERT INTO fragment_pref (PREF_ID, FRAGMENT_ID, NAME, IS_READ_ONLY)
VALUES (
(SELECT max_key FROM ojb_hl_seq where tablename='SEQ_FRAGMENT_PREF'),
(SELECT max_key FROM ojb_hl_seq where tablename='SEQ_FRAGMENT'),
'infoTemplate', 0);

INSERT INTO fragment_pref_value (PREF_VALUE_ID, PREF_ID, VALUE_ORDER, VALUE)
VALUES (
(SELECT max_key FROM ojb_hl_seq where tablename='SEQ_FRAGMENT_PREF_VALUE'),
(SELECT max_key FROM ojb_hl_seq where tablename='SEQ_FRAGMENT_PREF'),
0, '/WEB-INF/templates/search_catalog/search_cat_thesaurus_info_sns.vm');

INSERT INTO fragment_pref (PREF_ID, FRAGMENT_ID, NAME, IS_READ_ONLY)
VALUES (
(SELECT max_key+1 FROM ojb_hl_seq where tablename='SEQ_FRAGMENT_PREF'),
(SELECT max_key FROM ojb_hl_seq where tablename='SEQ_FRAGMENT'),
'titleKey', 0);

INSERT INTO fragment_pref_value (PREF_VALUE_ID, PREF_ID, VALUE_ORDER, VALUE)
VALUES (
(SELECT max_key+1 FROM ojb_hl_seq where tablename='SEQ_FRAGMENT_PREF_VALUE'),
(SELECT max_key+1 FROM ojb_hl_seq where tablename='SEQ_FRAGMENT_PREF'),
0, 'searchCatThesaurus.info.title');

UPDATE ojb_hl_seq SET max_key=max_key+grab_size, version=version+1
WHERE tablename='SEQ_FRAGMENT';
UPDATE ojb_hl_seq SET max_key=max_key+grab_size, version=version+1
WHERE tablename='SEQ_FRAGMENT_PREF';
UPDATE ojb_hl_seq SET max_key=max_key+grab_size, version=version+1
WHERE tablename='SEQ_FRAGMENT_PREF_VALUE';

DROP TABLE ingrid_temp PURGE;
