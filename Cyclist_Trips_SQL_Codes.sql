# Creating table 
CREATE TABLE cyclist_trips (
    trip_id           BIGINT,
    start_time_raw     VARCHAR(20),
    end_time_raw       VARCHAR(20),
    bikeid             INT,
    tripduration_raw   VARCHAR(20),
    from_station_id    INT,
    from_station_name  VARCHAR(255),
    to_station_id      INT,
    to_station_name    VARCHAR(255),
    usertype           VARCHAR(50),
    gender             VARCHAR(10),
    birthyear          INT,
    ride_length        VARCHAR(20),
    day_of_week        INT,
    source_quarter     VARCHAR(2)
);

# Loading data into the table (Q1)
LOAD DATA LOCAL INFILE 'C:/Users/USER/OneDrive/Desktop/My_Docs/Google_Data_Analytics (Coursera)/Excel and Word Files/Capstone_Project_Q1.csv'
INTO TABLE cyclist_trips
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(trip_id, start_time_raw, end_time_raw, bikeid, tripduration_raw, from_station_id,
 from_station_name, to_station_id, to_station_name, usertype, gender, birthyear,
 ride_length, day_of_week, @dummy1, @dummy2, @dummy3)
SET source_quarter = 'Q1';

# Q2
LOAD DATA LOCAL INFILE 'C:/Users/USER/OneDrive/Desktop/My_Docs/Google_Data_Analytics (Coursera)/Excel and Word Files/Capstone_Project_Q2.csv' INTO TABLE cyclist_trips FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 ROWS (trip_id, start_time_raw, end_time_raw, bikeid, tripduration_raw, from_station_id, from_station_name, to_station_id, to_station_name, usertype, gender, birthyear, ride_length, day_of_week) SET source_quarter = 'Q2';

# Q3
LOAD DATA LOCAL INFILE 'C:/Users/USER/OneDrive/Desktop/My_Docs/Google_Data_Analytics (Coursera)/Excel and Word Files/Capstone_Project_Q3.csv' INTO TABLE cyclist_trips FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 ROWS (trip_id, start_time_raw, end_time_raw, bikeid, tripduration_raw, from_station_id, from_station_name, to_station_id, to_station_name, usertype, gender, birthyear, ride_length, day_of_week) SET source_quarter = 'Q3';

# Q4
LOAD DATA LOCAL INFILE 'C:/Users/USER/OneDrive/Desktop/My_Docs/Google_Data_Analytics (Coursera)/Excel and Word Files/Capstone_Project_Q4.csv' INTO TABLE cyclist_trips FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 ROWS (trip_id, start_time_raw, end_time_raw, bikeid, tripduration_raw, from_station_id, from_station_name, to_station_id, to_station_name, usertype, gender, birthyear, ride_length, day_of_week) SET source_quarter = 'Q4';

# Checking records (rides) from each quarter
SELECT source_quarter, COUNT(*) FROM cyclist_trips GROUP BY source_quarter;

# Number of rides
SELECT COUNT(*) AS total_rides FROM cyclist_trips;

# Checking the columns and sample records
DESCRIBE cyclist_trips;
SELECT * FROM cyclist_trips LIMIT 10;

# Checking customer types and missing values
SELECT usertype, COUNT(*) AS ride_count FROM cyclist_trips GROUP BY usertype;
SELECT COUNT(*) AS missing_usertype FROM cyclist_trips WHERE usertype IS NULL OR TRIM(usertype) = '';
SELECT COUNT(*) AS total_rides, SUM(usertype IS NULL OR TRIM(usertype) = '') AS missing_usertype,
 ROUND(100.0 * SUM(usertype IS NULL OR TRIM(usertype) = '') / COUNT(*), 4) AS missing_percentage
FROM cyclist_trips;

# Checking ride duration
SELECT COUNT(*) AS total_rows, MIN(ride_length) AS shortest_ride, MAX(ride_length) AS longest_ride, AVG(ride_length) AS average_ride FROM cyclist_trips;

# Number of rides by customer type
SELECT usertype, COUNT(*) AS total_rides FROM cyclist_trips GROUP BY usertype ORDER BY total_rides DESC;

# Average ride length by customer type
SELECT usertype, AVG(ride_length) AS avg_ride_length FROM cyclist_trips GROUP BY usertype;

# Max and min ride length by customer type
SELECT usertype, MIN(ride_length) AS shortest_ride, MAX(ride_length) AS longest_ride, AVG(ride_length) AS average_ride FROM cyclist_trips GROUP BY usertype;

# Number of rides by day
SELECT day_of_week, COUNT(*) AS ride_count FROM cyclist_trips GROUP BY day_of_week ORDER BY ride_count DESC;

# Member vs casual by day
SELECT usertype, day_of_week, COUNT(*) AS ride_count FROM cyclist_trips GROUP BY usertype, day_of_week ORDER BY usertype, ride_count DESC;

# Average ride duration by day and customer type
SELECT usertype, day_of_week, SEC_TO_TIME(AVG(TIME_TO_SEC(ride_length))) AS avg_ride_length FROM cyclist_trips GROUP BY usertype, day_of_week ORDER BY usertype, day_of_week;

# Number of rides by quarter
SELECT source_quarter, COUNT(*) AS ride_count FROM cyclist_trips GROUP BY source_quarter ORDER BY source_quarter;

# Members vs casual by quarter
SELECT source_quarter, usertype, COUNT(*) AS ride_count FROM cyclist_trips GROUP BY source_quarter, usertype ORDER BY ride_count DESC;

# Average ride length by quarter
SELECT source_quarter, usertype, AVG(ride_length) AS avg_ride_length FROM cyclist_trips GROUP BY source_quarter, usertype ORDER BY source_quarter, usertype;

# Which customer type has longer rides?
SELECT usertype, SEC_TO_TIME(ROUND(AVG(TIME_TO_SEC(ride_length)), 2)) AS avg_ride_length
FROM cyclist_trips WHERE ride_length IS NOT NULL AND usertype IS NOT NULL
GROUP BY usertype ORDER BY AVG(TIME_TO_SEC(ride_length)) DESC;

# Which customer type rides more frequently?
SELECT usertype, COUNT(*) AS total_rides FROM cyclist_trips GROUP BY usertype ORDER BY total_rides DESC;

# Most popular starting stations
SELECT from_station_name, COUNT(*) AS ride_count FROM cyclist_trips GROUP BY from_station_name ORDER BY ride_count DESC LIMIT 10;

# Popular stations by customer type
SELECT usertype, from_station_name, COUNT(*) AS ride_count FROM cyclist_trips GROUP BY usertype, from_station_name ORDER BY usertype, ride_count DESC;

# Exporting data
SELECT * FROM cyclist_trips INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/cyclist_trips_full.csv'
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n';
