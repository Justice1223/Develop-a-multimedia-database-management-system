import csv
import mysql.connector

print("Connecting to database...")
try:
    db = mysql.connector.connect(
        host="localhost",
        user="root",
        password="qqq60680797", 
        database="MultimediaContentDB"
    )
except mysql.connector.Error as err:
    print(f"Connection failed: {err}")
    exit(1)

cursor = db.cursor()

def get_or_insert(table, column, value):
    try:
        cursor.execute(f"SELECT id FROM {table} WHERE {column} = %s", (value,))
        result = cursor.fetchone()
        if result:
            return result[0]
        cursor.execute(f"INSERT INTO {table} ({column}) VALUES (%s)", (value,))
        db.commit()
        return cursor.lastrowid
    except mysql.connector.Error as err:
        print(f"[{table}] Insert error: {err} | Value: {value}")
        return None

print("Opening CSV file...")
try:
    with open('Data.csv', encoding='utf-8') as csvfile:
        reader = csv.DictReader(csvfile)
        for i, row in enumerate(reader):
           # if i > 5: break  # For testing only: remove this line when ready for full run

            title = row['title']
            content_type = row['type']
            director_name = row['director']
            cast_list = [name.strip() for name in row['cast'].split(',') if name.strip()]
            country_list = [c.strip() for c in row['country'].split(',') if c.strip()]
            release_year = int(row['release_year']) if row['release_year'].isdigit() else None
            rating = row['rating'].strip()
            duration = row['duration']
            genre_list = [g.strip() for g in row['listed_in'].split(',') if g.strip()]
            description = row['description']
            show_id = row['show_id']

            print(f"Inserting content: {show_id} - {title}")

            rating_id = get_or_insert("Rating", "name", rating)
            if rating_id is None:
                print("Skipping content due to rating error.")
                continue

            try:
                cursor.execute(
            "INSERT IGNORE INTO Content (show_id, title, type, release_year, duration, rating_id, description) "
            "VALUES (%s, %s, %s, %s, %s, %s, %s)",
            (show_id, title, content_type, release_year, duration, rating_id, description)
                   )
                db.commit()
                content_id = cursor.lastrowid
            except mysql.connector.Error as err:
                print(f"Failed to insert content {title}: {err}")
                continue

            # Director
            if director_name:
                director_id = get_or_insert("Director", "name", director_name)
                if director_id:
                    try:
                        cursor.execute(
                            "INSERT IGNORE INTO Content_Director (content_id, director_id) VALUES (%s, %s)",
                            (content_id, director_id)
                        )
                        db.commit()
                    except mysql.connector.Error as err:
                        print(f"Director link error: {err}")

            # Actors
            for actor in cast_list:
                actor_id = get_or_insert("Actor", "name", actor)
                if actor_id:
                    cursor.execute(
                        "INSERT IGNORE INTO Content_Cast (content_id, actor_id) VALUES (%s, %s)",
                        (content_id, actor_id)
                    )
                    db.commit()

            # Countries
            for country in country_list:
                country_id = get_or_insert("Country", "name", country)
                if country_id:
                    cursor.execute(
                        "INSERT IGNORE INTO Content_Country (content_id, country_id) VALUES (%s, %s)",
                        (content_id, country_id)
                    )
                    db.commit()

            # Genres
            for genre in genre_list:
                genre_id = get_or_insert("Genre", "name", genre)
                if genre_id:
                    cursor.execute(
                        "INSERT IGNORE INTO Content_Genre (content_id, genre_id) VALUES (%s, %s)",
                        (content_id, genre_id)
                    )
                    db.commit()
except FileNotFoundError:
    print("Error: Data.csv not found.")
except Exception as e:
    print(f"Unhandled error: {e}")

cursor.close()
db.close()
print("Done.")
