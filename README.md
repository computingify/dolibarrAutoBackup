# Installer automysqlbackup
sudo apt install automysqlbackup
### configurer automysqlbackup
sudo nano /etc/default/automysqlbackup
voir dans le fichier de conf.php pour avoir les informations sur la base de donnée

# Lancer automysqlbackup
sudo automysqlbackup

#Voir ce qui été sauvegarde par automysqlbackup
sudo ls -lhart /var/lib/automysqlbackup/daily
# Utiliser le script de sauvegarde
Prendre le script de autoSave.sh qui se trouve sous git
### Rendre le script executable
chmod +x autosave.sh

# Ajouter dans cron
crontab -e
## Run dolibarr backup every monday a 1:00am
0 1 * * * ~/dolibarrAutosave/autoSave.sh
## Avoir un retour de la tache cron:
 nano /etc/rsyslog.conf
 décommanter la ligne #cron.*     /var/log/cron.log
 ### restart cron
 sudo service rsyslog restart
 ### Les log se trouvent ici:
 more /var/mail/pi

# Fonctionnement
on realise une extraction de la base de donnee
on prend les differents dossier dolibarr a sauvegarder et on en fait une copy dans le repertoire du scrip
on creer un targz du tout
on nomme ce tar en ajoutant le numero de la semaine a la fin, de cette maniere nois avons un fichier de backup par jour (celui ci est ecrase a la prochaine sauvegarde du meme jour)

# Decrypter et Extraire l'archive
mkdir ext | openssl enc -aes-256-cbc -md sha512 -pbkdf2 -iter 100000 -salt -d -in dolibarrBackup1.tar.gz.enc | tar xz -C ext

# Paramétrage de l'envoie d'email
## Partie Dolibarr
Dans Configuration => Emails
Paramètre
Désactiver globalement tout envoi d'emails (pour mode test ou démos)	Non
Envoyer tous les emails à (au lieu des vrais destinataires, à des fins de test)	

