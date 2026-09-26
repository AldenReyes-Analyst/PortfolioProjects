# 🗄️ SQL Scripts & Data Pipeline

## 📌 Database Environment
* **RDBMS:** Microsoft SQL Server (SSMS)
* **Dataset Scope:** 12 consecutive months (`G2025_09_divvy_tripdata` through `G2026_08_divvy_tripdata`)
* **Combined Table:** `combined_year_tripdata`

---

## 📜 Script Breakdown

1. **`01_data_import_and_union.sql`**
   * Combines all 12 monthly tables into a single master table (`combined_year_tripdata`) using `UNION ALL`.

2. **`02_data_cleaning_and_analysis.sql`**
   * **Data Validation:** Excludes invalid trip records (`ended_at > started_at`) during aggregation queries.
   * **Trip Duration & Aggregation:** Uses `DATEDIFF_BIG` to calculate trip durations in seconds and formats results into `hh:mm:ss` string representations.
   * **Exploratory Analytics:**
     * Summary statistics (total, average, and max ride lengths for members vs. casual riders).
     * Usage volume and average ride duration by day of the week and month (`yyyy-MM`).
     * Hourly peak usage trends segmented by membership type.
     * Bike type preference (`rideable_type`) percentage share per rider group.
     * Top 10 start stations for casual riders (filtering out `NULL` and blank station names to highlight true station names).
