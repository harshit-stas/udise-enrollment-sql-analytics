-- Business question: Which districts show 3 consecutive years of declining
-- total enrollment? Uses CTEs + LAG() window function.
-- Finding: 1,599 district-year instances across 547 of 755 districts (72%)
-- show a 3-year decline streak, nationwide -- likely reflecting falling
-- birth rates reducing India's school-age population over 2012-2020.
-- Telangana excluded: 2016 district reorganization creates artificial
-- "declines" when old codes split into new ones.
WITH district_year_totals AS (
    SELECT district_cd, ac_year, SUM(student_count) AS total_enrolled
    FROM enrolment_fact
    GROUP BY district_cd, ac_year
),
with_lag AS (
    SELECT
        district_cd,
        ac_year,
        total_enrolled,
        LAG(total_enrolled, 1) OVER (PARTITION BY district_cd ORDER BY ac_year) AS prev_year_1,
        LAG(total_enrolled, 2) OVER (PARTITION BY district_cd ORDER BY ac_year) AS prev_year_2
    FROM district_year_totals
)
SELECT
    d.district_name,
    s.state_name,
    w.ac_year AS latest_year_of_decline,
    w.prev_year_2 AS enrolled_2_years_ago,
    w.prev_year_1 AS enrolled_1_year_ago,
    w.total_enrolled AS enrolled_this_year
FROM with_lag w
JOIN districts d ON d.district_cd = w.district_cd
JOIN states s ON s.state_cd = d.state_cd
WHERE w.total_enrolled < w.prev_year_1
  AND w.prev_year_1 < w.prev_year_2
  AND s.state_name != 'Telangana'
ORDER BY s.state_name, d.district_name, w.ac_year;
