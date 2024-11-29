#!/bin/bash

# Supprimer le fichier index.html par défaut
if [ -f /var/www/html/index.html ]; then
    echo "Suppression de /var/www/html/index.html"
    rm /var/www/html/index.html
fi

# Lancer Apache en mode premier plan
exec apache2ctl -D FOREGROUND
