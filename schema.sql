-- Staging table: mirrors the raw UDISE+ CSV structure exactly
CREATE TABLE staging_enrolment (
    ac_year TEXT,
    age INTEGER,
    state_cd TEXT,
    state_name TEXT,
    district_cd TEXT,
    district_name TEXT,
    class_1_boys INTEGER, class_2_boys INTEGER, class_3_boys INTEGER, class_4_boys INTEGER,
    class_5_boys INTEGER, class_6_boys INTEGER, class_7_boys INTEGER, class_8_boys INTEGER,
    class_9_boys INTEGER, class_10_boys INTEGER, class_11_boys INTEGER, class_12_boys INTEGER,
    class_1_girls INTEGER, class_2_girls INTEGER, class_3_girls INTEGER, class_4_girls INTEGER,
    class_5_girls INTEGER, class_6_girls INTEGER, class_7_girls INTEGER, class_8_girls INTEGER,
    class_9_girls INTEGER, class_10_girls INTEGER, class_11_girls INTEGER, class_12_girls INTEGER
);

-- Dimension: states
CREATE TABLE states (
    state_cd TEXT PRIMARY KEY,
    state_name TEXT
);

-- Dimension: districts
CREATE TABLE districts (
    district_cd TEXT PRIMARY KEY,
    district_name TEXT,
    state_cd TEXT REFERENCES states(state_cd)
);

-- Fact table: one row per district, year, age, class, gender
CREATE TABLE enrolment_fact (
    district_cd TEXT REFERENCES districts(district_cd),
    ac_year TEXT,
    age INTEGER,
    class INTEGER,
    gender TEXT,
    student_count INTEGER
);
