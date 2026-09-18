-- Business question: How has the girls' share of enrollment moved over
-- time in each district? Uses CTE + LAG() window function.
-- Finding (Bihar): enrollment is close to gender parity in most districts
-- (48-52% girls), with Saharsa, Jamui, Lakhisarai and Nalanda consistently
-- a few points below 50%, and Kishanganj, Gopalganj and Siwan consistently above.
WITH district_year_gender AS (
    SELECT
        district_cd,
        ac_year,
        SUM(CASE WHEN gender = 'girls' THEN student_count ELSE 0 END) AS girls_total,
        SUM(student_count) AS total_enrolled
    FROM enrolment_fact
    GROUP BY district_cd, ac_year
),
with_ratio AS (
    SELECT
        district_cd,
        ac_year,
        ROUND(100.0 * girls_total / NULLIF(total_enrolled, 0), 2) AS girls_pct
    FROM district_year_gender
)
SELECT
    s.state_name,
    d.district_name,
    r.ac_year,
    r.girls_pct,
    r.girls_pct - LAG(r.girls_pct) OVER (
        PARTITION BY r.district_cd ORDER BY r.ac_year
    ) AS change_from_prev_year
FROM with_ratio r
JOIN districts d ON d.district_cd = r.district_cd
JOIN states s ON s.state_cd = d.state_cd
WHERE s.state_name = 'Bihar'
ORDER BY d.district_name, r.ac_year;
