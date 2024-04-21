
-- Test pour role_admin

DO $$
BEGIN
    SET ROLE role_admin; 
    BEGIN
        SELECT * FROM dim_date;
        INSERT INTO dim_date(date_key) VALUES ('2024-01-01');
        UPDATE dim_date SET date_key = '2024-01-02' WHERE date_key = '2024-01-01';
        DELETE FROM dim_date WHERE date_key = '2024-01-02';
    ROLLBACK;
    END;  -- Close the transaction block

    RESET ROLE;
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Failed as admin: %', SQLERRM;
END $$;  -- Correctly close the DO block with END and the $$ delimiter followed by a semicolon


-- Test pour role_analyste 

DO $$
BEGIN
    -- Définir le paramètre de configuration pour la session actuelle
    SET app.current_country = 'USA'; -- Ajustez la valeur selon le besoin

    SET ROLE role_analyste;
    PERFORM * FROM dim_date;
    PERFORM * FROM dim_location;
    -- Refus de permission attendu
    BEGIN
        PERFORM * FROM dim_commodité;
    EXCEPTION WHEN insufficient_privilege THEN
        RAISE NOTICE 'Attendu : Accès refusé à dim_commodité pour role_analyste.';
    END;
    -- Requête qui dépend d'un paramètre de configuration personnalisé
    BEGIN
        PERFORM * FROM fait_listing;
    EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'Erreur lors de la requête sur fait_listing : %', SQLERRM;
    END;
    
    -- Tentative d'insertion qui devrait échouer
    BEGIN
        INSERT INTO dim_date(first_review) VALUES ('2024-01-03');
    EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'Insertion non autorisée en tant qu''analyste : %', SQLERRM;
    END;
    
    ROLLBACK;
    RESET ROLE;
END $$;


