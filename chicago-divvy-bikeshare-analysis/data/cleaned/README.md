# 🧹 Cleaned & Processed Data

## 📌 Data Transformation & Overview
This directory details the final cleaned dataset used for analyzing rider trends, usage patterns, and annual vs. casual member behavior.

### Key Cleaning & Transformation Steps:
1. **File Naming & SQL Compatibility:**
   * Renamed raw monthly files (e.g., from `202509-divvy-tripdata` to `G2025-09-divvy-trip-data`).
   * *Rationale:* SQL databases generally recommend starting table and object names with alphabetical letters rather than numbers to prevent syntax and import errors.
2. **Feature Engineering:**
   * **`ride_length`**: Computed exact trip duration (`ended_at - started_at`).
   * **`day_of_week`**: Extracted starting day names and numeric representations (e.g., 1 = Sunday) for weekly trend modeling.
3. **Data Anomaly Removal:**
   * Filtered out invalid records with negative trip durations (`ended_at < started_at`).

---

## 🔗 Full 12-Month Cleaned Dataset Access
Due to GitHub's file size limits (>100 MB), the primary ~3 GB aggregated cleaned dataset (`G2025-09-divvy-trip-data` through `G2026-08-divvy-trip-data`) is hosted on Google Drive:

👉 **[Download Full 12-Month Cleaned CSV Dataset](https://drive.google.com/file/d/1WNDjK0EPkNPqlGmA_KvBzk_a5dDAVpmu/view?usp=sharing)**

*(Note: A sample single-month cleaned file is included directly in this repository directory for quick schema inspection.)*
