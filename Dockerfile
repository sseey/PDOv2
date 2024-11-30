# Étape 1 : Construire l'environnement de base
FROM debian:latest AS build-stage

# Mettre à jour les paquets et installer les outils nécessaires
RUN apt-get update && \
    apt-get install -y \
    apache2 \
    libapache2-mod-php8.2 \
    php8.2 \
    php8.2-mysqli \
    nano \
    iputils-ping \
    curl \
    mime-support && \
    apt-get clean

# Copier les fichiers de la page web dans le répertoire approprié
COPY /web_data/index.php /var/www/html/
COPY /web_data/background-image.jpg /var/www/html/

# Copier le script d'entrée
COPY entrypoint.sh /entrypoint.sh

# Configurer le fichier Apache pour éviter les erreurs de "ServerName"
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Activer les modules nécessaires pour Apache
RUN a2enmod php8.2

# Étape 2 : Créer l'image finale
FROM debian:latest AS final-stage

# Installer les dépendances nécessaires dans l'image finale
RUN apt-get update && \
    apt-get install -y \
    apache2 \
    libapache2-mod-php8.2 \
    php8.2 \
    php8.2-mysqli \
    nano \
    curl \
    mime-support && \
    apt-get clean

# Copier les fichiers nécessaires depuis l'étape de construction
COPY --from=build-stage /etc/apache2 /etc/apache2
COPY --from=build-stage /var/www/html /var/www/html
COPY --from=build-stage /usr/sbin/apache2ctl /usr/sbin/apache2ctl
COPY --from=build-stage /usr/sbin/apache2 /usr/sbin/apache2
COPY --from=build-stage /usr/lib/apache2 /usr/lib/apache2
COPY --from=build-stage /usr/lib/php /usr/lib/php
COPY --from=build-stage /etc/php /etc/php

# Copier le script d'entrée
COPY --from=build-stage /entrypoint.sh /entrypoint.sh

# Rendre le script exécutable
RUN chmod +x /entrypoint.sh

# Configurer le fichier Apache pour éviter les erreurs de "ServerName"
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Ajouter la directive FilesMatch au fichier apache2.conf
RUN echo '<FilesMatch "\\.php$">\n    SetHandler application/x-httpd-php\n</FilesMatch>' >> /etc/apache2/apache2.conf

# Exposer le port 80 pour le serveur web
EXPOSE 80

# Définir le script d'entrée
ENTRYPOINT ["/entrypoint.sh"]

HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
  CMD curl -f http://localhost/ || exit 1

# Lancer Apache en mode premier plan pour maintenir le conteneur actif
CMD ["apache2ctl", "-D", "FOREGROUND"]
