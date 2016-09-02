-- ***************************************************************************
-- Loading Data:
-- create external table mapping for events.csv and mortality_events.csv

-- IMPORTANT NOTES:
-- You need to put events.csv and mortality.csv under hdfs directory 
-- '/input/events/events.csv' and '/input/mortality/mortality.csv'
-- 
-- To do this, run the following commands for events.csv, 
-- 1. sudo su - hdfs
-- 2. hdfs dfs -mkdir -p /input/events
-- 3. hdfs dfs -chown -R vagrant /input
-- 4. exit 
-- 5. hdfs dfs -put /path/to/events.csv /input/events/
-- Follow the same steps 1 - 5 for mortality.csv, except that the path should be 
-- '/input/mortality'
-- ***************************************************************************
-- create events table 
DROP TABLE IF EXISTS events;
CREATE EXTERNAL TABLE events (
  patient_id STRING,
  event_id STRING,
  event_description STRING,
  time DATE,
  value DOUBLE)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/input/events';

-- create mortality events table 
DROP TABLE IF EXISTS mortality;
CREATE EXTERNAL TABLE mortality (
  patient_id STRING,
  time DATE,
  label INT)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/input/mortality';

SHOW TABLES;


-- ******************************************************
-- Task 1:
-- By manipulating the above two tables, 
-- generate two views for alive and dead patients' events
-- ******************************************************
-- find events for alive patients
DROP VIEW IF EXISTS alive_events;
CREATE VIEW alive_events 
AS
SELECT e.patient_id, e.event_id, e.time
FROM events e 
WHERE e.patient_id 
NOT IN
(SELECT patient_id FROM mortality);

-- ***** your code below *****








-- find events for dead patients
DROP VIEW IF EXISTS dead_events;
CREATE VIEW dead_events 
AS
SELECT e.patient_id, e.event_id, e.time
FROM events e JOIN mortality m
ON e.patient_id=m.patient_id;

-- ***** your code below *****







-- ************************************************
-- Task 2: Event count metrics
-- Compute average, min and max of event counts 
-- for alive and dead patients respectively  
-- ************************************************
-- alive patients

DROP VIEW IF EXISTS event_count_alive;
CREATE VIEW event_count_alive
AS
SELECT patient_id, count(event_id) as event_count
FROM alive_events
GROUP BY patient_id;

SELECT avg(event_count), min(event_count), max(event_count)
FROM event_count_alive;

-- ***** your code below *****





-- dead patients
DROP VIEW IF EXISTS event_count_dead;
CREATE VIEW event_count_dead
AS
SELECT patient_id, count(event_id) as event_count
FROM dead_events
GROUP BY patient_id;

SELECT avg(event_count), min(event_count), max(event_count)
FROM event_count_dead;


-- ***** your code below *****






-- ************************************************
-- Task 3: Encounter count metrics 
-- Compute average, min and max of encounter counts 
-- for alive and dead patients respectively
-- ************************************************
-- alive
-- SELECT avg(encounter_count), min(encounter_count), max(encounter_count)
-- ***** your code below *****

DROP VIEW IF EXISTS encounter_count;
CREATE VIEW encounter_count
AS
SELECT patient_id, count(DISTINCT time) as encounter_count
FROM alive_events
GROUP BY patient_id;

SELECT avg(encounter_count), min(encounter_count), max(encounter_count)
FROM encounter_count;


-- dead
-- SELECT avg(encounter_count), min(encounter_count), max(encounter_count)
-- ***** your code below *****

DROP VIEW IF EXISTS encounter_count;
CREATE VIEW encounter_count
AS
SELECT patient_id, count(DISTINCT time) as encounter_count
FROM dead_events
GROUP BY patient_id;

SELECT avg(encounter_count), min(encounter_count), max(encounter_count)
FROM encounter_count;






-- ************************************************
-- Task 4: Record length metrics
-- Compute average, min and max of record lengths
-- for alive and dead patients respectively
-- ************************************************
-- alive 
-- SELECT avg(record_length), min(record_length), max(record_length)
-- ***** your code below *****

DROP VIEW IF EXISTS alive_ordered;
CREATE VIEW alive_ordered
AS
SELECT patient_id, time 
FROM alive_events
ORDER BY time ASC;

DROP VIEW IF EXISTS record;
CREATE VIEW record
AS
SELECT patient_id, MIN(time) as first, MAX(time) as last
FROM alive_ordered
GROUP BY patient_id;

DROP VIEW IF EXISTS record_length;
CREATE VIEW record_length
AS 
SELECT patient_id, DATEDIFF(last, first) AS record_length
FROM record;

SELECT avg(record_length), min(record_length), max(record_length)
FROM record_length;







-- dead
-- SELECT avg(record_length), min(record_length), max(record_length)
-- ***** your code below *****

DROP VIEW IF EXISTS dead_ordered;
CREATE VIEW dead_ordered
AS
SELECT patient_id, time 
FROM dead_events
ORDER BY time ASC;

DROP VIEW IF EXISTS record;
CREATE VIEW record
AS
SELECT patient_id, MIN(time) as first, MAX(time) as last
FROM dead_ordered
GROUP BY patient_id;

DROP VIEW IF EXISTS record_length;
CREATE VIEW record_length
AS 
SELECT patient_id, DATEDIFF(last, first) AS record_length
FROM record;

SELECT avg(record_length), min(record_length), max(record_length)
FROM record_length;





-- ******************************************* 
-- Task 5: Common diag/lab/med
-- Compute the 5 most frequently occurring diag/lab/med
-- for alive and dead patients respectively
-- *******************************************
-- alive patients
---- diag

DROP VIEW IF EXISTS common_count;
CREATE VIEW common_count
AS
SELECT event_id,count(*) AS count
FROM alive_events
GROUP BY event_id
ORDER BY count DESC;


SELECT event_id, count AS diag_count
FROM common_count
WHERE event_id
LIKE 'DIAG%'
LIMIT 5;
-- ***** your code below *****


---- lab
SELECT event_id, count AS lab_count
FROM common_count
WHERE event_id
LIKE 'LAB%'
LIMIT 5;
-- ***** your code below *****


---- med
SELECT event_id, count AS med_count
FROM common_count
WHERE event_id
LIKE 'DRUG%'
LIMIT 5;
-- ***** your code below *****




-- dead patients
---- diag

DROP VIEW IF EXISTS common_count_dead;
CREATE VIEW common_count_dead
AS
SELECT event_id,count(*) AS count
FROM dead_events
GROUP BY event_id
ORDER BY count DESC;

SELECT event_id, count AS diag_count
FROM common_count_dead
WHERE event_id
LIKE 'DIAG%'
LIMIT 5;
-- ***** your code below *****


---- lab
SELECT event_id, count AS lab_count
FROM common_count_dead
WHERE event_id
LIKE 'LAB%'
LIMIT 5;
-- ***** your code below *****


---- med
SELECT event_id, count AS med_count
FROM common_count_dead
WHERE event_id
LIKE 'DRUG%'
LIMIT 5;
-- ***** your code below *****









