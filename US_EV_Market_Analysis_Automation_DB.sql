-- =====================================================
-- U.S. Electric Vehicle Market Analysis
-- SQL Analysis
-- =====================================================

-- =====================================================
-- 1. DATABASE AND TABLE SETUP
-- =====================================================

-- Use the dedicated database populated by the Power Automate workflow.
-- This script does not create, delete, or modify any database or table.
USE power_automate_course;

-- Display the tables available in the selected database.
SHOW TABLES;

-- Check the number of records currently in the vehicle
-- registration table.
SELECT COUNT(*)
FROM power_automate_course.ev_vehicle_registrations;

-- Inspect the table structure, including column names
-- and data types.
DESCRIBE power_automate_course.ev_vehicle_registrations;

-- Preview all records in the table.
SELECT * FROM power_automate_course.ev_vehicle_registrations;


-- =====================================================
-- 2. DATA VALIDATION
-- =====================================================

-- Confirm the total number of records in the dataset.
-- Expected result: 51 (50 states + District of Columbia).
SELECT COUNT(*) AS total_rows
FROM power_automate_course.ev_vehicle_registrations;

-- Review all state names to check that the state field
-- is populated and consistently represented.
SELECT State
FROM power_automate_course.ev_vehicle_registrations
ORDER BY State;

-- Check for duplicate state records.
-- Each state/location should appear only once.
SELECT 
    State,
    COUNT(*) AS occurrence_count
FROM power_automate_course.ev_vehicle_registrations
GROUP BY State
HAVING COUNT(*) > 1;

-- Check for NULL values in the EV column.
-- A result of 0 means there are no missing EV values.
SELECT COUNT(*) AS null_ev_values
FROM power_automate_course.ev_vehicle_registrations
WHERE `Electric (EV)` IS NULL;

-- Check that PHEV values are populated.
SELECT COUNT(`Plug-In Hybrid Electric (PHEV)`) AS phev_values
FROM power_automate_course.ev_vehicle_registrations;

-- Check that HEV, Biodiesel, and Ethanol/Flex values
-- are populated.
SELECT
    COUNT(`Hybrid Electric (HEV)`) AS hev_values,
    COUNT(Biodiesel) AS biodiesel_values,
    COUNT(`Ethanol/Flex (E85)`) AS ethanol_values
FROM power_automate_course.ev_vehicle_registrations;

-- Check that CNG, Propane, Hydrogen, and Methanol values
-- are populated.
SELECT
    COUNT(`Compressed Natural Gas (CNG)`) AS cng_values,
    COUNT(Propane) AS propane_values,
    COUNT(Hydrogen) AS hydrogen_values,
    COUNT(Methanol) AS methanol_values
FROM power_automate_course.ev_vehicle_registrations;

-- Check that Gasoline, Diesel, and Unknown Fuel values
-- are populated.
SELECT
    COUNT(Gasoline) AS gasoline_values,
    COUNT(Diesel) AS diesel_values,
    COUNT(`Unknown Fuel`) AS unknown_fuel_values
FROM power_automate_course.ev_vehicle_registrations;


-- =====================================================
-- 3. NATIONAL VEHICLE TOTALS BY FUEL TYPE
-- =====================================================

-- Calculate the total number of vehicles for each fuel
-- category across all states and the District of Columbia.
SELECT SUM(`Electric (EV)`) AS total_ev,
       SUM(`Plug-In Hybrid Electric (PHEV)`) AS total_phev,
       SUM(`Hybrid Electric (HEV)`) AS total_hev,
       SUM(`Biodiesel`) AS total_biodiesel,
       SUM(`Ethanol/Flex (E85)`) AS total_ethanol,
       SUM(`Compressed Natural Gas (CNG)`) AS total_cng,
       SUM(Propane) AS total_propane,
       SUM(Hydrogen) AS total_hydrogen,
       SUM(Methanol) AS total_methanol,
       SUM(Gasoline) AS total_gasoline,
       SUM(Diesel) AS total_diesel,
       SUM(`Unknown Fuel`) AS total_unknown_fuel
