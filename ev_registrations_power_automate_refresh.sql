USE power_automate_course;

DROP PROCEDURE IF EXISTS refresh_ev_vehicle_registrations;

DELIMITER //

CREATE PROCEDURE refresh_ev_vehicle_registrations()
BEGIN
    DECLARE old_safe_updates INT DEFAULT 0;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET SQL_SAFE_UPDATES = old_safe_updates;
        RESIGNAL;
    END;

    SET old_safe_updates = @@SQL_SAFE_UPDATES;
    SET SQL_SAFE_UPDATES = 0;

    START TRANSACTION;

    DELETE FROM ev_vehicle_registrations;

    INSERT INTO ev_vehicle_registrations
    SELECT *
    FROM ev_vehicle_registrations_staging;

    COMMIT;

    SET SQL_SAFE_UPDATES = old_safe_updates;
END //

DELIMITER ;

-- Verification only. The procedure is called by Power Automate Desktop
-- only after staging validation returns PASS. Do not call it manually
-- unless you intend to replace the production table with staging data.
SHOW CREATE PROCEDURE power_automate_course.refresh_ev_vehicle_registrations;

SELECT
    COUNT(*) AS staging_rows,
    COUNT(DISTINCT State) AS staging_unique_states,
    SUM(`Electric (EV)`) AS staging_total_ev
FROM power_automate_course.ev_vehicle_registrations_staging;

SELECT
    COUNT(*) AS production_rows,
    COUNT(DISTINCT State) AS production_unique_states,
    SUM(`Electric (EV)`) AS production_total_ev
FROM power_automate_course.ev_vehicle_registrations;
