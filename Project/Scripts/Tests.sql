
-- =========================================
-- TESTS.SQL - Unit, Integration, Integrity, and Performance Tests
-- =========================================

-- UNIT TESTS

-- 1. Trigger: Watchlist Capacity
INSERT INTO Watchlist (user_id, content_id, added_at)
VALUES (1, 9999, NOW());

SELECT COUNT(*) AS watchlist_count FROM Watchlist WHERE user_id = 1;

-- 2. Trigger: Rating Impact on Content Availability
INSERT INTO Review (user_id, content_id, rating, review_time)
VALUES (2, 101, 1.0, NOW());

SELECT content_id, status FROM Content_Availability WHERE content_id = 101;

-- 3. Trigger: Prevent Duplicate Director
INSERT INTO Content_Director (content_id, director_id)
VALUES (101, 5); -- Should fail if already assigned

SELECT * FROM Director_Assignment_Errors WHERE content_id = 101 AND director_id = 5;

-- 4. Function: TopGenres
SELECT TopGenres() AS Top_Genres;

-- 5. Function: TopCollaborators
SELECT TopCollaborators() AS Top_Collab;

-- 6. Function: IsSubscriptionActive
SELECT IsSubscriptionActive(1) AS Subscription_Status;

-- 7. Procedure: MonthlyUserActivity Report
CALL MonthlyUserActivity();

-- 8. Procedure: UpdateContentAvailabilityByCriteria
CALL UpdateContentAvailabilityByCriteria();

SELECT content_id, status FROM Content_Availability WHERE status = 'Archived';

-- 9. Procedure: LogFailedPayment
CALL LogFailedPayment(1, 2, 'Card expired');
SELECT * FROM Payment_Errors WHERE user_id = 1;
SELECT * FROM Notifications WHERE user_id = 1;

-- INTEGRATION TEST

-- After review insert, check if status changes
INSERT INTO Review (user_id, content_id, rating, review_time)
VALUES (4, 101, 1.5, NOW());

SELECT content_id, status FROM Content_Availability WHERE content_id = 101;

-- Check function still returns valid result after review insert
SELECT TopGenres();

-- DATA INTEGRITY TEST

-- Prevent duplicate director insertion
INSERT INTO Content_Director (content_id, director_id)
VALUES (101, 5); -- Should be blocked

-- Check for duplicates
SELECT content_id, director_id, COUNT(*) AS duplicates
FROM Content_Director
GROUP BY content_id, director_id
HAVING COUNT(*) > 1;

-- Check expired subscriptions
SELECT * FROM User_Subscription WHERE end_date < CURDATE();

-- PERFORMANCE TEST

-- Enable profiling (if supported)
-- SET profiling = 1;
CALL MonthlyUserActivity();
-- SET profiling = 0;
-- SHOW PROFILES;