FROM power_automate_course.ev_vehicle_registrations;


-- =====================================================
-- 4. TOTAL VEHICLES BY STATE
-- =====================================================

-- Calculate the total vehicle population for each state
-- by summing all 12 fuel categories.
-- The results are sorted from the largest vehicle market
-- to the smallest.
SELECT
    State,
    `Electric (EV)` 
    + `Plug-In Hybrid Electric (PHEV)` 
    + `Hybrid Electric (HEV)` 
    + `Biodiesel` 
    + `Ethanol/Flex (E85)`
    + `Compressed Natural Gas (CNG)`
    + Propane 
    + Hydrogen 
    + Methanol
    + Gasoline 
    + Diesel 
    + `Unknown Fuel` AS total_vehicles
FROM power_automate_course.ev_vehicle_registrations
ORDER BY total_vehicles DESC;


-- =====================================================
-- 5. EV ADOPTION RATE
-- =====================================================

-- Calculate EV adoption rate for each state:
-- EV vehicles / total vehicles * 100.
-- The top 10 states/locations are returned based on
-- the highest adoption rate.
SELECT
    State,
    `Electric (EV)` 
    + `Plug-In Hybrid Electric (PHEV)` 
    + `Hybrid Electric (HEV)` 
    + `Biodiesel` 
    + `Ethanol/Flex (E85)`
    + `Compressed Natural Gas (CNG)`
    + Propane 
    + Hydrogen 
    + Methanol
    + Gasoline 
    + Diesel 
    + `Unknown Fuel` AS total_vehicles,

    (`Electric (EV)` / 
    (`Electric (EV)`
     + `Plug-In Hybrid Electric (PHEV)` 
     + `Hybrid Electric (HEV)` 
     + `Biodiesel` 
     + `Ethanol/Flex (E85)`
     + `Compressed Natural Gas (CNG)`
     + Propane 
     + Hydrogen 
     + Methanol
     + Gasoline 
     + Diesel 
     + `Unknown Fuel`)) * 100 AS ev_adoption_rate

FROM power_automate_course.ev_vehicle_registrations
ORDER BY ev_adoption_rate DESC
LIMIT 10;


-- =====================================================
-- 6. LOWEST EV ADOPTION RATES
-- =====================================================

-- Identify the 10 states/locations with the lowest
-- EV adoption rates.
SELECT
    State,
    `Electric (EV)` 
    + `Plug-In Hybrid Electric (PHEV)` 
    + `Hybrid Electric (HEV)` 
    + `Biodiesel` 
    + `Ethanol/Flex (E85)`
    + `Compressed Natural Gas (CNG)`
    + Propane 
    + Hydrogen 
    + Methanol
    + Gasoline 
    + Diesel 
    + `Unknown Fuel` AS total_vehicles,

    (`Electric (EV)` / 
    (`Electric (EV)`
     + `Plug-In Hybrid Electric (PHEV)` 
     + `Hybrid Electric (HEV)` 
     + `Biodiesel` 
     + `Ethanol/Flex (E85)`
     + `Compressed Natural Gas (CNG)`
     + Propane 
     + Hydrogen 
     + Methanol
     + Gasoline 
     + Diesel 
     + `Unknown Fuel`)) * 100 AS ev_adoption_rate

FROM power_automate_course.ev_vehicle_registrations
ORDER BY ev_adoption_rate ASC
LIMIT 10;


-- =====================================================
-- 7. PHEV MARKET SHARE
-- =====================================================

