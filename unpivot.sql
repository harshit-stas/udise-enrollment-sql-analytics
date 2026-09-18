-- Converts wide format (24 class/gender columns) into a normalized
-- long-format fact table using UNION ALL
INSERT INTO enrolment_fact (district_cd, ac_year, age, class, gender, student_count)
SELECT district_cd, ac_year, age, 1, 'boys', class_1_boys FROM staging_enrolment WHERE district_cd IS NOT NULL AND class_1_boys IS NOT NULL
UNION ALL
SELECT district_cd, ac_year, age, 2, 'boys', class_2_boys FROM staging_enrolment WHERE district_cd IS NOT NULL AND class_2_boys IS NOT NULL
UNION ALL
SELECT district_cd, ac_year, age, 3, 'boys', class_3_boys FROM staging_enrolment WHERE district_cd IS NOT NULL AND class_3_boys IS NOT NULL
UNION ALL
SELECT district_cd, ac_year, age, 4, 'boys', class_4_boys FROM staging_enrolment WHERE district_cd IS NOT NULL AND class_4_boys IS NOT NULL
UNION ALL
SELECT district_cd, ac_year, age, 5, 'boys', class_5_boys FROM staging_enrolment WHERE district_cd IS NOT NULL AND class_5_boys IS NOT NULL
UNION ALL
SELECT district_cd, ac_year, age, 6, 'boys', class_6_boys FROM staging_enrolment WHERE district_cd IS NOT NULL AND class_6_boys IS NOT NULL
UNION ALL
SELECT district_cd, ac_year, age, 7, 'boys', class_7_boys FROM staging_enrolment WHERE district_cd IS NOT NULL AND class_7_boys IS NOT NULL
UNION ALL
SELECT district_cd, ac_year, age, 8, 'boys', class_8_boys FROM staging_enrolment WHERE district_cd IS NOT NULL AND class_8_boys IS NOT NULL
UNION ALL
SELECT district_cd, ac_year, age, 9, 'boys', class_9_boys FROM staging_enrolment WHERE district_cd IS NOT NULL AND class_9_boys IS NOT NULL
UNION ALL
SELECT district_cd, ac_year, age, 10, 'boys', class_10_boys FROM staging_enrolment WHERE district_cd IS NOT NULL AND class_10_boys IS NOT NULL
UNION ALL
SELECT district_cd, ac_year, age, 11, 'boys', class_11_boys FROM staging_enrolment WHERE district_cd IS NOT NULL AND class_11_boys IS NOT NULL
UNION ALL
SELECT district_cd, ac_year, age, 12, 'boys', class_12_boys FROM staging_enrolment WHERE district_cd IS NOT NULL AND class_12_boys IS NOT NULL
UNION ALL
SELECT district_cd, ac_year, age, 1, 'girls', class_1_girls FROM staging_enrolment WHERE district_cd IS NOT NULL AND class_1_girls IS NOT NULL
UNION ALL
SELECT district_cd, ac_year, age, 2, 'girls', class_2_girls FROM staging_enrolment WHERE district_cd IS NOT NULL AND class_2_girls IS NOT NULL
UNION ALL
SELECT district_cd, ac_year, age, 3, 'girls', class_3_girls FROM staging_enrolment WHERE district_cd IS NOT NULL AND class_3_girls IS NOT NULL
UNION ALL
SELECT district_cd, ac_year, age, 4, 'girls', class_4_girls FROM staging_enrolment WHERE district_cd IS NOT NULL AND class_4_girls IS NOT NULL
UNION ALL
SELECT district_cd, ac_year, age, 5, 'girls', class_5_girls FROM staging_enrolment WHERE district_cd IS NOT NULL AND class_5_girls IS NOT NULL
UNION ALL
SELECT district_cd, ac_year, age, 6, 'girls', class_6_girls FROM staging_enrolment WHERE district_cd IS NOT NULL AND class_6_girls IS NOT NULL
UNION ALL
SELECT district_cd, ac_year, age, 7, 'girls', class_7_girls FROM staging_enrolment WHERE district_cd IS NOT NULL AND class_7_girls IS NOT NULL
UNION ALL
SELECT district_cd, ac_year, age, 8, 'girls', class_8_girls FROM staging_enrolment WHERE district_cd IS NOT NULL AND class_8_girls IS NOT NULL
UNION ALL
SELECT district_cd, ac_year, age, 9, 'girls', class_9_girls FROM staging_enrolment WHERE district_cd IS NOT NULL AND class_9_girls IS NOT NULL
UNION ALL
SELECT district_cd, ac_year, age, 10, 'girls', class_10_girls FROM staging_enrolment WHERE district_cd IS NOT NULL AND class_10_girls IS NOT NULL
UNION ALL
SELECT district_cd, ac_year, age, 11, 'girls', class_11_girls FROM staging_enrolment WHERE district_cd IS NOT NULL AND class_11_girls IS NOT NULL
UNION ALL
SELECT district_cd, ac_year, age, 12, 'girls', class_12_girls FROM staging_enrolment WHERE district_cd IS NOT NULL AND class_12_girls IS NOT NULL;
