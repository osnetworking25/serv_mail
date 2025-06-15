*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
Chapitre 3 : PostfixAdmin – Créer des boîtes aux lettres virtuelles sur le serveur de messagerie Ubuntu
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
----------------------------------------------------------------------
Étape 1 : Installer le serveur de base de données MariaDB/MySQL 
----------------------------------------------------------------------

mail:~# apt install mariadb-server mariadb-client
Version 10.6
systemctl status mariadb

mail:~# systemctl enable mariadb
Synchronizing state of mariadb.service with SysV service script with /lib/systemd/systemd-sysv-install.
Executing: /lib/systemd/systemd-sysv-install enable mariadb

----------------------------------------------------------------------
Étape 2 : Télécharger PostfixAdmin sur Ubuntu Server
----------------------------------------------------------------------

Vérifier la version
https://github.com/postfixadmin/postfixadmin/releases

mail:~# wget -P /opt/ https://github.com/postfixadmin/postfixadmin/archive/refs/tags/postfixadmin-3.3.15.tar.gz
mail:~# tar -xzvf /opt/postfixadmin-3.3.15.tar.gz -C /var/www/
mail:~# mv /var/www/postfixadmin-postfixadmin-3.3.15 /var/www/postfixadmin

----------------------------------------------------------------------
Étape 3 : Configuration des autorisations
----------------------------------------------------------------------

mail:~# mkdir -p /var/www/postfixadmin/templates_c
mail:~# apt install acl
mail:~# setfacl -R -m u:www-data:rwx /var/www/postfixadmin/templates_c/
mail:~# setfacl -R -m u:www-data:rx /etc/letsencrypt/live/ /etc/letsencrypt/archive/

Vérification des ACLs

mail:/var/www/postfixadmin# getfacl /var/www/postfixadmin/templates_c
getfacl: Removing leading '/' from absolute path names
# file: var/www/postfixadmin/templates_c
# owner: root
# group: root
user::rwx
user:www-data:rwx
group::r-x
mask::rwx
other::r-x

----------------------------------------------------------------------
Étape 4 : Créer une base de données et un utilisateur pour PostfixAdmin
----------------------------------------------------------------------

MariaDB [(none)]> create user 'userpostfixadmin'@'localhost' identified by 'pwdpostfixadmin';
Query OK, 0 rows affected (0,001 sec)

MariaDB [(none)]> create database postfixadmin;
Query OK, 1 row affected (0,002 sec)

MariaDB [(none)]> grant all privileges on postfixadmin.* to 'userpostfixadmin'@'localhost';
Query OK, 0 rows affected (0,001 sec)

MariaDB [(none)]> flush privileges;

Pour avoir accès à toutes les bases de données depuis DBEAVER 

 sudo nano /etc/mysql/mariadb.conf.d/50-server.cnf
#bind-address            = 127.0.0.1
bind-address = 0.0.0.0

 sudo systemctl restart mariadb

 ss -lnpt | grep 3306
LISTEN 0      80           0.0.0.0:3306      0.0.0.0:*    users:(("mariadbd",pid=790246,fd=17))     

-- Supprime l’utilisateur local s’il ne te sert plus :
DROP USER 'dbeaver'@'localhost';

-- Crée un nouvel utilisateur pour ton IP :
CREATE USER 'dbeaver'@'193.202.20.21' IDENTIFIED BY 'motdepassefort';
GRANT ALL PRIVILEGES ON *.* TO 'dbeaver'@'193.202.20.21';

Uutilisateur est bien autorisé
Se Connecte à MariaDB et exécute :

SELECT user, host FROM mysql.user WHERE user = 'dbeaver';

+---------+------------------+
| user    | host             |
+---------+------------------+
| dbeaver | 193.202.20.21    |
| dbeaver | 212.90.44.88     |
+---------+------------------+

----------------------------------------------------------------------
Étape 5 : Configurer PostfixAdmin
----------------------------------------------------------------------

cp /var/www/config.inc.php /var/www/config.local.php

