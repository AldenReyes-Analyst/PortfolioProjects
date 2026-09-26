SELECT * INTO combined_year_tripdata
FROM (
    SELECT * FROM G2025_09_divvy_tripdata
    UNION ALL
    SELECT * FROM G2025_10_divvy_tripdata
    UNION ALL
    SELECT * FROM G2025_11_divvy_tripdata
    UNION ALL
    SELECT * FROM G2025_12_divvy_tripdata
    UNION ALL
    SELECT * FROM G2026_01_divvy_tripdata
    UNION ALL
    SELECT * FROM G2026_02_divvy_tripdata
    UNION ALL
    SELECT * FROM G2026_03_divvy_tripdata
    UNION ALL
    SELECT * FROM G2026_04_divvy_tripdata
    UNION ALL
    SELECT * FROM G2026_05_divvy_tripdata
    UNION ALL
    SELECT * FROM G2026_06_divvy_tripdata
    UNION ALL
    SELECT * FROM G2026_07_divvy_tripdata
    UNION ALL
    SELECT * FROM G2026_08_divvy_tripdata
) AS annual_data;
