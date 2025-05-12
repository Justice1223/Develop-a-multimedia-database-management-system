-- 4. Rank Top Genres by Watch Hours (last 30 days)
DELIMITER $$
CREATE FUNCTION TopGenres()
RETURNS TEXT
DETERMINISTIC
BEGIN
    DECLARE result TEXT;
    SELECT GROUP_CONCAT(g.name ORDER BY SUM(w.watch_hours) DESC SEPARATOR ', ')
    INTO result
    FROM Genre g
    JOIN Content_Genre cg ON cg.genre_id = g.id
    JOIN Content_WatchHistory w ON w.content_id = cg.content_id
    WHERE w.watch_time >= DATE_SUB(NOW(), INTERVAL 30 DAY)
    GROUP BY g.id
    LIMIT 3;

    RETURN result;
END$$
DELIMITER ;

-- 5. Most Frequent Actor-Director Collaborators
DELIMITER $$
CREATE FUNCTION TopCollaborators()
RETURNS TEXT
DETERMINISTIC
BEGIN
    DECLARE result TEXT;
    SELECT CONCAT(a.name, ' & ', d.name)
    INTO result
    FROM Content_Cast cc
    JOIN Actor a ON a.id = cc.actor_id
    JOIN Content_Director cd ON cd.content_id = cc.content_id
    JOIN Director d ON d.id = cd.director_id
    GROUP BY a.id, d.id
    ORDER BY COUNT(*) DESC
    LIMIT 1;

    RETURN result;
END$$
DELIMITER ;

-- 6. Validate Subscription Status
DELIMITER $$
CREATE FUNCTION IsSubscriptionActive(uid INT)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE active BOOLEAN DEFAULT FALSE;
    SELECT CASE
        WHEN MAX(us.end_date) >= CURDATE() THEN TRUE
        ELSE FALSE
    END INTO active
    FROM User_Subscription us
    WHERE us.user_id = uid;

    RETURN active;
END$$
DELIMITER ;
