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
1- Sur Gmail dans la partie configuration: autoriser la configuration aux applications moins sécurisées
2- Désactiver les captcha: https://accounts.google.com/DisplayUnlockCaptcha


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


