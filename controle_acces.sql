
-- Création des rôles pour divers niveaux d'accès
CREATE ROLE role_admin WITH PASSWORD 'admin';
CREATE ROLE role_analyste WITH PASSWORD 'analyst';
CREATE ROLE role_gestionnaire WITH PASSWORD 'gestionnaire';
CREATE ROLE role_service_client WITH PASSWORD 'service client';

-- Révocation des privilèges par défaut sur la base de données pour le public
REVOKE ALL PRIVILEGES ON DATABASE mydatabase FROM PUBLIC;

-- Attribution des privilèges aux rôles
-- Admin a des privilèges complets sur la base de données
GRANT ALL PRIVILEGES ON DATABASE mydatabase TO role_admin;

-- Analyste a le droit de lire toutes les données pour l'analyse
GRANT SELECT ON dim_date TO role_analyste;
GRANT SELECT ON dim_location TO role_analyste;
GRANT SELECT ON dim_commodite TO role_analyste;
GRANT SELECT ON fait_listing TO role_analyste;

-- Gestionnaire de propriété a des droits de mise à jour spécifiques
GRANT SELECT, UPDATE ON fait_listing TO role_gestionnaire;
GRANT SELECT ON dim_location TO role_gestionnaire;
GRANT INSERT, DELETE ON fait_listing TO role_gestionnaire; -- Ajout des droits d'insertion et de suppression

-- Service client a accès aux informations de contact et aux avis
GRANT SELECT ON dim_location TO role_service_client; -- Accès aux détails de localisation
GRANT SELECT(column_name) ON fait_listing TO role_service_client; -- Seulement les colonnes pertinentes pour le support

-- Création d'une vue filtrée pour le gestionnaire de propriété (ex. en France)
CREATE VIEW france_properties AS
SELECT * FROM fait_listing
WHERE location_id IN (SELECT location_id FROM dim_location WHERE country = 'France');
GRANT SELECT ON france_properties TO role_gestionnaire;

-- Activation de la sécurité au niveau des lignes pour la table fait_listing
ALTER TABLE fait_listing ENABLE ROW LEVEL SECURITY;

-- Politique de sécurité pour restreindre l'accès selon le pays
CREATE POLICY access_policy ON fait_listing
FOR SELECT USING (
    location_id IN (SELECT location_id FROM dim_location WHERE country = CURRENT_SETTING('app.current_country'))
);
ALTER TABLE fait_listing FORCE ROW LEVEL SECURITY;

-- Attribution des rôles aux utilisateurs
-- Attribution du rôle admin
GRANT role_admin TO user_admin;

-- Attribution du rôle analyste
GRANT role_analyste TO user_analyst;

-- Attribution du rôle gestionnaire (ex. pour les utilisateurs en France)
GRANT role_gestionnaire TO user_gestion_fr;

-- Attribution du rôle service client
GRANT role_service_client TO user_service_client;

-- Journalisation des modifications pour les opérations sensibles
CREATE EXTENSION IF NOT EXISTS pgaudit;
SET pgaudit.log = 'write';

-- Limitations de l'usage des vues
REVOKE SELECT ON fait_listing FROM role_gestionnaire;
