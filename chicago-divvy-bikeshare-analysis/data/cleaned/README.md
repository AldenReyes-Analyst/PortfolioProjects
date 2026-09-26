# 🧹 Cleaned & Processed Data

## 📌 Data Transformation & Overview
This directory details the final cleaned dataset used for analyzing rider trends, usage patterns, and annual vs. casual member behavior.

### Key Cleaning & Transformation Steps:
1. **Feature Engineering:**
   * **`ride_length`**: Computed exact trip duration (`ended_at - started_at`).
   * **`day_of_week`**: Extracted starting day names and numeric representations for weekly trend modeling.
2. **Data Anomaly Removal:**
   * Excluded trips with negative durations.

---

## 🔗 Full 12-Month Cleaned Dataset Access
Due to GitHub's file size limits (>100 MB), the primary 3 GB aggregated cleaned dataset (`202509-divvy-tripdata` through `202608-divvy-tripdata`) is hosted on Google Drive:

👉 **[Download Full 12-Month Cleaned CSV Dataset] (https://drive.google.com/file/d/1WNDjK0EPkNPqlGmA_KvBzk_a5dDAVpmu/view?usp=sharing)**

*(Note: A sample single-month cleaned file is included directly in this repository directory for quick schema inspection.)*