-- Calculate the PHEV market share for each state:
-- PHEVs / total vehicles * 100.
-- Results are ranked from highest to lowest.
SELECT
    State,
    `Electric (EV)` 
    + `Plug-In Hybrid Electric (PHEV)` 
    + `Hybrid Electric (HEV)` 
    + `Biodiesel` 
    + `Ethanol/Flex (E85)`
    + `Compressed Natural Gas (CNG)`
    + Propane 
    + Hydrogen 
    + Methanol
    + Gasoline 
    + Diesel 
    + `Unknown Fuel` AS total_vehicles,

    (`Plug-In Hybrid Electric (PHEV)` / 
    (`Electric (EV)`
     + `Plug-In Hybrid Electric (PHEV)` 
     + `Hybrid Electric (HEV)` 
     + `Biodiesel` 
     + `Ethanol/Flex (E85)`
     + `Compressed Natural Gas (CNG)`
     + Propane 
     + Hydrogen 
     + Methanol
     + Gasoline 
     + Diesel 
     + `Unknown Fuel`)) * 100 AS phev_market_share

FROM power_automate_course.ev_vehicle_registrations
ORDER BY phev_market_share DESC;


-- =====================================================
-- 8. HEV MARKET SHARE
-- =====================================================

-- Calculate the HEV market share for each state:
-- HEVs / total vehicles * 100.
-- Results are ranked from highest to lowest.
SELECT
    State,
    `Electric (EV)` 
    + `Plug-In Hybrid Electric (PHEV)` 
    + `Hybrid Electric (HEV)` 
    + `Biodiesel` 
    + `Ethanol/Flex (E85)`
    + `Compressed Natural Gas (CNG)`
    + Propane 
    + Hydrogen 
    + Methanol
    + Gasoline 
    + Diesel 
    + `Unknown Fuel` AS total_vehicles,

    (`Hybrid Electric (HEV)` / 
    (`Electric (EV)`
     + `Plug-In Hybrid Electric (PHEV)` 
     + `Hybrid Electric (HEV)` 
     + `Biodiesel` 
     + `Ethanol/Flex (E85)`
     + `Compressed Natural Gas (CNG)`
     + Propane 
     + Hydrogen 
     + Methanol
     + Gasoline 
     + Diesel 
     + `Unknown Fuel`)) * 100 AS hev_market_share

FROM power_automate_course.ev_vehicle_registrations
ORDER BY hev_market_share DESC;


-- =====================================================
-- 9. GASOLINE MARKET SHARE
-- =====================================================

-- Calculate the gasoline market share for each state:
-- Gasoline vehicles / total vehicles * 100.
-- Results are ranked from highest to lowest.
SELECT
    State,
    `Electric (EV)` 
    + `Plug-In Hybrid Electric (PHEV)` 
    + `Hybrid Electric (HEV)` 
    + `Biodiesel` 
    + `Ethanol/Flex (E85)`
    + `Compressed Natural Gas (CNG)`
    + Propane 
    + Hydrogen 
    + Methanol
    + Gasoline 
    + Diesel 
    + `Unknown Fuel` AS total_vehicles,

    (Gasoline / 
    (`Electric (EV)`
     + `Plug-In Hybrid Electric (PHEV)` 
     + `Hybrid Electric (HEV)` 
     + `Biodiesel` 
     + `Ethanol/Flex (E85)`
     + `Compressed Natural Gas (CNG)`
     + Propane 
     + Hydrogen 
     + Methanol
     + Gasoline 
     + Diesel 
     + `Unknown Fuel`)) * 100 AS gasoline_market_share

FROM power_automate_course.ev_vehicle_registrations
ORDER BY gasoline_market_share DESC;


-- =====================================================
-- 10. STATES WITH EV ADOPTION OF AT LEAST 1%
-- =====================================================

