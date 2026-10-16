SELECT COUNT(*) AS total_rows
FROM ev_vehicle_registrations;

SELECT State
FROM ev_vehicle_registrations
ORDER BY State
LIMIT 5;

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT State) AS unique_states,
    SUM(`Electric (EV)`) AS total_ev
FROM ev_vehicle_registrations;

SHOW TABLE STATUS
WHERE Name = 'ev_vehicle_registrations';

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT State) AS unique_states,
    SUM(`Electric (EV)`) AS total_ev
FROM power_automate_course.ev_vehicle_registrations_test;

SELECT COUNT(*) AS total_rows
FROM power_automate_course.ev_vehicle_registrations_test;

SELECT COUNT(*) AS total_rows
FROM power_automate_course.ev_vehicle_registrations_test;

CREATE TABLE IF NOT EXISTS power_automate_course.ev_vehicle_registrations_staging
LIKE power_automate_course.ev_vehicle_registrations;