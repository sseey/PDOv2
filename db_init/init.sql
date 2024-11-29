-- Créer la base de données si elle n'existe pas déjà
CREATE DATABASE IF NOT EXISTS my_database;

-- Utiliser la base de données
USE my_database;

-- Créer la table voitures_luxe
CREATE TABLE IF NOT EXISTS voitures_luxe (
    id INT AUTO_INCREMENT PRIMARY KEY,
    marque VARCHAR(50) NOT NULL,
    modele VARCHAR(50) NOT NULL,
    annee INT NOT NULL,
    prix DECIMAL(10, 2) NOT NULL
);

-- Insérer des données dans la table
INSERT INTO voitures_luxe (marque, modele, annee, prix)
VALUES
    ('Ferrari', '488 Spider', 2023, 280000.00),
    ('Lamborghini', 'Aventador', 2022, 350000.00),
    ('Bugatti', 'Chiron', 2021, 3000000.00),
    ('Porsche', '911 Carrera', 2023, 120000.00),
    ('McLaren', '720S', 2022, 310000.00);

-- Créer un utilisateur et lui accorder des privilèges
CREATE USER IF NOT EXISTS 'my_user'@'%' IDENTIFIED BY 'my_password';
GRANT ALL PRIVILEGES ON my_database.* TO 'my_user'@'%';
FLUSH PRIVILEGES;
