/* copy all the csv files to the data base */
Create table daily_activity(
ID varchar(100),
AcitivityDate date,
TotalSteps int,
TotalDistance decimal,
TrackerDistance decimal,
LoggedActivityDistance decimal,
VeryActiveDistance decimal,
ModeratelyActiveDistance decimal,
LightActiveDistance decimal,
SedentaryActiveDistance decimal,
VeryActiveMinutes int,
FairlyActiveMinutes int,
LightlyActiveMinutes int,
SedentaryMinutes int,
calories int
)

copy daily_activity
FROM 'C:\Program Files\PostgreSQL\Fitabase Data 3.12.16-4.11.16\dailyActivity_merged.csv'
DELIMITER ','
CSV HEADER;

drop table daily_activity;

create table heart_rate_seconds(
Id varchar(100),
Time time,
Value int
)
copy heart_rate_seconds
FROM 'C:\Program Files\PostgreSQL\Fitabase Data 3.12.16-4.11.16\heartrate_seconds_merged.csv'
DELIMITER ','
CSV HEADER;


create table hourly_cal(
Id varchar(100),
Date_time timestamp,
Calories int
)
copy hourly_cal
FROM 'C:\Program Files\PostgreSQL\Fitabase Data 3.12.16-4.11.16\hourlyCalories_merged.csv'
DELIMITER ','
CSV HEADER;




create table hourly_intensities(
Id varchar(100),
Activity_hour timestamp,
Total_intensity decimal,
Average_intensity decimal
)
copy hourly_intensities
FROM 'C:\Program Files\PostgreSQL\Fitabase Data 3.12.16-4.11.16\hourlyIntensities_merged.csv'
DELIMITER ','
CSV HEADER;


create table hourlySteps_merged(
Id varchar(100),
Activity_hour timestamp,
Total_steps varchar(50)
)
copy hourlySteps_merged
FROM 'C:\Program Files\PostgreSQL\Fitabase Data 3.12.16-4.11.16\hourlySteps_merged.csv'
DELIMITER ','
CSV HEADER;

drop table minute_cal;
create table minute_cal(
Id varchar(100),
Activity_min timestamp,
calories decimal
)
copy minute_cal
FROM 'C:\Program Files\PostgreSQL\Fitabase Data 3.12.16-4.11.16\minuteCaloriesNarrow_merged.csv'
DELIMITER ','
CSV HEADER;

create table minute_intensity(
Id varchar(100),
Activity_min timestamp,
intesity decimal
)
copy minute_intensity
FROM 'C:\Program Files\PostgreSQL\Fitabase Data 3.12.16-4.11.16\minuteIntensitiesNarrow_merged.csv'
DELIMITER ','
CSV HEADER;

create table minute_steps(
Id varchar(100),
Activity_min timestamp,
steps int
)
copy minute_steps
FROM 'C:\Program Files\PostgreSQL\Fitabase Data 3.12.16-4.11.16\minuteStepsNarrow_merged.csv'
DELIMITER ','
CSV HEADER;

create table minute_sleep(
Id varchar(100),
Activity_min timestamp,
Value decimal,
logID varchar(100)
)
copy minute_sleep
FROM 'C:\Program Files\PostgreSQL\Fitabase Data 3.12.16-4.11.16\minuteSleep_merged.csv'
DELIMITER ','
CSV HEADER;

create table weight_info(
Id varchar(100),
Activity_min timestamp,
weight_Kg decimal,
weight_Pounds decimal,
Fat decimal,
BMI decimal,
IsMannualReport varchar(100),
logID Varchar(100)
)
copy weight_info
FROM 'C:\Program Files\PostgreSQL\Fitabase Data 3.12.16-4.11.16\weightLogInfo_merged.csv'
DELIMITER ','
CSV HEADER;
/* view the data*/
select * from daily_activity;
select * from heart_rate_seconds;
select * from hourly_cal;
select * from hourly_intensities;
select * from hourlySteps_merged;
select * from minute_cal;
select * from minute_intensity;
select * from minute_steps;
select * from minute_sleep;
select * from weight_info;