-- Screen for states/locations with an EV adoption rate
-- of at least 1%.
-- This 1% value is an analytical screening threshold,
-- not an official government benchmark.
--
-- A subquery is used so the calculated EV adoption rate
-- can be filtered in the outer query.
SELECT *
FROM (
    SELECT
        State,
        `Electric (EV)` AS ev_count,

        (
            `Electric (EV)`
            + `Plug-In Hybrid Electric (PHEV)`
            + `Hybrid Electric (HEV)`
            + Biodiesel
            + `Ethanol/Flex (E85)`
            + `Compressed Natural Gas (CNG)`
            + Propane
            + Hydrogen
            + Methanol
            + Gasoline
            + Diesel
            + `Unknown Fuel`
        ) AS total_vehicles,

        (
            `Electric (EV)` /
            (
                `Electric (EV)`
                + `Plug-In Hybrid Electric (PHEV)`
                + `Hybrid Electric (HEV)`
                + Biodiesel
                + `Ethanol/Flex (E85)`
                + `Compressed Natural Gas (CNG)`
                + Propane
                + Hydrogen
                + Methanol
                + Gasoline
                + Diesel
                + `Unknown Fuel`
            )
        ) * 100 AS ev_adoption_rate

    FROM power_automate_course.ev_vehicle_registrations
) AS analysis

WHERE ev_adoption_rate >= 1

ORDER BY ev_adoption_rate DESC;


-- =====================================================
-- 11. LOW-ADOPTION STATES
-- =====================================================

-- Identify the 10 states with the lowest EV adoption rates.
-- District of Columbia is excluded so the result represents
-- U.S. states only.
SELECT *
FROM (
    SELECT
        State,
        `Electric (EV)` AS ev_count,

        (
            `Electric (EV)`
            + `Plug-In Hybrid Electric (PHEV)`
            + `Hybrid Electric (HEV)`
            + Biodiesel
            + `Ethanol/Flex (E85)`
            + `Compressed Natural Gas (CNG)`
            + Propane
            + Hydrogen
            + Methanol
            + Gasoline
            + Diesel
            + `Unknown Fuel`
        ) AS total_vehicles,

        (
            `Electric (EV)` /
            (
                `Electric (EV)`
                + `Plug-In Hybrid Electric (PHEV)`
                + `Hybrid Electric (HEV)`
                + Biodiesel
                + `Ethanol/Flex (E85)`
                + `Compressed Natural Gas (CNG)`
                + Propane
                + Hydrogen
                + Methanol
                + Gasoline
                + Diesel
                + `Unknown Fuel`
            )
        ) * 100 AS ev_adoption_rate

    FROM power_automate_course.ev_vehicle_registrations
) AS analysis

WHERE State <> 'District of Columbia'

ORDER BY ev_adoption_rate ASC
LIMIT 10;


-- =====================================================
-- 12. NON-EV VEHICLE OPPORTUNITY
-- =====================================================

-- Calculate the total number of non-EV vehicles in each
-- state by subtracting EVs from the total vehicle population.
-- District of Columbia is excluded and the 10 states with
-- the largest non-EV vehicle populations are returned.
SELECT
    State,
    `Electric (EV)` AS ev_count,

    (
        `Electric (EV)`
        + `Plug-In Hybrid Electric (PHEV)`
        + `Hybrid Electric (HEV)`
        + Biodiesel
        + `Ethanol/Flex (E85)`
        + `Compressed Natural Gas (CNG)`
        + Propane
        + Hydrogen
        + Methanol
        + Gasoline
        + Diesel
        + `Unknown Fuel`
    ) AS total_vehicles,

    (
        (
            `Electric (EV)`
            + `Plug-In Hybrid Electric (PHEV)`
            + `Hybrid Electric (HEV)`
            + Biodiesel
            + `Ethanol/Flex (E85)`
            + `Compressed Natural Gas (CNG)`
            + Propane
            + Hydrogen
            + Methanol
            + Gasoline
            + Diesel
            + `Unknown Fuel`
        )
        - `Electric (EV)`
    ) AS non_ev_vehicles

FROM power_automate_course.ev_vehicle_registrations

WHERE State <> 'District of Columbia'

ORDER BY non_ev_vehicles DESC

LIMIT 10;
