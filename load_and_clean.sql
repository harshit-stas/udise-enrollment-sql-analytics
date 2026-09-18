-- 1. Load raw CSV into staging (run this line separately via \copy in psql,
--    since \copy is a psql meta-command and can't run inside a plain .sql file
--    executed with a driver that doesn't support it):
-- \copy staging_enrolment FROM 'path/to/udise_enrolment.csv' WITH (FORMAT csv, HEADER true);

-- 2. Data cleaning: fix known state name inconsistencies
--    (Orissa -> Odisha: official 2011 rename; Kerla -> Kerala: data entry typo)
UPDATE staging_enrolment SET state_name = 'Odisha' WHERE state_name = 'Orissa';
UPDATE staging_enrolment SET state_name = 'Kerala' WHERE state_name = 'Kerla';

-- 3. Trim whitespace from district names (fixes e.g. "CHANDIGARH " vs "CHANDIGARH")
UPDATE staging_enrolment SET district_name = TRIM(district_name);

-- 4. Populate states
INSERT INTO states
SELECT DISTINCT state_cd, state_name FROM staging_enrolment;

-- 5. Populate districts, picking each code's most recent year's spelling as canonical
--    (resolves remaining spelling drift, e.g. GURGAON -> GURUGRAM rename)
--    KNOWN LIMITATION: Telangana district codes 3602-3610, 3621, 3622 were
--    reassigned to different real districts during the 2016 reorganization
--    (10 districts -> 33). This "latest year wins" rule does not fix that --
--    those codes reference genuinely different districts across years, and
--    district-level trend analysis for Telangana should be treated with
--    caution prior to 2016.
WITH ranked_names AS (
    SELECT
        district_cd,
        district_name,
        state_cd,
        ROW_NUMBER() OVER (
            PARTITION BY district_cd
            ORDER BY ac_year DESC
        ) AS rn
    FROM staging_enrolment
    WHERE district_cd IS NOT NULL
)
INSERT INTO districts (district_cd, district_name, state_cd)
SELECT district_cd, district_name, state_cd
FROM ranked_names
WHERE rn = 1;
