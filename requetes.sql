-- Selectionner les annonces dont le prix est supérieurs à 100

SELECT *
FROM fait_listing
WHERE price > 100;


--Nombre de Locations à Paris

SELECT COUNT(*) FROM fait_listing f JOIN dim_location l ON f.location_id = l.location_id WHERE l.city = 'Paris';

-- Calculer la note moyenne de satisfaction client pour différents types de logement (appartements, villas, studios)
SELECT c.room_type, AVG(f.review_score_value) AS avg_review_score
FROM fait_listing f
JOIN dim_commodité c ON f.commodité_id = c.commodité_id
GROUP BY c.room_type;


-- Analyse de la distribution des prix par type de logement et par ville

SELECT l.city, c.room_type, 
       COUNT(*) AS num_listings, 
       MIN(f.price) AS min_price, 
       MAX(f.price) AS max_price, 
       AVG(f.price) AS avg_price
FROM fait_listing f
JOIN dim_location l ON f.location_id = l.location_id
JOIN dim_commodité c ON f.commodité_id = c.commodité_id
GROUP BY l.city, c.room_type
ORDER BY l.city, c.room_type;

--  Calcul des tendances de réservation par mois

SELECT EXTRACT(MONTH FROM d.first_review) AS month,
       COUNT(*) AS num_bookings
FROM fait_listing f
JOIN dim_date d ON f.date_id = d.date_id
GROUP BY month
ORDER BY month;



SELECT country, state_loc, city, COUNT(*) AS total_listings
    FROM dim_location
    GROUP BY ROLLUP(country, state_loc, city);


SELECT
    listing_id,
    price,
    RANK() OVER (ORDER BY price DESC) AS price_rank
FROM
    fait_listing;

--  une fonction de fenêtrage comme RANK() pour attribuer un classement aux locations en fonction du prix

SELECT
    listing_id,
    price,
    RANK() OVER (ORDER BY price DESC) AS price_rank
FROM
    fait_listing;

-- produire des totaux agrégés par pays, par ville, ainsi que des totaux agrégés par combinaisons spécifiques de pays/ville

SELECT
    country,
    city,
    SUM(price) AS total_price
FROM
    fait_listing
GROUP BY
    GROUPING SETS ((country), (city), (country, city))
ORDER BY
    country, city;


-- Requête pour calculer la note moyenne de satisfaction client par type de logement avec jointure
SELECT c.room_type,
       AVG(f.review_score_rate) AS avg_satisfaction_score
FROM fait_listing f
JOIN dim_commodité c ON f.commodité_id = c.commodité_id
GROUP BY c.room_type;



-- Nombre de listing par pays
SELECT l.country, COUNT(*) AS number_of_listings
FROM fait_listing f
JOIN dim_location l ON f.location_id = l.location_id
GROUP BY l.country;


-- Cette requête calcule le nombre total de critiques par listing en agrégeant les données par année et mois des dates de première et dernière critique, en utilisant ROLLUP pour obtenir des sous-totaux hiérarchiques. Elle aide à analyser les tendances des critiques sur différentes périodes, fournissant une vue détaillée et agrégée de l'activité des critiques au fil du temps.


SELECT 
    EXTRACT(YEAR FROM first_review) AS first_review_year,
    EXTRACT(MONTH FROM first_review) AS first_review_month,
    EXTRACT(YEAR FROM last_review) AS last_review_year,
    EXTRACT(MONTH FROM last_review) AS last_review_month,
    COUNT(review_nbr) AS total_reviews
FROM fait_listing
JOIN dim_date ON fait_listing.date_id = dim_date.date_id
GROUP BY ROLLUP (
    EXTRACT(YEAR FROM first_review),
    EXTRACT(MONTH FROM first_review),
    EXTRACT(YEAR FROM last_review),
    EXTRACT(MONTH FROM last_review)
);



-- Analyse de la variation des prix selon les saisons

SELECT calendar_updated, AVG(price) AS avg_seasonal_price
FROM fait_listing
JOIN dim_date ON fait_listing.date_id = dim_date.date_id
GROUP BY calendar_updated;


-- Calculer le prix moyen, minimum et maximum par type de chambre et ville

SELECT city, room_type, AVG(price) AS avg_price, MIN(price) AS min_price, MAX(price) AS max_price
FROM fait_listing
JOIN dim_commodite ON fait_listing.commodité_id = dim_commodite.commodité_id
JOIN dim_location ON fait_listing.location_id = dim_location.location_id
GROUP BY city, room_type;


-- Nombre de listings et score moyen de propreté par pays

SELECT country, COUNT(listing_id) AS number_of_listings, AVG(proprete_score) AS avg_cleanliness
FROM fait_listing
JOIN dim_location ON fait_listing.location_id = dim_location.location_id
GROUP BY country;

-- Analyse des scores de propreté par ville et quartier

SELECT 
    city,
    street,
    AVG(proprete_score) AS average_cleanliness_score
FROM fait_listing
JOIN dim_location ON fait_listing.location_id = dim_location.location_id
GROUP BY ROLLUP (city, street);

