/*****PLEASE ENTER YOUR DETAILS BELOW*****/
--T6-pat-json.sql

--Student ID: 34312943
--Student Name: Noppawan Soontornkrut


/* Comments for your marker:




*/

-- PLEASE PLACE REQUIRED SQL SELECT STATEMENT TO GENERATE
-- THE COLLECTION OF JSON DOCUMENTS HERE
-- ENSURE that your query is formatted and has a semicolon
-- (;) at the end of this answer


SELECT
    JSON_OBJECT(
        '_id' VALUE D.DRIVER_ID,
        'name' VALUE DRIVER_GIVEN || ' ' || DRIVER_FAMILY,
        'licence_num' VALUE DRIVER_LICENCE,
        'no_of_trips' VALUE COUNT(DISTINCT TRIP_ID),
        'suspended' VALUE DRIVER_SUSPENDED,
        'trips_info' VALUE JSON_ARRAYAGG(
            JSON_OBJECT(
                'trip_id' VALUE TRIP_ID,
                'veh_vin' VALUE VEH_VIN,
                'pick_up' VALUE JSON_OBJECT(
                    'location_id' VALUE PL.LOCN_ID,
                    'location_name' VALUE PL.LOCN_NAME,
                    'intended_datetime' VALUE TO_CHAR(TRIP_INT_PICKUPDT, 'DD/MM/YYYY HH24:mi'),
                    'actual_datetime' VALUE TO_CHAR(TRIP_ACT_PICKUPDT, 'DD/MM/YYYY HH24:mi')
                ),
                'drop_off' VALUE JSON_OBJECT(
                    'location_id' VALUE DL.LOCN_ID,
                    'location_name' VALUE DL.LOCN_NAME,
                    'intended_datetime' VALUE TO_CHAR(TRIP_INT_DROPOFFDT, 'DD/MM/YYYY HH24:mi'),
                    'actual_datetime' VALUE TO_CHAR(TRIP_ACT_DROPOFFDT, 'DD/MM/YYYY HH24:mi')
                )
            )
        ) FORMAT JSON
    ) 
FROM
    TRIP T
    JOIN DRIVER D ON D.DRIVER_ID = T.DRIVER_ID
    JOIN LOCATION PL ON T.PICKUP_LOCN_ID = PL.LOCN_ID
    JOIN LOCATION DL ON T.DROPOFF_LOCN_ID = DL.LOCN_ID
WHERE
    TRIP_ACT_PICKUPDT IS NOT NULL AND TRIP_ACT_DROPOFFDT IS NOT NULL
GROUP BY
    D.DRIVER_ID,
    DRIVER_GIVEN,
    DRIVER_FAMILY,
    DRIVER_LICENCE,
    DRIVER_SUSPENDED
HAVING
    COUNT(DISTINCT CASE WHEN TRIP_ACT_PICKUPDT IS NOT NULL AND TRIP_ACT_DROPOFFDT IS NOT NULL THEN TRIP_ID END) > 0;