<?php
$CONF['configured'] = true;
$CONF['database_type'] = 'mysqli';
$CONF['database_host'] = 'localhost';
$CONF['database_port'] = '3306';
$CONF['database_user'] = 'userpostfixadmin';
$CONF['database_password'] = 'pwdpostfixadmin';
$CONF['database_name'] = 'postfixadmin';
$CONF['encrypt'] = 'dovecot:ARGON2I';
$CONF['dovecotpw'] = "/usr/bin/doveadm pw -r 5";
if(@file_exists('/usr/bin/doveadm')) { // @ to silence openbase_dir stuff; see https://github.com/postfixadmin/postfixadmin/issues/171
    $CONF['dovecotpw'] = "/usr/bin/doveadm pw -r 5"; # debian
}

Vérification lister les schémas de mot de passe disponibles dans Dovecot

mail:/var/www/postfixadmin# sudo doveadm pw -l
SHA1 SSHA512 SCRAM-SHA-256 BLF-CRYPT PLAIN HMAC-MD5 OTP
SHA512 SHA DES-CRYPT CRYPT SSHA MD5-CRYPT PLAIN-MD4
PLAIN-MD5 SCRAM-SHA-1 SHA512-CRYPT CLEAR CLEARTEXT
ARGON2I ARGON2ID SSHA256 MD5 PBKDF2 SHA256 CRAM-MD5
PLAIN-TRUNC SHA256-CRYPT SMD5 DIGEST-MD5 LDAP-MD5



----------------------------------------------------------------------
Étape 6 : Créer un hôte virtuel Apache ou un fichier de configuration Nginx pour PostfixAdmin
----------------------------------------------------------------------

mail:~# nano /etc/apache2/sites-available/postfixadmin_domain.tld.conf

<VirtualHost *:80>
  ServerName postfixadmin.domain.tld
  DocumentRoot /var/www/postfixadmin/public

  ErrorLog ${APACHE_LOG_DIR}/postfixadmin_error.log
  CustomLog ${APACHE_LOG_DIR}/postfixadmin_access.log combined

  <Directory />
    Options FollowSymLinks
    AllowOverride All
  </Directory>

  <Directory /var/www/postfixadmin/>
    Options FollowSymLinks MultiViews
    AllowOverride All
    Order allow,deny
    allow from all
  </Directory>

</VirtualHost>

mail:/var/www/postfixadmin# a2ensite postfixadmin_domain.tld.conf

mail:/var/www/postfixadmin# systemctl reload apache2

----------------------------------------------------------------------
Étape 7 : Installer les modules PHP requis et recommandés
----------------------------------------------------------------------
mail:/var/www/postfixadmin# hostnamectl
 Static hostname: mail.domain.tld
       Icon name: computer-vm
         Chassis: vm
      Machine ID: 0f6a7ddf408d4e658fd575ae7b7379f0
         Boot ID: 5af0db3e5b5b4d248bf0a5dfcbeff98f
  Virtualization: vmware
Operating System: Ubuntu 22.04.5 LTS
          Kernel: Linux 5.15.0-139-generic
    Architecture: x86-64
 Hardware Vendor: VMware, Inc.
  Hardware Model: VMware Virtual Platform

Ubuntu 22.04

mail:/var/www/postfixadmin# apt install php8.1-fpm php8.1-imap php8.1-mbstring php8.1-mysql php8.1-curl php8.1-zip php8.1-xml php8.1-bz2 php8.1-intl php8.1-gmp php8.1-redis php8.1-pgsql php8.1-sqlite3

mail:/var/www/postfixadmin# apt install libapache2-mod-php

mail:/var/www/postfixadmin# systemctl restart apache2
----------------------------------------------------------------------
Étape 8 : Activation du protocole HTTPS
----------------------------------------------------------------------

Déjà fait
mail:/var/www/postfixadmin# apt install certbot
mail:/var/www/postfixadmin# apt install python3-certbot-apache

mail:/var/www/postfixadmin# certbot --apache --agree-tos --redirect --hsts --staple-ocsp --email letsencrypt@domain.tld -d postfixadmin.domain.tld
Saving debug log to /var/log/letsencrypt/letsencrypt.log
Requesting a certificate for postfixadmin.domain.tld