Méthode d'envoi d'email	
Méthode d'envoi d'email	SMTP/SMTPS socket library
Nom d'hôte ou adresse IP du serveur SMTP/SMTPS (Par défaut dans php.ini: localhost)	smtp.gmail.com
Nom d'hôte ou adresse IP du serveur SMTP/SMTPS (Par défaut dans php.ini: 25)	465
ID SMTP (si le serveur d'envoi nécessite une authentification)	computingify.auto@gmail.com
Mot de passe SMTP (si le serveur d'envoi nécessite une authentification)	*********
Utilisation du chiffrement TLS (SSL)	Oui
Utiliser le cryptage TTS (STARTTLS)	Non
Autoriser les certificats auto-signés	Non

## Partie Gmail
Comme Dolibarr ne prend pas en charge la connexion avec google via l'autentification sur la page de google, il faut créer un mot de passe dédié à notre Dolibarr
Se rendre sur la page de configuration de sécurité de notre compte google: https://myaccount.google.com
1- Activé la double authentification pour le compte
2- Générer un mot de passe pour l'application Dolibarr
3- Prend le mot de passe généré par google et le mettre en lieu et place du mot de passe de connexion au serveur smtp dans dolibarr
Plus dinformation sur la page d'aide de google: https://support.google.com/mail/answer/185833?hl=fr

Config du serveur mail dans dolibarr:
Méthode d'envoi d'email:	SMTP/SMTPS socket library
Nom d'hôte ou adresse IP du serveur SMTP/SMTPS (Par défaut dans php.ini: localhost):	smtp.gmail.com
Nom d'hôte ou adresse IP du serveur SMTP/SMTPS (Par défaut dans php.ini: 25):	465
ID SMTP (si le serveur d'envoi nécessite une authentification): Adresse mail de notre compte google
Mot de passe SMTP (si le serveur d'envoi nécessite une authentification): le mot de passe généré par google
Utilisation du chiffrement TLS (SSL):	Oui

# Synchro avec nextcloud
## Installation de nextCloud client sur raspibarr
    Ajout du dépôt pour le nextcloud-client :

    echo "deb https://m4lvin.github.io/nextcloud-client-debian-packaging/ /" > /etc/apt/sources.list.d/nextcloud-client-m4lvin.list

    Téléchargement de la clé :

    gpg --keyserver pgpkeys.mit.edu --recv-key 51B6417AB18303DE

    Ajout de la clé :

    gpg -a --export 51B6417AB18303DE | sudo apt-key add -

    Mise à jour :

    apt update

    Installer le paquet nextcloud-client :

    apt install nextcloud-client
## Ajouter dans le script un truc comme:
synchro vers nextcloud
nextcloudcmd "$backupdir" https://User_Nextcloud:MDP_User_Nextcloud@nextcloud.domaine.tld/remote.php/webdav/

## Connection avec des serveur de backup (nextcloud)
utilisation de rclone
Pour en configurer ou modifier un:
```shell
rclone config
```
Dans la config il faut mettre l'adresse suivante pour le nextcloud: https://192.168.0.50:443/remote.php/dav/files/Computingify
Lister les different remote dispo
```shell
rclone listremotes
```
# Installation de GTest sur RPi

## Installer gcc et g++
sudo apt install gcc
sudo apt install g++

## Installer GTest
sudo apt install libgtest-dev

## Installation de cmake
sudo apt install cmake

## Contruction de GTest
cd /usr/src/gtest
sudo cmake CMakeLists.txt
sudo make

## création d'uun lien symbolic pour l'utilisation
sudo cp lib/*.a /usr/lib

# Installation de dolibarr

## Installation de dolibarr
Depuis un docker tout près
Create docker-compose.yml file as following:
```shell
version: '3'

volumes:
  dolibarr_html:
  dolibarr_docs:
  dolibarr_db:

services:

  mariadb:
    image: mariadb:latest
    restart: always
    command: --character_set_client=utf8 --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci
    volumes:
      - dolibarr_db:/var/lib/mysql
    environment:
        - "MYSQL_DATABASE=dolibarr"
        - "MYSQL_USER=dolibarr"
        - "MYSQL_PASSWORD=dolibarr"
        - "MYSQL_RANDOM_ROOT_PASSWORD=yes"

  dolibarr:
    image: upshift/dolibarr:latest
    restart: always
    depends_on:
        - mariadb
    ports:
        - "8080:80"
    environment:
        - "DOLI_DB_HOST=mariadb"
        - "DOLI_DB_NAME=dolibarr"
        - "DOLI_DB_USER=dolibarr"
        - "DOLI_DB_PASSWORD=dolibarr"
    volumes:
        - dolibarr_html:/var/www/html
        - dolibarr_docs:/var/www/documents
```
Then run all services docker-compose up -d. Now, go to http://localhost:8080 to access the new Dolibarr installation wizard.
DOLI_ADMIN_LOGIN
Default value: admin
DOLI_ADMIN_PASSWORD
Default value: dolibarr

info sur https://github.com/upshift-docker/dolibarr


## Latest installation for Ced

This installation is made on ARM64 proco, it's installed on Freebox VM based on debian

### MariaDB installation
A simple package installation
```shell
sudo apt install mariadb-server -y
```

### MariaDB Data Base config
Log to mysql with root user
```shell
sudo mysql -u root -p
```
or
```shell
sudo mysql
```

Create data base
```shell
create database dolibarrdebian;
```

Create User and grant the access
```shell
grant all privileges on dolibarrdebian.* TO dolibarrdebian@'localhost' identified by 'YOUR_DB_PWD';
```
Exchange YOUR_DB_PWD by your password (remender this password because you need it at dolibarr config)

Apply MariaDb modification
```shell
flush privileges;
```

### Dolibarr installation
Get installation package
```shell
wget https://downloads.sourceforge.net/project/dolibarr/Dolibarr%20installer%20for%20Debian-Ubuntu%20%28DoliDeb%29/18.0.0/dolibarr_18.0.0-4_all.deb
```
Exchange the 18.0.0 version by yours

Dolibarr installation
```shell
sudo dpkg -i dolibarr_18.0.0-4_all.deb
```

In case of installation error (due to missing dependancies)
```shell
sudo apt install -f
```

### Dolibarr config
Go to your dolibarr IP address /dolibarr/install

In configuration page, DO NOT select:
- data base creation
- user creation

Find the data base password access by those one set at data base user creation
