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
crontad -e
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
on envoi ce tar sur gDrive
on supprime l'ensemble des fichiers temporaires