Successfully received certificate.
Certificate is saved at: /etc/letsencrypt/live/postfixadmin.domain.tld/fullchain.pem
Key is saved at:         /etc/letsencrypt/live/postfixadmin.domain.tld/privkey.pem
This certificate expires on 2025-08-31.
These files will be updated when the certificate renews.
Certbot has set up a scheduled task to automatically renew this certificate in the background.

Deploying certificate
Successfully deployed certificate for postfixadmin.domain.tld to /etc/apache2/sites-available/postfixadmin-le-ssl.conf
Congratulations! You have successfully enabled HTTPS on https://postfixadmin.domain.tld

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
If you like Certbot, please consider supporting our work by:
 * Donating to ISRG / Let's Encrypt:   https://letsencrypt.org/donate
 * Donating to EFF:                    https://eff.org/donate-le
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


----------------------------------------------------------------------
Étape 9 : Activer les statistiques dans Dovecot
----------------------------------------------------------------------

 nano /etc/dovecot/conf.d/10-master.conf

service stats {
    unix_listener stats-reader {
    user = www-data
    group = www-data
    mode = 0660
}

unix_listener stats-writer {
    user = www-data
    group = www-data
    mode = 0660
  }
}

 gpasswd -a www-data dovecot
Adding user www-data to group dovecot

 systemctl restart dovecot
 setfacl -R -m u:www-data:rwx /var/run/dovecot/stats-reader /var/run/dovecot/stats-writer

----------------------------------------------------------------------
Étape 10 : Terminer l’installation dans le navigateur Web
----------------------------------------------------------------------
Créer un mot de passe pour PostifixAdmin 2025 Generate setup_password: th7sAMkTvW6wh6

$CONF['setup_password'] = '$2y$10$VbVAbBQGwRklZm7fLVIPruA8spvNiPB9nrmt/zGtkT2p/JPfK1/tu';

Actualisez la page de configuration de PostfixAdmin
Saisissez à nouveau le mot de passe de configuration, puis créez le compte administrateur. 
----------------------------------------------------------------------
Étape 11 : Vérification des tables dans la base de données
----------------------------------------------------------------------

 mysql -u root
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 72
Server version: 10.6.21-MariaDB-0ubuntu0.22.04.2 Ubuntu 22.04

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [(none)]> USE postfixadmin;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
MariaDB [postfixadmin]> SHOW TABLES;
+----------------------------+
| Tables_in_postfixadmin |
+----------------------------+
| admin                      |
| alias                      |
| alias_domain               |
| config                     |
| domain                     |
| domain_admins              |
| fetchmail                  |
| log                        |
| mailbox                    |
| quota                      |
| quota2                     |
| vacation                   |
| vacation_notification      |
+----------------------------+
13 rows in set (0,001 sec)

MariaDB [postfixadmin]> DESCRIBE domain;
+-----------------+--------------+------+-----+---------------------+-------+
| Field           | Type         | Null | Key | Default             | Extra |
+-----------------+--------------+------+-----+---------------------+-------+
| domain          | varchar(255) | NO   | PRI | NULL                |       |
| description     | varchar(255) | NO   |     | NULL                |       |
| aliases         | int(10)      | NO   |     | 0                   |       |
| mailboxes       | int(10)      | NO   |     | 0                   |       |
| maxquota        | bigint(20)   | NO   |     | 0                   |       |
| quota           | bigint(20)   | NO   |     | 0                   |       |
| transport       | varchar(255) | NO   |     | NULL                |       |
| backupmx        | tinyint(1)   | NO   |     | 0                   |       |
| created         | datetime     | NO   |     | 2000-01-01 00:00:00 |       |
| modified        | datetime     | NO   |     | 2000-01-01 00:00:00 |       |
| active          | tinyint(1)   | NO   |     | 1                   |       |
| password_expiry | int(11)      | YES  |     | 0                   |       |
+-----------------+--------------+------+-----+---------------------+-------+
12 rows in set (0,001 sec)

MariaDB [postfixadmin]> exit;
Bye

-----------------------------------------------------------------------------
Étape 12 : Configurer Postfix pour utiliser la base de données MySQL/MariaDB
-----------------------------------------------------------------------------

 apt install postfix-mysql

