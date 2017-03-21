INSERT INTO BERNOCCHI.OBSERVATION_FACT
SELECT  D.ENCOUNTER_NUM,
        B.PATIENT_NUM,
        CASE 
           WHEN B.RACE_CD = 'black'        THEN A.BLACK_CD
           WHEN B.RACE_CD = 'am indian'    THEN A.AMER_IND_ALASKA_NATIVE_CD
           WHEN B.RACE_CD = 'asian'        THEN A.ASIANS_CD
           WHEN B.RACE_CD = 'pac islander' THEN A.NATIVE_HI_PAC_ISLANDER_CD
           WHEN B.RACE_CD = 'other'        THEN A.OTHER_CD
           WHEN B.RACE_CD = 'i choose not' THEN A.OTHER_CD
           WHEN B.RACE_CD = 'unknown/othe' THEN A.OTHER_CD
           WHEN B.RACE_CD = '@'            THEN A.OTHER_CD
           WHEN B.RACE_CD = 'more than on' THEN A.TWO_OR_MORE_RACES_CD
           WHEN B.RACE_CD = 'white'        AND C.HISPANIC != 'Y'  THEN WHITE_NON_HISPANIC_CD
           WHEN C.HISPANIC ='Y'            THEN HISPANIC_CD
           ELSE MEDIAN_BLOCK_INCOME_CD
        END CONCEPT_CD,
        '@' AS PROVIDER_ID,
        E.START_DATE,
        '@' AS MODIFIER_CD,
        --NIGHTHERONDATA.OBS_FACT_INSTANCE_NUM.NEXTVAL AS INSTANCE_NUM,
        1 AS INSTANCE_NUM,
        '@'                AS VALTYPE_CD,
        '@'                AS TVAL_CHAR,
        NULL               AS NVAL_NUM,
        NULL               AS VALUEFLAG_CD,
        NULL               AS QUANITY_NUM,
        NULL               AS UNITS_CD,
        E.END_DATE         AS END_DATE,
        NULL               AS LOCATION_CD,
        NULL               AS OBSERVATION_BLOB,
        NULL               AS CONFIDENCE_NUM,
        SYSTIMESTAMP       AS UPDATE_DATE,
        SYSTIMESTAMP       AS DOWNLOAD_DATE,
        SYSTIMESTAMP       AS IMPORT_DATE,
        'GEOCENSUS@GEOCENSUS.com'  AS SOURCESYSTEM_CD,
        NULL               AS UPLOAD_ID,
        NULL               AS SUB_ENCOUNTER
FROM    GEOCENSUS.BLOCK_GROUP_TO_INCOME_CD A
INNER JOIN
        BERNOCCHI.PATIENT_DIMENSION B
ON      A.BLOCK_GROUP = B.GEO_BLOCK_GROUP
INNER JOIN
        PCORI_CDM.DEMOGRAPHIC C
ON      B.PATIENT_NUM = C.PATID
INNER JOIN
        (
           SELECT PATIENT_NUM, 
                  MAX(ENCOUNTER_NUM) AS ENCOUNTER_NUM 
           FROM    NIGHTHERONDATA.VISIT_DIMENSION 
           GROUP BY PATIENT_NUM
        ) D
ON      B.PATIENT_NUM = D.PATIENT_NUM
INNER JOIN
        NIGHTHERONDATA.VISIT_DIMENSION E
ON      D.ENCOUNTER_NUM = E.ENCOUNTER_NUM;
