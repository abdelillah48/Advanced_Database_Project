import psycopg2
import pandas as pd

conn = None

try:
    # Connexion à la base de données
    conn = psycopg2.connect(
        dbname="postgres",
        user="postgres",
        password="abdou khotri",
        host="localhost"
    )
    conn.autocommit = False
    cur = conn.cursor()

    # Charger les données à partir du CSV
    data = pd.read_csv("Airbnb_Data_Nouveau.csv")

    # Insertion dans la table dim_location
    for index, row in data.iterrows():
        try:
            cur.execute("""
                INSERT INTO dim_location (country, state_loc, city, street, code_country)
                VALUES (%s, %s, %s, %s, %s) RETURNING location_id
                """,
                (row['Country'], row['State'], row['City'], row['Street'], row['Country Code'])
            )
            location_id = cur.fetchone()[0]

            # Insérer les données dans la table dim_date et récupérer date_id
            cur.execute("""
                INSERT INTO dim_date (first_review, last_review, calendar_updated)
                VALUES (%s, %s, %s) RETURNING date_id
                """,
                (row['First Review'], row['Last Review'], row['Calendar Updated'])
            )
            date_id = cur.fetchone()[0]

            # Insertion dans la table dim_commodité
            cur.execute("""
                INSERT INTO dim_commodité (room_type, bed_type)
                VALUES (%s, %s) RETURNING commodité_id
                """,
                (row['Room Type'], row['Bed Type'])
            )
            commodité_id = cur.fetchone()[0]

            cur.execute("""
                INSERT INTO fait_listing (
                    listing_id, date_id, location_id, commodité_id, bathroom_nbr, bedroom_nbr, bed_nbr, accommodates,
                    maximum_night, minimun_night, price, weekly_price, monthly_price, review_nbr, propreté_score,
                    checkin_score, communication_score, review_per_month, review_score_value, location_score_value,
                    review_score_accuracy, review_score_rate
                ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                """,
                (row['ID'], date_id, location_id, commodité_id, row['Bathrooms'],
                 row['Bedrooms'], row['Beds'], row['Accommodates'], row['Maximum Nights'], row['Minimum Nights'],
                 row['Price'], row['Weekly Price'], row['Monthly Price'], row['Number of Reviews'], row['Review Scores Cleanliness'],
                 row['Review Scores Checkin'], row['Review Scores Communication'], row['Reviews per Month'], row['Review Scores Value'],
                 row['Review Scores Location'], row['Review Scores Accuracy'], row['Review Scores Rating'])
            )
            
            # Commit après chaque ligne insérée pour s'assurer que les données soient sauvegardées
            conn.commit()
            
        except psycopg2.Error as e:
            print('Database error:', e)
            conn.rollback()

except Exception as e:
    print("Connection error:", e)
finally:
    if conn:
        cur.close()
        conn.close()