Select ID, avg(value) as average_heart_rate from heart_rate_seconds group by ID;
---------------------------------------------------------------------
/* create average readings table to find average data fro the long wide data
     -Grouping it by id's
*/
Create table Average_readings as 
Select id, 
cast(avg(totalsteps) as int) as average_steps, 
cast(avg(totaldistance) as int) as average_distance, 
cast(avg(veryactivedistance)as int) as avrg_active_distance,
cast(avg(moderatelyactivedistance) as int) as avrg_mod_distance,
cast(avg(lightactivedistance) as int) as avrg_lightly_distance,
cast(avg(veryactiveminutes) as int) as avrg_very_active_min,
cast(avg(fairlyactiveminutes)as int) as avrg_fair_active_min,
cast(avg(sedentaryminutes) as int) as avrg_sedentary_min,
cast(avg(calories) as int) as avg_cal_burned

from daily_activity group by ID;
drop table Average_readings;
------------------------------------------------------------------------
Select
cast(avg(totalsteps) as int) as average_steps, 
cast(avg(totaldistance) as int) as average_distance, 
cast(avg(veryactivedistance)as int) as avrg_active_distance,
cast(avg(moderatelyactivedistance) as int) as avrg_mod_distance,
cast(avg(lightactivedistance) as int) as avrg_lightly_distance,
cast(avg(veryactiveminutes) as int) as avrg_very_active_min,
cast(avg(fairlyactiveminutes)as int) as avrg_fair_active_min,
cast(avg(sedentaryminutes) as int) as avrg_sedentary_min,
cast(avg(calories) as int) as avg_cal_burned

from daily_activity;
------------------------------------------------------------------------------
select * from Average_readings;
--------------------------------------------------------------------------
Create table Avg_hrt_scds as
Select ID, avg(value) as average_heart_rate from heart_rate_seconds group by ID;
Create table Avg_cal_rate as
Select ID, avg(calories)as average_cal_hourly from hourly_cal group by ID;
Create table Avg_int_rate as
Select ID, avg(total_intensity) as avg_intensity from hourly_intensities group by ID;
Create table Avg_steps as
Select ID, avg(steps) as avg_steps_per_min from minute_steps group by ID;
select * from Avg_hrt_scds;
select * from Avg_cal_rate;
select * from Avg_int_rate;
select * from Avg_steps;

create table Overall_average as
select r.id, cast(r.average_steps as int), cast(r.average_distance as int), 
cast(r.avrg_very_active_min as int), cast(r.avrg_sedentary_min as int), 
cast(r. avg_cal_burned as int),cast(c.average_cal_hourly as int), cast(i.avg_intensity as int), 
cast(s.avg_steps_per_min as int)
from Average_readings r
left join Avg_cal_rate c on r.id=c.id
left join Avg_int_rate i on c.id=i.id
left join Avg_steps s on i.id=s.id;

select * from Overall_average order by id;
select * from weight_info;
Select ID, avg(value) as average_heart_rate from heart_rate_seconds group by ID;


select o.average_steps, o.avrg_very_active_min,o.avg_cal_burned, o.avg_steps_per_min, w.activity_min, w.weight_kg, w.bmi 
from Overall_average o
join weight_info w on o.id=w.id;

select * from minute_sleep;
select * from daily_activity;
select * from Overall_average order by average_steps;
---------------------------------------------------------

select * from daily_activity;
select * from heart_rate_seconds;
select * from hourly_cal;
select * from hourly_intensities;
select * from hourlySteps_merged;
select * from minute_cal;
select * from minute_intensity;
select * from minute_steps;
select * from minute_sleep;
select * from weight_info;

SELECT id,total_steps,
    activity_hour::date AS date_only,
    activity_hour::time AS time_only
FROM hourlySteps_merged;
--------------------------------------------------------
create table example(
brand varchar(50),
model varchar(50),
age int,
price decimal
)
/*Imported 2 conclusion tables by using sql shell commands*/