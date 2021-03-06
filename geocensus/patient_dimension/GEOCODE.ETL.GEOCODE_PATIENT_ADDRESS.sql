UPDATE BERNOCCHI.PATIENT_DIMENSION A
SET    (GEO_BLOCK_GROUP,GEO_BLOCK_ID,GEO_X,GEO_Y) = 
(  
   SELECT BLOCK_GROUP,BLOCK_ID,NEW_X,NEW_Y
   FROM   GEOCENSUS.ADDRESS_TO_GEOCODE B
   WHERE  SUBSTR(TRIM(A.ZIP_CD), 1,5) = B.ZIP
   AND    ( 
            ( A.ADD_LINE_2 IS NULL AND UPPER(TRIM(A.ADD_LINE_1)) = B.ADDRESS )
          OR 
            ( A.ADD_LINE_2 IS NOT NULL AND UPPER(TRIM(A.ADD_LINE_1) || ' ' || TRIM(A.ADD_LINE_2)) = B.ADDRESS )
          )
   AND    UPPER(TRIM(A.CITY)) = B.CITY
   AND    B.LOC_NAME IN ('Address_Points')
)
;

UPDATE BERNOCCHI.PATIENT_DIMENSION A
SET    (GEO_BLOCK_GROUP,GEO_BLOCK_ID,GEO_X,GEO_Y) =  
(  
   SELECT BLOCK_GROUP,BLOCK_ID,NEW_X,NEW_Y
   FROM   GEOCENSUS.ADDRESS_TO_GEOCODE B
   WHERE  ( 
            ( A.ADD_LINE_2 IS NULL AND UPPER(TRIM(A.ADD_LINE_1)) = B.ADDRESS )
          OR 
            ( A.ADD_LINE_2 IS NOT NULL AND UPPER(TRIM(A.ADD_LINE_1) || ' ' || TRIM(A.ADD_LINE_2)) = B.ADDRESS )
          )
   AND    UPPER(TRIM(A.CITY)) = B.CITY
   AND    SUBSTR(TRIM(A.ZIP_CD), 1,5) = B.ZIP
   AND    B.LOC_NAME IN ('Street_Address')
)
WHERE GEO_BLOCK_ID IS NULL
;


UPDATE BERNOCCHI.PATIENT_DIMENSION A
SET    (GEO_BLOCK_GROUP,GEO_BLOCK_ID,GEO_X,GEO_Y) =
(
   SELECT BLOCK_GROUP,BLOCK_ID,NEW_X,NEW_Y
   FROM   GEOCENSUS.ADDRESS_TO_GEOCODE B
   WHERE  SUBSTR(TRIM(A.ZIP_CD), 1,5) = B.ZIP
   AND    B.ADDRESS IS NULL
   AND    B.LOC_NAME IN ('Zipcode')
)
WHERE GEO_BLOCK_ID IS NULL
;
