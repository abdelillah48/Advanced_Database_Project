# Entrepôt de Données pour les Annonces Airbnb 

## Description
Ce projet a été réalisé dans le cadre d'un cours avancé en bases de données. L'objectif était de créer un entrepôt de données dédié aux annonces Airbnb, en utilisant PostgreSQL et Python pour le stockage et l'analyse des données. Ce système permet aux utilisateurs d'accéder à des informations détaillées sur les tendances des annonces Airbnb.

## Fonctionnalités
- Stockage des données sur les annonces Airbnb dans une base PostgreSQL.
- Contrôle d'accès pour sécuriser et gérer les permissions des utilisateurs.
- Visualisations des tendances des annonces pour faciliter l'interprétation des données.

## Description des fichiers
- **nettoyage_donnees.ipynb :** Ce notebook Jupyter contient du code Python pour nettoyer et préparer les données des annonces.
- **controle_acces.sql :** Ce script SQL configure la politique de sécurité de la base de données en définissant les rôles et les permissions pour différents types d'utilisateurs.
- **requetes.sql :** Ce script SQL contient les requêtes SQL principales pour le projet d'analyse des annonces Airbnb.
- **insertion_donnee.py :** Ce script Python se connecte à la base de données PostgreSQL et y insère les données des annonces.
- **create_table.sql :** Ce script SQL crée les tables de la base de données pour stocker les données des annonces.
- **test.sql :** Ce notebook Jupyter contient une series d'opérations pour tester les permissions de certains rôles
## Licence
 Ces données sont fournies par Inside Airbnb et sont disponibles sous la licence CC 0 1.0.
