-- 7. Monthly User Activity Report
DELIMITER $$
CREATE PROCEDURE MonthlyUserActivity()
BEGIN
    SELECT u.id AS user_id, u.name,
           COUNT(w.content_id) AS items_watched,
           AVG(r.rating) AS avg_rating,
           SUM(w.watch_hours) AS total_watch_time
    FROM User u
    LEFT JOIN Content_WatchHistory w ON u.id = w.user_id AND w.watch_time >= DATE_SUB(NOW(), INTERVAL 1 MONTH)
    LEFT JOIN Review r ON u.id = r.user_id AND r.review_time >= DATE_SUB(NOW(), INTERVAL 1 MONTH)
    GROUP BY u.id;
END$$
DELIMITER ;

-- 8. Batch Content Availability Update
DELIMITER $$
CREATE PROCEDURE UpdateContentAvailabilityByCriteria()
BEGIN
    UPDATE Content_Availability ca
    JOIN Content c ON c.id = ca.content_id
    SET ca.status = 'Archived'
    WHERE c.release_year < YEAR(CURDATE()) - 5;
END$$
DELIMITER ;

-- 9. Handle Failed Payments
DELIMITER $$
CREATE PROCEDURE LogFailedPayment(
    IN user_id INT,
    IN method_id INT,
    IN reason VARCHAR(255)
)
BEGIN
    INSERT INTO Payment_Errors (user_id, method_id, reason, error_time)
    VALUES (user_id, method_id, reason, NOW());

    -- Notify logic would be via application layer, simulate with insert
    INSERT INTO Notifications (user_id, message, created_at)
    VALUES (user_id, CONCAT('Payment failed: ', reason), NOW());
END$$
DELIMITER ;