Voir documentation dans /var/www/postfixadmin/DOCUMENTS/POSTFIX_CONF.txt
insérer dans le fichier /etc/postfix/main.cf à la fin du fichier :

J'ai créé un script qui regroupe toutes les Étape 12.
   
Voici le fichier README.txt pour comprendre

Les fichier sont dans /opt/postixadmin-scripts/
Utilisons le 1er script /opt/postixadmin-scripts/postfix_conf.sh

Faisons les vérifications expliqué dans README.txt

Les fichier sont dans /opt/postixadmin-scripts/
Utilisons le 2ème script /opt/postixadmin-scripts/prepare_vmail.sh
Faisons les vérifications expliqué dans README.txt
----------------------------------------------------------------------------
Étape 13 : Configurer Dovecot pour utiliser la base de données MySQL/MariaDB
----------------------------------------------------------------------------
 apt install dovecot-mysql
 nano /etc/dovecot/conf.d/10-mail.conf
mail_home = /var/vmail/%d/%n/

 nano /etc/dovecot/conf.d/10-auth.conf
#auth_username_format = %n
auth_username_format = %u

mail:/opt/postfixadmin-scripts# grep -E '^[^#]*username_format' /etc/dovecot/conf.d/10-auth.conf
auth_username_format = %u


auth_default_realm = domain.tld
!include auth-sql.conf.ext
#!include auth-system.conf.ext
auth_debug = yes
auth_debug_passwords = yes

Mettre à la fin du fichier
 nano /etc/dovecot/dovecot-sql.conf.ext

driver = mysql
connect = host=localhost dbname=postfixadmin user=postfixadmin password=password

default_pass_scheme = ARGON2I

password_query = SELECT username AS user,password FROM mailbox WHERE username = '%u' AND active='1'

user_query = SELECT maildir, 2000 AS uid, 2000 AS gid FROM mailbox WHERE username = '%u' AND active='1'

iterate_query = SELECT username AS user FROM mailbox

 sudo systemctl restart dovecot

--------------------------------------------------------------------------
Étape 14 : Ajouter un domaine et des boîtes aux lettres dans PostfixAdmin
--------------------------------------------------------------------------
Connectez-vous à l'interface web de PostfixAdmin en tant qu'administrateur.
Cliquez sur l' Domain Listonglet et choisissez New Domaind'ajouter un domaine.
Vous pouvez choisir le nombre d'alias et de boîtes aux lettres autorisés pour ce domaine.

Cliquez ensuite sur Virtual Listl’onglet et sélectionnez Add Mailbox pour ajouter une nouvelle adresse 
e-mail pour votre domaine.


Pour vérifier dans la base de données
 mysql -u root
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 109
Server version: 10.6.21-MariaDB-0ubuntu0.22.04.2 Ubuntu 22.04

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.


MariaDB [(none)]> use postfixadmin;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
MariaDB [postfixadmin]> select * from domain;
+------------------+----------------------------------+---------+-----------+----------+-------+-----------+----------+---------------------+---------------------+--------+-----------------+
| domain           | description                      | aliases | mailboxes | maxquota | quota | transport | backupmx | created             | modified            | active | password_expiry |
+------------------+----------------------------------+---------+-----------+----------+-------+-----------+----------+---------------------+---------------------+--------+-----------------+
| ALL              |                                  |       0 |         0 |        0 |     0 |           |        0 | 2025-05-08 11:12:14 | 2025-05-08 11:12:14 |      1 |               0 |
| domain.tld | Serveur de mail domain.tld |      10 |        10 |       10 |  2048 | virtual   |        0 | 2025-05-08 13:26:40 | 2025-05-08 13:26:40 |      1 |             365 |
+------------------+----------------------------------+---------+-----------+----------+-------+-----------+----------+---------------------+---------------------+--------+-----------------+
2 rows in set (0,001 sec)

Test de la messagerie sur outlook

dig mail.domain.tld +short
host mail.domain.tld
ping mail.domain.tld
dig A mail.domain.tld +short
dig MX domain.tld +short
openssl s_client -starttls smtp -connect mail.domain.tld:587 -crlf
openssl s_client -connect mail.domain.tld:993


Création d'un script de sauvegarde