-- PATIENT DATA: CLEANING + FEATURE ENGINEERING (WITH CTEs)
-- Table: PATIENTS
-- CI7524 Big Data & Data Mining - Anthony L. Anumel

-- 1. Add derived columns (safe / idempotent)
-- 2. Populate cleaned + feature columns
-- 3. Create a CTE-based modelling view

-- (OPTIONAL) BACKUP ORIGINAL TABLE
-- CREATE TABLE patients_raw AS SELECT * FROM patients;

------------------------------------------------------------
-- 1. ADD DERIVED COLUMNS (SAFE / IDEMPOTENT)
------------------------------------------------------------
DECLARE
   col_count INTEGER;

   PROCEDURE add_column(colname IN VARCHAR2, datatype IN VARCHAR2) IS
   BEGIN
       SELECT COUNT(*) INTO col_count
       FROM user_tab_columns
       WHERE table_name = 'PATIENTS' AND column_name = UPPER(colname);
       
       IF col_count = 0 THEN
           EXECUTE IMMEDIATE 'ALTER TABLE patients ADD ' || colname || ' ' || datatype;
       END IF;
   END;
BEGIN
   add_column('C_GENDER',          'VARCHAR2(1)');
   add_column('C_AGE',             'NUMBER');
   add_column('C_SYS_OUTLIER',     'NUMBER(1)');
   add_column('C_DIAS_OUTLIER',    'NUMBER(1)');
   add_column('C_BP_PAIR_INVALID', 'NUMBER(1)');
   add_column('C_PP',              'NUMBER');
   add_column('C_CHOL_OUTLIER',    'NUMBER(1)');
   add_column('C_DIABETES',        'NUMBER(1)');
   add_column('C_CVDRX',           'NUMBER(1)');
   add_column('C_HTN',             'NUMBER(1)');
   add_column('C_FH_ASTHMA',       'NUMBER(1)');
   add_column('C_MWAY_EXPOSURE',   'NUMBER');
   add_column('C_SMOKER',          'NUMBER(1)');
   add_column('C_MWAY_HIGH_EXPOS', 'NUMBER(1)');
   add_column('C_ASTHMA_WORSENED', 'NUMBER(1)');
   add_column('C_BAD_YOB',         'NUMBER(1)');
   add_column('C_BAD_BP_DATE1',    'NUMBER(1)');
   add_column('C_BAD_CHOL_DATE1',  'NUMBER(1)');
END;
/

------------------------------------------------------------
-- 2. POPULATE CLEANING + FEATURE COLUMNS
------------------------------------------------------------
UPDATE patients
SET
   c_gender = CASE 
                 WHEN Gender = '446141000124107' THEN 'M'
                 WHEN Gender = '446151000124109' THEN 'F'
                 ELSE 'U' 
              END,
   
   c_fh_asthma = CASE 
                    WHEN fh_asthma_code1 = '160377001' THEN 1 
                    ELSE 0 
                 END,
   
   c_mway_exposure = CASE 
                        WHEN mwaydist_km1 IS NULL OR mwaydist_km1 < 0 THEN NULL 
                        ELSE mwaydist_km1 
                     END,
   
   c_age = CASE 
              WHEN Year_of_Birth IS NULL 
                   OR Year_of_Birth < 1900 
                   OR Year_of_Birth > EXTRACT(YEAR FROM SYSDATE) 
              THEN NULL 
              ELSE EXTRACT(YEAR FROM SYSDATE) - Year_of_Birth 
           END,
   
   c_bad_yob = CASE 
                  WHEN Year_of_Birth < 1900 
                       OR Year_of_Birth > EXTRACT(YEAR FROM SYSDATE) 
                  THEN 1 
                  ELSE 0 
               END,
   
   c_sys_outlier = CASE 
                      WHEN sys_val1 < 60 OR sys_val1 > 260 THEN 1 
                      ELSE 0 
                   END,
   
   c_dias_outlier = CASE 
                       WHEN dias_val1 < 30 OR dias_val1 > 160 THEN 1 
                       ELSE 0 
                    END,
   
   c_bp_pair_invalid = CASE 
                          WHEN sys_val1 < dias_val1 THEN 1 
                          ELSE 0 
                       END,
   
   c_pp = CASE 
             WHEN sys_val1 IS NOT NULL AND dias_val1 IS NOT NULL 
             THEN sys_val1 - dias_val1 
             ELSE NULL 
          END,
   
   c_mway_high_expos = CASE 
                          WHEN mwaydist_km1 <= 0.5 THEN 1 
                          ELSE 0 
                       END,
   
   c_asthma_worsened = CASE 
                          WHEN asthma_worsened = 1 THEN 1 
                          ELSE 0 
                       END,
   
   c_diabetes = CASE 
                   WHEN diab_code1 IN ('44054006','111552007','237599002','73211009') 
                   THEN 1 
                   ELSE 0 
                END,
   
   c_smoker = CASE 
                 WHEN smok_code1 IN ('230056004','230057008','230058003','266920004') THEN 1
                 WHEN smok_code1 IN ('8392000','266919005') THEN NULL
                 ELSE 0 
              END,
   
   c_cvdrx = CASE 
                WHEN cvdrx_code1 IN ('6131004','372727001','11000132102','11000129103',
                                     '1040010010001002','111708003','372729009',
                                     '324121000000109','11560009') 
                THEN 1 
                ELSE 0 
             END,
   
   c_htn = CASE 
              WHEN sys_val1 >= 140 OR dias_val1 >= 90 THEN 1 
              ELSE 0 
           END,
   
   c_bad_bp_date1 = CASE 
                       WHEN bp_date1 < DATE '1900-01-01' OR bp_date1 > SYSDATE THEN 1 
                       ELSE 0 
                    END,
   
   c_bad_chol_date1 = CASE 
                         WHEN chlhdl_date1 < DATE '1900-01-01' OR chlhdl_date1 > SYSDATE THEN 1 
                         ELSE 0 
                      END;

COMMIT;

------------------------------------------------------------
-- 3. FEATURE VIEW FOR MODELLING (CTE PIPELINE)
------------------------------------------------------------
CREATE OR REPLACE VIEW asthma_model_features AS
WITH base_raw AS (
   SELECT 
       Patient_ID,
       c_gender,
       c_age,
       c_smoker,
       c_fh_asthma,
       c_bad_yob,
       c_mway_exposure,
       c_mway_high_expos,
       c_asthma_worsened
   FROM patients
),
filtered AS (
   SELECT * FROM base_raw
   WHERE c_bad_yob = 0 
     AND c_age IS NOT NULL 
     AND c_asthma_worsened IS NOT NULL
),
final_features AS (
   SELECT 
       Patient_ID,
       c_gender              AS gender,
       c_age                 AS age,
       c_smoker              AS smoker,
       c_fh_asthma           AS family_history_asthma,
       c_mway_exposure       AS motorway_distance_km,
       c_mway_high_expos     AS high_pollution_exposure,
       c_asthma_worsened     AS asthma_worsened
   FROM filtered
)
SELECT * FROM final_features;

-- QUICK CHECK
SELECT * FROM asthma_model_features FETCH FIRST 20 ROWS ONLY;

-- END OF SCRIPT
