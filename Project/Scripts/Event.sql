-- 10. Remove Expired Subscriptions
DELIMITER $$
CREATE EVENT IF NOT EXISTS RemoveExpiredSubs
ON SCHEDULE EVERY 1 DAY
DO
BEGIN
    DELETE FROM User_Subscription
    WHERE end_date < CURDATE();

    INSERT INTO Notifications (user_id, message, created_at)
    SELECT user_id, 'Your subscription has expired and was removed.', NOW()
    FROM User_Subscription
    WHERE end_date < CURDATE();
END$$
DELIMITER ;

-- 11. Refresh Popular Content Rankings
DELIMITER $$
CREATE EVENT IF NOT EXISTS RefreshTopContent
ON SCHEDULE EVERY 1 DAY
DO
BEGIN
    DELETE FROM Top_Content;

    INSERT INTO Top_Content (genre_id, content_id, views)
    SELECT cg.genre_id, w.content_id, COUNT(*) AS views
    FROM Content_WatchHistory w
    JOIN Content_Genre cg ON cg.content_id = w.content_id
    GROUP BY cg.genre_id, w.content_id
    ORDER BY cg.genre_id, views DESC
    LIMIT 10;
END$$
DELIMITER ;
