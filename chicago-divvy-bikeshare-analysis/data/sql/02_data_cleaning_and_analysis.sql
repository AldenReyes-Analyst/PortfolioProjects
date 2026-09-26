Select *
From combined_year_tripdata;


-- TOTAL TRIPS, AVG RIDE LENGTH AND MAX RIDE LENGTH FOR MEMBER AND CASUAL
WITH trip_durations AS (
    Select 
        member_casual,
        DATEDIFF_BIG(SECOND, started_at, ended_at) AS duration_seconds
    From combined_year_tripdata
)
Select 
    member_casual,
    Count(*) AS total_trips,
    
    -- AVERAGE RIDE LENGTH IN (hh:mm:ss) FORMAT
    RIGHT('0' + CAST(AVG(duration_seconds) / 3600 AS VARCHAR), 2) + ':' +
    RIGHT('0' + CAST((AVG(duration_seconds) % 3600) / 60 AS VARCHAR), 2) + ':' +
    RIGHT('0' + CAST(AVG(duration_seconds) % 60 AS VARCHAR), 2) AS avg_ride_length,
    
    -- MAXIMUM RIDE LENGTH IN (hh:mm:ss) FORMAT
    RIGHT('0' + CAST(MAX(duration_seconds) / 3600 AS VARCHAR), 2) + ':' +
    RIGHT('0' + CAST((MAX(duration_seconds) % 3600) / 60 AS VARCHAR), 2) + ':' +
    RIGHT('0' + CAST(MAX(duration_seconds) % 60 AS VARCHAR), 2) AS max_ride_length

From trip_durations
Group by member_casual;


-- MOST POPULAR DAY FOR THE WHOLE YEAR AND AVERAGE RIDE LENGTH
Select day_of_week, Count(day_of_week) AS total_count_popularity
From combined_year_tripdata
Group by day_of_week
Order By Count(day_of_week) DESC


-- AVERAGE RIDE LENGTH PER DAY OF WEEK
With daily_durations AS (
    Select 
        day_of_week,
        DATEDIFF_BIG(SECOND, started_at, ended_at) AS duration_seconds
    From combined_year_tripdata
    Where ended_at > started_at
)
Select 
    day_of_week,
    
    -- Average ride length formatted as (hh:mm:ss)
    -- Since ride_length is in nvarchar data type due to more than 24 hours ride_length
    RIGHT('0' + CAST(AVG(duration_seconds) / 3600 AS VARCHAR), 2) + ':' +
    RIGHT('0' + CAST((AVG(duration_seconds) % 3600) / 60 AS VARCHAR), 2) + ':' +
    RIGHT('0' + CAST(AVG(duration_seconds) % 60 AS VARCHAR), 2) AS avg_ride_length

From daily_durations
Group by day_of_week
Order by avg_ride_length DESC;


-- PEAK HOURS OF THE DAY FOR CASUAL AND MEMBER
Select 
    DATEPART(HOUR, started_at) AS hour_of_day,
    member_casual,
    COUNT(ride_id) AS total_trips
From combined_year_tripdata
Group by DATEPART(HOUR, started_at), member_casual
Order by hour_of_day, member_casual;


-- MONTHLY TRIPS AND AVERAGE RIDE LENGTH
With monthly_durations AS (
    Select 
        FORMAT(started_at, 'yyyy-MM') AS year_month,
        DATEDIFF_BIG(SECOND, started_at, ended_at) AS duration_seconds
    From combined_year_tripdata
    Where started_at >= '2025-09-01' 
      AND started_at < '2026-09-01'
      AND ended_at > started_at
)
Select 
    year_month,
    COUNT(*) AS total_trips,
    
    -- Average ride length formatted as hh:mm:ss
    RIGHT('0' + CAST(AVG(duration_seconds) / 3600 AS VARCHAR), 2) + ':' +
    RIGHT('0' + CAST((AVG(duration_seconds) % 3600) / 60 AS VARCHAR), 2) + ':' +
    RIGHT('0' + CAST(AVG(duration_seconds) % 60 AS VARCHAR), 2) AS avg_ride_length

From monthly_durations
Group by year_month
Order by year_month;


----------------------------------------------------
-- BIKE TYPE PREFERENCE FOR CASUAL AND MEMBER
Select 
    rideable_type,
    member_casual,
    COUNT(ride_id) AS total_trips,
    ROUND(COUNT(ride_id) * 100.0 / SUM(COUNT(ride_id)) OVER(PARTITION BY member_casual), 2) AS percentage_share
From combined_year_tripdata
Where ended_at > started_at
Group by rideable_type, member_casual
Order by member_casual, total_trips DESC;


-- 10 MOST POPULAR START STATION
Select Top 10
    start_station_name,
    COUNT(ride_id) AS casual_trips
From combined_year_tripdata
Where member_casual = 'casual' 
  AND start_station_name IS NOT NULL 
  AND start_station_name <> ''
  AND ended_at > started_at
Group by start_station_name
Order by casual_trips DESC;
