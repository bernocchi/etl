--DROP TABLE ADDRESS_TO_GEOCODE


CREATE TABLE GEOCENSUS.ADDRESS_TO_GEOCODE
(
        ADDRESS VARCHAR2(100),
        CITY VARCHAR2(100),
        ZIP VARCHAR2(5) NOT NULL,
        LOC_NAME VARCHAR2(20) NOT NULL,
        BLOCK_GROUP INTEGER NOT NULL,
        BLOCK_ID INTEGER NOT NULL,
        NEW_X NUMBER NOT NULL,
        NEW_Y NUMBER NOT NULL
);

CREATE INDEX
    GEOCENSUS.ZIP_ADDRESS_IDX
ON
    GEOCENSUS.ADDRESS_TO_GEOCODE
    (
       ZIP, ADDRESS
    );



INSERT INTO GEOCENSUS.ADDRESS_TO_GEOCODE
SELECT  DISTINCT
        UPPER(TRIM(ADDRESS)),
        UPPER(TRIM(CITY)),
        TO_CHAR(ZIP),
        LOC_NAME,
        TO_NUMBER(SUBSTR(TO_CHAR(ID),1,12)) AS BLOCK_GROUP,
        BLOCK_ID,
        NEW_X,
        NEW_Y
FROM    GEOCENSUS.GEOCODE_UTHSCSA_UNIQUE
WHERE   LOC_NAME = 'Address_Points'
AND     ID IS NOT NULL;
;

INSERT INTO GEOCENSUS.ADDRESS_TO_GEOCODE
SELECT  DISTINCT
        UPPER(TRIM(A.ADDRESS)),
        UPPER(TRIM(A.CITY)),
        TO_CHAR(A.ZIP),
        A.LOC_NAME,
        TO_NUMBER(SUBSTR(TO_CHAR(ID),1,12)) AS BLOCK_GROUP,
        A.BLOCK_ID,
        A.NEW_X,
        A.NEW_Y
FROM    GEOCENSUS.GEOCODE_UTHSCSA_UNIQUE A
INNER JOIN
(
        SELECT  ADDRESS,
                CITY,
                TO_CHAR(ZIP) AS ZIP
        FROM    GEOCENSUS.GEOCODE_UTHSCSA_UNIQUE
        WHERE   LOC_NAME = 'Street_Address'
        AND     ID IS NOT NULL
        MINUS
        SELECT  ADDRESS,
                CITY,
                ZIP
        FROM    GEOCENSUS.ADDRESS_TO_GEOCODE
) B
ON      A.ADDRESS = B.ADDRESS
AND     A.CITY    = B.CITY
AND     A.ZIP     = B.ZIP
WHERE   A.LOC_NAME = 'Street_Address'
AND     A.ID IS NOT NULL;

INSERT INTO GEOCENSUS.ADDRESS_TO_GEOCODE
SELECT  DISTINCT
        NULL,
        NULL,
        TO_CHAR(A.ZIP) AS ZIP,
        A.LOC_NAME,
        TO_NUMBER(SUBSTR(TO_CHAR(ID),1,12)) AS BLOCK_GROUP,
        -1 AS BLOCK_ID,
        A.NEW_X,
        A.NEW_Y
FROM    GEOCENSUS.GEOCODE_UTHSCSA_UNIQUE A
INNER JOIN
(
        SELECT  DISTINCT
                TO_CHAR(ZIP) AS ZIP
        FROM    GEOCENSUS.GEOCODE_UTHSCSA_UNIQUE
        WHERE   LOC_NAME = 'Zipcode'
        AND     ID IS NOT NULL
) B
ON      A.ZIP = B.ZIP
WHERE   LOC_NAME = 'Zipcode'
AND     ID IS NOT NULL;
;