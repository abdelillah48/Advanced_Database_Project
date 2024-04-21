-- Drop existing tables with CASCADE to also remove dependent constraints
DROP TABLE IF EXISTS fait_listing CASCADE;
DROP TABLE IF EXISTS dim_date CASCADE;
DROP TABLE IF EXISTS dim_location CASCADE;
DROP TABLE IF EXISTS dim_commodité CASCADE;

DROP SEQUENCE IF EXISTS seq_date_id;
DROP SEQUENCE IF EXISTS seq_location_id;
DROP SEQUENCE IF EXISTS seq_commodité_id;

-- Create dimension and fact table with appropriate column sizes
CREATE TABLE dim_location (
    location_id SERIAL PRIMARY KEY,
    country VARCHAR(255),   
    state_loc VARCHAR(255),
    street VARCHAR(255),
    city VARCHAR(255),
    code_country VARCHAR(255)
);

CREATE TABLE dim_date (
    date_id SERIAL PRIMARY KEY,
    first_review DATE,
    last_review DATE,
    calendar_updated VARCHAR(255)  
);

CREATE TABLE dim_commodité (
    commodité_id SERIAL PRIMARY KEY,
    room_type VARCHAR(255),   
    bed_type VARCHAR(255)
);

CREATE TABLE fait_listing (
    listing_id INTEGER PRIMARY KEY NOT NULL,
    date_id INTEGER,
    location_id INTEGER,
    commodité_id INTEGER,
    bathroom_nbr FLOAT,
    bedroom_nbr FLOAT,
    bed_nbr FLOAT,
    accommodates FLOAT,
    maximum_night FLOAT,
    minimun_night FLOAT,
    price FLOAT,
    weekly_price FLOAT,
    monthly_price FLOAT,
    review_nbr FLOAT,
    propreté_score FLOAT,
    checkin_score FLOAT,
    communication_score FLOAT,
    review_per_month FLOAT,
    review_score_value FLOAT,
    location_score_value FLOAT,
    review_score_accuracy FLOAT,
    review_score_rate FLOAT,

    FOREIGN KEY (date_id) REFERENCES dim_date(date_id),
    FOREIGN KEY (location_id) REFERENCES dim_location(location_id),
    FOREIGN KEY (commodité_id) REFERENCES dim_commodité(commodité_id)
);

-- Create sequences for each table starting from 1
CREATE SEQUENCE seq_date_id START WITH 1;
CREATE SEQUENCE seq_location_id START WITH 1;
CREATE SEQUENCE seq_commodité_id START WITH 1;

-- Trigger functions to assign IDs automatically before inserts
CREATE OR REPLACE FUNCTION assign_date_id()
RETURNS TRIGGER AS $$
BEGIN
    NEW.date_id := nextval('seq_date_id');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_dim_date
BEFORE INSERT ON dim_date
FOR EACH ROW
EXECUTE FUNCTION assign_date_id();

CREATE OR REPLACE FUNCTION assign_location_id()
RETURNS TRIGGER AS $$
BEGIN
    NEW.location_id := nextval('seq_location_id');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_dim_location
BEFORE INSERT ON dim_location
FOR EACH ROW
EXECUTE FUNCTION assign_location_id();

CREATE OR REPLACE FUNCTION assign_commodité_id()
RETURNS TRIGGER AS $$
BEGIN
    NEW.commodité_id := nextval('seq_commodité_id');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_dim_commodité
BEFORE INSERT ON dim_commodité
FOR EACH ROW
EXECUTE FUNCTION assign_commodité_id();