-- Calcule le revenu total par année et par pays, incluant les agrégats à plusieurs niveaux grâce à GROUP BY CUBE.

SELECT 
    EXTRACT(YEAR FROM first_review) AS year,
    country,
    SUM(price * review_nbr) AS total_revenue
FROM fait_listing
JOIN dim_date ON fait_listing.date_id = dim_date.date_id
JOIN dim_location ON fait_listing.location_id = dim_location.location_id
GROUP BY CUBE (EXTRACT(YEAR FROM first_review), country);


--Variation du nombre de critiques en fonction de la capacité d'accueil

SELECT accommodates,
       COUNT(review_nbr) AS reviews_count,
       AVG(review_nbr) AS average_reviews
FROM fait_listing
GROUP BY accommodates
ORDER BY accommodates;



-- Calcule le prix moyen et le prix maximum pour des listings, regroupés par type de chambre et pays.

SELECT 
    room_type,
    country,
    AVG(price) AS average_price,
    MAX(price) AS max_price
FROM fait_listing
JOIN dim_location ON fait_listing.location_id = dim_location.location_id
JOIN dim_commodite ON fait_listing.commodité_id = dim_commodite.commodité_id
GROUP BY GROUPING SETS ((room_type, country), (room_type), (country));


-- REQUETES FRANCE

--Liste des propriétés en France de type "Entire home/apt" avec un excellent score de propreté



SELECT listing_id, city, street, price, proprete_score
FROM fait_listing
JOIN dim_location ON fait_listing.location_id = dim_location.location_id
JOIN dim_commodite ON fait_listing.commodité_id = dim_commodite.commodité_id
WHERE country = 'France' AND room_type = 'Entire home/apt' AND proprete_score >= 9
ORDER BY proprete_score DESC;


-- Prix moyen et nombre de listings pour un type de chambre spécifique en France


    SELECT city, AVG(price) AS average_price, COUNT(listing_id) AS number_of_listings
    FROM fait_listing
    JOIN dim_location ON fait_listing.location_id = dim_location.location_id
    JOIN dim_commodite ON fait_listing.commodité_id = dim_commodite.commodité_id
    WHERE country = 'France' AND room_type = 'Entire home/apt' AND proprete_score >= 9
    GROUP BY city;

--Top 5 des villes en France avec les meilleurs scores de propreté pour les logements entiers



SELECT city, AVG(proprete_score) AS avg_cleanliness_score
FROM fait_listing
JOIN dim_location ON fait_listing.location_id = dim_location.location_id
JOIN dim_commodite ON fait_listing.commodité_id = dim_commodite.commodité_id
WHERE country = 'France' AND room_type = 'Entire home/apt'
GROUP BY city
ORDER BY avg_cleanliness_score DESC
LIMIT 5;

-- Évolution des prix des logements entiers de haute propreté en France sur l'année


SELECT EXTRACT(MONTH FROM first_review) AS month, EXTRACT(YEAR FROM first_review) AS year, AVG(price) AS average_price
FROM fait_listing
JOIN dim_date ON fait_listing.date_id = dim_date.date_id
JOIN dim_location ON fait_listing.location_id = dim_location.location_id
JOIN dim_commodite ON fait_listing.commodité_id = dim_commodite.commodité_id
WHERE country = 'France' AND room_type = 'Entire home/apt' AND proprete_score >= 9
GROUP BY EXTRACT(YEAR FROM first_review), EXTRACT(MONTH FROM first_review)
ORDER BY year, month;


--Impact des commodités sur les prix des logements entiers très propres en France



SELECT room_type, bed_type, AVG(price) AS avg_price, COUNT(listing_id) AS count_listings
FROM fait_listing
JOIN dim_commodite ON fait_listing.commodité_id = dim_commodite.commodité_id
JOIN dim_location ON fait_listing.location_id = dim_location.location_id
WHERE country = 'France' AND room_type = 'Entire home/apt' AND proprete_score >= 9
GROUP BY room_type, bed_type;


-- Durée moyenne des séjours dans des logements entiers très propres en France

SELECT city, AVG(maximum_night) AS avg_max_nights, AVG(minimun_night) AS avg_min_nights
FROM fait_listing
JOIN dim_commodite ON fait_listing.commodité_id = dim_commodite.commodité_id
JOIN dim_location ON fait_listing.location_id = dim_location.location_id
WHERE country = 'France' AND room_type = 'Entire home/apt' AND proprete_score >= 9
GROUP BY city;


-- Impact des commodités sur les prix des logements entiers très propres en France

SELECT EXTRACT(MONTH FROM first_review) AS month, COUNT(listing_id) AS booked_listings, AVG(accommodates) AS average_capacity
FROM fait_listing
JOIN dim_commodite ON fait_listing.commodité_id = dim_commodite.commodité_id
JOIN dim_date ON fait_listing.date_id = dim_date.date_id
JOIN dim_location ON fait_listing.location_id = dim_location.location_id
WHERE country = 'France' AND room_type = 'Entire home/apt' AND proprete_score >= 9
GROUP BY EXTRACT(MONTH FROM first_review)
ORDER BY month;
