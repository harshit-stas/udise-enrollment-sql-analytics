-- Business question: Rank districts within their state by total enrollment
-- for the most recent year. Uses RANK() window function.
WITH latest_year_totals AS (
    SELECT district_cd, SUM(student_count) AS total_enrolled
    FROM enrolment_fact
    WHERE ac_year = '2019-20'
    GROUP BY district_cd
)
SELECT
    s.state_name,
    d.district_name,
    t.total_enrolled,
    RANK() OVER (PARTITION BY s.state_name ORDER BY t.total_enrolled DESC) AS rank_within_state
FROM latest_year_totals t
JOIN districts d ON d.district_cd = t.district_cd
JOIN states s ON s.state_cd = d.state_cd
ORDER BY s.state_name, rank_within_state;
