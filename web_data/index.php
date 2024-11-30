<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liste des voitures de luxe</title>
    <style>
        body, html {
            margin: 0;
            padding: 0;
            height: 100%;
            width: 100%;
            font-family: Arial, sans-serif;
            background: url('background-image.jpg') no-repeat center center fixed;
            background-size: cover;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            color: #fff;
            text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.8);
        }

        h1 {
            text-align: center;
            margin-bottom: 30px;
            color: #4CAF50;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.6);
        }

        table {
            border-collapse: collapse;
            width: 80%;
            background: rgba(255, 255, 255, 0.9);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            border-radius: 10px;
            overflow: hidden;
        }

        th, td {
            padding: 12px;
            text-align: left;
        }

        th {
            background: #4CAF50;
            color: white;
        }

        tr:nth-child(even) {
            background: #f2f2f2;
        }

        tr:hover {
            background: #ddd;
        }
    </style>
</head>
<body>
    <h1>Liste des voitures de luxe</h1>

    <?php
    // Informations de connexion à la base de données
    $servername = "mysql_database";
    $username = "my_user";
    $password = trim(file_get_contents("/run/secrets/db_user_password"));
    $dbname = "my_database";

    // Connexion à la base de données
    $conn = new mysqli($servername, $username, $password, $dbname);

    // Vérifier la connexion
    if ($conn->connect_error) {
        die("<p>Erreur de connexion : " . $conn->connect_error . "</p>");
    }

    // Requête SQL pour récupérer les données
    $sql = "SELECT marque, modele, annee, prix FROM voitures_luxe";
    $result = $conn->query($sql);

    // Générer le tableau
    if ($result && $result->num_rows > 0) {
        echo "<table>";
        echo "<tr><th>Marque</th><th>Modèle</th><th>Année</th><th>Prix (€)</th></tr>";

        while ($row = $result->fetch_assoc()) {
            echo "<tr>";
            echo "<td>" . htmlspecialchars($row['marque']) . "</td>";
            echo "<td>" . htmlspecialchars($row['modele']) . "</td>";
            echo "<td>" . htmlspecialchars($row['annee']) . "</td>";
            echo "<td>" . htmlspecialchars(number_format($row['prix'], 2, ',', ' ')) . " €</td>";
            echo "</tr>";
        }

        echo "</table>";
    } else {
        echo "<p>Aucune voiture trouvée dans la base de données.</p>";
    }

    // Fermer la connexion
    $conn->close();
    ?>
</body>
</html>
