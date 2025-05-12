-- 1. Limit Watchlist Capacity
DELIMITER $$
CREATE TRIGGER Limit_Watchlist
BEFORE INSERT ON Watchlist
FOR EACH ROW
BEGIN
    DECLARE count_items INT;
    SELECT COUNT(*) INTO count_items
    FROM Watchlist
    WHERE user_id = NEW.user_id;

    IF count_items >= 50 THEN
        DELETE FROM Watchlist
        WHERE user_id = NEW.user_id
        ORDER BY added_at ASC
        LIMIT 1;
    END IF;
END$$
DELIMITER ;

-- 2. Rating Impact on Content Availability
DELIMITER $$
CREATE TRIGGER RatingImpact
AFTER INSERT ON Review
FOR EACH ROW
BEGIN
    DECLARE avg_rating DECIMAL(3,2);
    SELECT AVG(rating) INTO avg_rating
    FROM Review
    WHERE content_id = NEW.content_id;

    IF avg_rating < 2.0 THEN
        UPDATE Content_Availability
        SET status = 'Archived'
        WHERE content_id = NEW.content_id;
    END IF;
END$$
DELIMITER ;

-- 3. Ensure Unique Director for Content
DELIMITER $$
CREATE TRIGGER PreventDuplicateDirector
BEFORE INSERT ON Content_Director
FOR EACH ROW
BEGIN
    DECLARE exists_count INT;
    SELECT COUNT(*) INTO exists_count
    FROM Content_Director
    WHERE content_id = NEW.content_id AND director_id = NEW.director_id;

    IF exists_count > 0 THEN
        INSERT INTO Director_Assignment_Errors(content_id, director_id, error_time)
        VALUES (NEW.content_id, NEW.director_id, NOW());
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Duplicate director assignment blocked.';
    END IF;
END$$
DELIMITER ;
