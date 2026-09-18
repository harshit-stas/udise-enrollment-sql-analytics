# UDISE+ School Enrollment Analytics

SQL analytics project on India's official school enrollment data (UDISE+),
answering real district-level business questions using CTEs and window
functions — CTEs, `LAG()`, and `RANK()` — the exact SQL patterns used for
monthly college-funnel reporting at Bihar SBTE and TNSDC.

**Dataset:** Age-and-class-wise student enrollment, 2012-13 to 2019-20,
covering 37 states/UTs and 755 districts (5.3M+ rows after transformation).
Source: [UDISE+ open government data](https://dashboard.udiseplus.gov.in/).

## Why this project

Most of my real analytical work (Bihar SBTE, TNSDC) uses confidential
partner-college data that can't be shared publicly. This project applies
the same skills — schema design, data cleaning, and CTE/window-function
analysis — to a public dataset shaped like that real work, so the code and
findings can be shown openly.

## Schema

Four tables: a `staging_enrolment` table that mirrors the raw CSV exactly,
two dimension tables (`states`, `districts`), and one long-format fact
table (`enrolment_fact`) built by unpivoting 24 wide class/gender columns
into rows.

states ──┐
├──> districts ──> enrolment_fact
(37 rows) (755 rows) (5,334,864 rows)


See `schema.sql` for full DDL.

## Data cleaning

Real government data, real messiness:

- **State name inconsistencies**: `Orissa`/`Odisha` (the state's actual
  2011 rename) and `Kerla`/`Kerala` (a data-entry typo) both mapped to the
  same state code — resolved by standardizing to one name per code.
- **District name drift**: 48 district codes had inconsistent spellings
  across different years' files (whitespace, transliteration differences
  like `HOOGHLY`/`HUGLI`, and genuine renames like `GURGAON`→`GURUGRAM`).
  Resolved with a `ROW_NUMBER()` window function that picks each code's
  most recent year's spelling as canonical.
- **Known limitation — Telangana**: district codes 3602–3610, 3621, and
  3622 were reassigned to entirely different real districts during
  Telangana's 2016 reorganization (10 districts → 33). These are not
  spelling variants — the same code refers to different real places
  across years — so district-level trend analysis for Telangana should
  be treated with caution for years before 2016. This is why Telangana
  is excluded from the decline analysis in Q1.
- **102 rows (0.05% of the data)** had no district code at all (likely
  state-level aggregate rows) and were excluded from all analysis.

See `load_and_clean.sql` for the full cleaning script.

## Business questions and findings

### Q1 — Which districts show 3+ consecutive years of enrollment decline?

Using a CTE plus `LAG()` to compare each district-year against the prior
two years.

**Finding:** 1,599 district-year instances across 547 of 755 districts
(72%) show a 3-year consecutive decline, spanning nearly every state in
the dataset. This is a genuinely nationwide pattern, not isolated
outliers — likely reflecting falling birth rates reducing India's
school-age population over 2012–2020, rather than a data quality issue.

See `q1_decline_streaks.sql`.

### Q2 — Rank districts within their state by enrollment

Using `RANK() OVER (PARTITION BY state ...)` for the most recent year
(2019-20).

**Finding:** Straightforward within-state comparison — e.g., East
Godavari leads Andhra Pradesh at ~1.67M enrolled, more than double the
smallest district in the state.

See `q2_district_rankings.sql`.

### Q3 — How has the girls' enrollment share moved over time? (Bihar)

Using a CTE to compute the girls' percentage of enrollment per
district-year, then `LAG()` to track year-over-year change.

**Finding:** Enrollment in Bihar is close to gender parity in most
districts (48–52% girls) across all 8 years. A few districts consistently
sit below parity — **Saharsa** (46–47% throughout), plus **Jamui**,
**Lakhisarai**, and **Nalanda** (consistently under 49%) — while
**Kishanganj**, **Gopalganj**, and **Siwan** run consistently above 51%.

See `q3_gender_ratio_trend.sql`.

## Repo structure

schema.sql — table definitions
load_and_clean.sql — data cleaning (state/district name fixes)
unpivot.sql — wide-to-long transformation into enrolment_fact
q1_decline_streaks.sql — 3-year decline analysis
q2_district_rankings.sql — within-state enrollment ranking
q3_gender_ratio_trend.sql — gender ratio trend analysis


## Running this yourself

1. Create a PostgreSQL database and run `schema.sql`.
2. Download the UDISE+ enrollment CSV and load it into `staging_enrolment`
   using `\copy` in `psql`.
3. Run `load_and_clean.sql`, then `unpivot.sql`.
4. Run any of the three business-question files.
EOF

Then commit and push it:

bash
git add README.md
git commit -m "Add README with findings, schema overview, and data cleaning notes"
git push
