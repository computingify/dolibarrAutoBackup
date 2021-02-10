#installer automysqlbackup
sudo apt install automysqlbackup
// configurer automysqlbackup
sudo nano /etc/default/automysqlbackup
// voir dans le fichier de conf.php pour avoir les informations sur la base de donnée

#lancer automysqlbackup
sudo automysqlbackup

#Voir ce qui été sauvegarde par automysqlbackup
sudo ls -lhart /var/lib/automysqlbackup/daily

#Rendre le script executable
chmod +x autosave.sh

# Ajouter dans cron
crontad -e
## Run dolibarr backup every monday a 1:00am
0 1 * * * ~/dolibarrAutosave/autoSave.sh
## Avoir un retour de la tache cron:
 nano /etc/rsyslog.conf
 ### décommanter la ligne #cron.*     /var/log/cron.log
 // restart cron
 sudo service rsyslog restart
 ### Les log se trouvent ici:
 more /var/mail/pi
