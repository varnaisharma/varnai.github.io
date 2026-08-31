# Dataset Overview
SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT Id) AS unique_users,
    MIN(ActivityDate) AS first_date,
    MAX(ActivityDate) AS last_date
FROM daily_activity;

# Checking how many days each user has
SELECT
    Id,
    COUNT(DISTINCT ActivityDate) AS recorded_days
FROM daily_activity
GROUP BY Id
ORDER BY recorded_days DESC;

# Descriptive Analysis
SELECT
    ROUND(AVG(TotalSteps), 2) AS avg_steps,
    ROUND(AVG(TotalDistance), 2) AS avg_distance,
    ROUND(AVG(Calories), 2) AS avg_calories,
    ROUND(AVG(VeryActiveMinutes), 2) AS avg_very_active_minutes,
    ROUND(AVG(FairlyActiveMinutes), 2) AS avg_fairly_active_minutes,
    ROUND(AVG(LightlyActiveMinutes), 2) AS avg_lightly_active_minutes,
    ROUND(AVG(SedentaryMinutes), 2) AS avg_sedentary_minutes
FROM daily_activity;

# User-level averages
SELECT
    Id,
    COUNT(DISTINCT ActivityDate) AS recorded_days,
    ROUND(AVG(TotalSteps), 2) AS avg_steps,
    ROUND(AVG(Calories), 2) AS avg_calories,
    ROUND(AVG(VeryActiveMinutes), 2) AS avg_very_active,
    ROUND(AVG(FairlyActiveMinutes), 2) AS avg_fairly_active,
    ROUND(AVG(LightlyActiveMinutes), 2) AS avg_lightly_active,
    ROUND(AVG(SedentaryMinutes), 2) AS avg_sedentary
FROM daily_activity
GROUP BY Id
ORDER BY avg_steps DESC;

# Activity segments
SELECT
    Id,
    ROUND(AVG(TotalSteps), 0) AS avg_steps,

    CASE
        WHEN AVG(TotalSteps) < 5000 THEN 'Low Activity'
        WHEN AVG(TotalSteps) < 10000 THEN 'Moderate Activity'
        ELSE 'High Activity'
    END AS activity_segment

FROM daily_activity
GROUP BY Id
ORDER BY avg_steps DESC;

SELECT
    activity_segment,
    COUNT(*) AS users
FROM (
    SELECT
        Id,
        CASE
            WHEN AVG(TotalSteps) < 5000 THEN 'Low Activity'
            WHEN AVG(TotalSteps) < 10000 THEN 'Moderate Activity'
            ELSE 'High Activity'
        END AS activity_segment
    FROM daily_activity
    GROUP BY Id
) AS user_segments
GROUP BY activity_segment
ORDER BY users DESC;

# Day-of-week analysis
SELECT
    DAYNAME(STR_TO_DATE(ActivityDate, '%m/%d/%Y')) AS day_of_week,
    ROUND(AVG(TotalSteps), 0) AS avg_steps,
    ROUND(AVG(Calories), 0) AS avg_calories,
    ROUND(AVG(VeryActiveMinutes), 1) AS avg_very_active,
    ROUND(AVG(LightlyActiveMinutes), 1) AS avg_lightly_active,
    ROUND(AVG(SedentaryMinutes), 1) AS avg_sedentary
FROM daily_activity
GROUP BY DAYNAME(STR_TO_DATE(ActivityDate, '%m/%d/%Y'))
ORDER BY MIN(DAYOFWEEK(STR_TO_DATE(ActivityDate, '%m/%d/%Y')));

# Zero-step days
SELECT
    COUNT(*) AS zero_step_days,
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM daily_activity),
        2
    ) AS percentage_of_records
FROM daily_activity
WHERE TotalSteps = 0;

SELECT
    Id,
    COUNT(*) AS zero_step_days
FROM daily_activity
WHERE TotalSteps = 0
GROUP BY Id
ORDER BY zero_step_days DESC;

# Sedentary behavior
SELECT
    Id,
    ROUND(AVG(SedentaryMinutes), 0) AS avg_sedentary_minutes,
    ROUND(AVG(TotalSteps), 0) AS avg_steps
FROM daily_activity
GROUP BY Id
ORDER BY avg_sedentary_minutes DESC;

# Investigating whether sedentary time and steps move in opposite directions
SELECT
    ROUND(
        (
            COUNT(*) * SUM(TotalSteps * SedentaryMinutes)
            - SUM(TotalSteps) * SUM(SedentaryMinutes)
        )
        /
        SQRT(
            (
                COUNT(*) * SUM(TotalSteps * TotalSteps)
                - POWER(SUM(TotalSteps), 2)
            )
            *
            (
                COUNT(*) * SUM(SedentaryMinutes * SedentaryMinutes)
                - POWER(SUM(SedentaryMinutes), 2)
            )
        ),
        3
    ) AS steps_sedentary_correlation
FROM daily_activity;

# Activity composition
SELECT
    ROUND(AVG(VeryActiveMinutes), 1) AS very_active,
    ROUND(AVG(FairlyActiveMinutes), 1) AS fairly_active,
    ROUND(AVG(LightlyActiveMinutes), 1) AS lightly_active,
    ROUND(AVG(SedentaryMinutes), 1) AS sedentary
FROM daily_activity;

# Sleep data
SELECT 
    COUNT(*) AS total_records,
    COUNT(DISTINCT Id) AS unique_users,
    MIN(SleepDay) AS first_record,
    MAX(SleepDay) AS last_record
FROM sleep_day;

SELECT *
FROM sleep_day
LIMIT 10;

# Checking for missing values
SELECT
    SUM(Id IS NULL) AS missing_id,
    SUM(SleepDay IS NULL) AS missing_sleepday,
    SUM(TotalSleepRecords IS NULL) AS missing_sleep_records,
    SUM(TotalMinutesAsleep IS NULL) AS missing_minutes_asleep,
    SUM(TotalTimeInBed IS NULL) AS missing_time_in_bed
FROM sleep_day;

# Checking for duplicate values
SELECT
    Id,
    SleepDay,
    COUNT(*) AS duplicate_count
FROM sleep_day
GROUP BY Id, SleepDay
HAVING COUNT(*) > 1;

# Descriptive statistics
SELECT
    ROUND(AVG(TotalMinutesAsleep), 2) AS avg_minutes_asleep,
    ROUND(AVG(TotalTimeInBed), 2) AS avg_minutes_in_bed,
    ROUND(MIN(TotalMinutesAsleep), 2) AS min_minutes_asleep,
    ROUND(MAX(TotalMinutesAsleep), 2) AS max_minutes_asleep,
    ROUND(MIN(TotalTimeInBed), 2) AS min_minutes_in_bed,
    ROUND(MAX(TotalTimeInBed), 2) AS max_minutes_in_bed
FROM sleep_day;

# Converting sleep into hours
SELECT
    ROUND(AVG(TotalMinutesAsleep) / 60, 2) AS avg_sleep_hours,
    ROUND(AVG(TotalTimeInBed) / 60, 2) AS avg_time_in_bed_hours
FROM sleep_day;

# Calculate sleep efficiency
SELECT
    ROUND(
        AVG(
            (TotalMinutesAsleep / TotalTimeInBed) * 100
        ),
        2
    ) AS avg_sleep_efficiency
FROM sleep_day
WHERE TotalTimeInBed > 0;