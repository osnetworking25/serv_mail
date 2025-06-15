
# 📘 Guide complet – Serveur mail avec Postfix, Dovecote, Mysql et Roundcube

## 🧭 À qui s’adresse ce guide ?

Ce guide est pensé pour un large public, du débutant complet à l’administrateur système confirmé. Il peut être utilisé pour apprendre, pour documenter une configuration d’entreprise, ou pour transmettre un savoir-faire professionnel. Chaque étape est expliquée en détail, sans jargon inutile, avec des commentaires pratiques et des recommandations applicables en environnement réel.

---

## 🎯 Objectif global du Chapitre 1

Mettre en place une base Ubuntu propre, sécurisée et prête à envoyer des e-mails sortants via SMTP en utilisant le serveur Postfix. Ce chapitre ne couvre pas la réception des e-mails (qui sera traitée dans le Chapitre 2).

---

Sommaire

##Chapitre 1 – Préparation de la base Ubuntu

	- Étape 1 – Mettre à jour complètement le système
	- Étape 2 – Définir le nom d’hôte (hostname)
	- Étape 3 – Ajouter ce nom dans le fichier /etc/hosts
	- Étape 4 – Définir le fuseau horaire du serveur
	- Étape 5 – Régénérer les locales du système
	- Étape 6 – Vérifier la connectivité Internet
	- Étape 7 – Installer le serveur SSH
	- Étape 8 – Sécuriser l’accès SSH
	- Étape 9 – Activer le pare-feu UFW
	- Étape 10 – Vérifier le statut du pare-feu

## Chapitre 2 – Installation de Postfix (serveur SMTP)
	- Étape 1 – Installer Postfix et les utilitaires mail
	- Étape 2 – Vérifier que Postfix est actif et fonctionne
	- Étape 3 – Vérifier l’écoute sur le port 25 (SMTP)
	- Étape 4 – Ouvrir le port 25 dans UFW (si actif)
	- Étape 5 – Tester la sortie SMTP vers Internet (Gmail)
	- Étape 6 – Envoyer un mail de test simple
	- Étape 7 – Vérifier que le message a été envoyé
	- Étape 8 – Vérifier la boîte locale (utilisateur root)
	- Étape 9 – Configurer les alias postmaster: et root:
	- Étape 10 – Redémarrer Postfix pour prendre en compte les changements

##📈 Partie 1 – Préparation de la base Ubuntu

	# 🧱 Étape 1 – Mise à jour complète du système Ubuntu

Avant d’installer un logiciel ou d’ouvrir votre serveur au réseau, il est fondamental de commencer par mettre à jour le système. Cela permet de bénéficier des derniers correctifs de sécurité, des améliorations de performance, et d’assurer une compatibilité parfaite avec les paquets que vous allez installer ensuite comme Postfix ou Dovecot.

Ubuntu utilise apt, son gestionnaire de paquets, pour effectuer ces mises à jour. La commande suivante est composée de trois parties :

apt update : récupère les dernières informations des dépôts en ligne.

apt upgrade -y : installe toutes les mises à jour disponibles automatiquement.

apt autoremove --purge -y : nettoie les paquets devenus inutiles (anciens noyaux, dépendances orphelines, etc.)

Cette étape est indispensable sur un serveur neuf. Elle est rapide et sans danger, surtout si vous venez de terminer l’installation d’Ubuntu.

```bash
apt update && apt upgrade -y && apt autoremove --purge -y
```

---

	# 🧱 Étape 2 – Définir le nom d’hôte (hostname)

Le nom d’hôte est ce que le système va utiliser pour s’identifier lui-même. C’est aussi ce que Postfix affichera dans les en-têtes de courriel, ce que les journaux système retiendront, et ce que vous verrez sur votre terminal. Il est fortement recommandé d’utiliser un **FQDN** (Fully Qualified Domain Name) comme `mail.domain.tld` pour assurer une cohérence avec vos enregistrements DNS et reverse DNS.

Ce nom d’hôte doit être défini avec la commande `hostnamectl`, qui met à jour à la fois le fichier `/etc/hostname` et la configuration en mémoire. Ne modifiez pas ce fichier à la main. Cette commande est fiable, propre, et persistante au redémarrage.

Ne pas définir correctement le nom d’hôte peut provoquer des messages d’erreur dans Postfix comme `myhostname is not a fully qualified domain name`. Cela peut aussi poser problème si le serveur ne peut pas résoudre son propre nom, ce qui perturbe l’envoi de mails.

```bash
hostnamectl set-hostname mail.domain.tld
```

---

	# 🧱 Étape 3 – Ajouter l’entrée locale dans /etc/hosts

Même si vous utilisez un DNS externe pour votre domaine, le système Ubuntu doit pouvoir résoudre son propre nom localement. C’est une sécurité et une bonne pratique. Sans cette ligne, vous risquez des erreurs lors du démarrage de certains services comme Postfix ou Dovecot, ou des lenteurs lors des connexions réseau internes.

Le fichier `/etc/hosts` agit comme un mini-DNS local : c’est la première chose que le système consulte pour résoudre un nom. Ajouter `127.0.1.1 mail.domain.tld` permet à la machine de s’identifier rapidement, même sans connexion Internet. Cela évite aussi les erreurs de type "unable to lookup my own hostname".

Utilisez un éditeur comme `nano` ou `vim` pour modifier ce fichier. Vérifiez qu’il contient bien ces deux lignes :

```bash
nano /etc/hosts
```
Et ajoutez/modifiez les lignes suivantes :
```bash
127.0.0.1 localhost
127.0.1.1 mail.domain.tld
```

	# Étape 4 – Définir le fuseau horaire du serveur

Définir un fuseau horaire correct est indispensable pour garantir la cohérence horaire dans tous les journaux système, les horodatages de mails, les tâches cron, et la gestion des certificats SSL. Sur un serveur hébergé en France ou destiné à des utilisateurs francophones, on utilisera généralement Europe/Paris.

L’outil timedatectl permet de configurer le fuseau horaire facilement. Il applique immédiatement les changements, et ils sont persistants au redémarrage. Il est possible de voir la liste complète des fuseaux horaires disponibles avec :
```bash
timedatectl list-timezones | grep Europe
```

Une fois que vous avez identifié celui qui vous convient (dans la majorité des cas Europe/Paris), utilisez :

```bash
timedatectl set-timezone Europe/Paris
```
Vous pouvez ensuite vérifier que l’heure est correcte avec :

```bash
timedatectl status
```
L’heure affichée doit correspondre à l’heure locale de votre région, ce qui est primordial pour les logs, les envois d’e-mails et toute tâche planifiée.

	# Étape 5 – Configurer la langue et l’encodage (locales)

Configurer les locales permet d’assurer une bonne prise en charge des accents, des caractères spéciaux et d’avoir des messages système dans la langue de votre choix. Cela est aussi important pour l’affichage correct des logs, des mails système, ou lors de l’installation de logiciels. En France ou pour une interface francophone, on utilise fr_FR.UTF-8, qui garantit un encodage universel.

Générez la locale avec :

```bash
locale-gen fr_FR.UTF-8
```

Puis relancez le système de configuration des locales :

```bash
dpkg-reconfigure locales
```

Choisissez fr_FR.UTF-8 comme valeur par défaut. Le système utilisera alors ce format pour tout ce qui est date, heure, tri alphabétique, affichage des messages.

	# Étape 6 – Vérifier la connexion Internet et le DNS

Avant d’aller plus loin, il est indispensable de vérifier que votre serveur est connecté à Internet et qu’il est capable de résoudre les noms de domaine. Sans cela, vous ne pourrez ni installer de paquets, ni envoyer de mails.

Pour tester la connectivité réseau :

```bash
ping -c 3 1.1.1.1
```

Si vous avez une réponse, la connexion est active. Puis vérifiez la résolution DNS :

```bash
dig google.fr +short
```
Vous devez obtenir une ou plusieurs adresses IP. Si ce n’est pas le cas, il faudra revoir la configuration réseau (IP statique, DNS, etc.).

	# Étape 7 – Installer le serveur SSH

Le service SSH (Secure Shell) est indispensable pour administrer votre serveur à distance. Il permet de vous connecter en toute sécurité via un terminal. La majorité des hébergements Ubuntu le proposent préinstallé, mais si ce n’est pas le cas, installez-le avec :

```bash
apt install openssh-server -y
```

Une fois installé, SSH démarre automatiquement. Vérifiez qu’il est actif avec :

```bash
systemctl status ssh
```

Vous pouvez maintenant accéder à votre serveur depuis un autre ordinateur avec :

```bash
ssh utilisateur@ip -p 22
```

	# Étape 8 – Modifier le port SSH pour plus de sécurité

Par défaut, SSH utilise le port 22. Ce port est bien connu et souvent scanné par les robots malveillants. Pour renforcer la sécurité, il est recommandé d’utiliser un port personnalisé comme 10523.

Éditez la configuration SSH :

```bash
nano /etc/ssh/sshd_config
```

Remplacez :

#Port 22

par :

Port 10523

Enregistrez et quittez. Pensez à ouvrir ce port dans UFW avant de redémarrer SSH pour ne pas vous bloquer.

```bash
ufw allow 10523/tcp
systemctl restart ssh
```

Vous devrez désormais vous connecter avec :

```bash
ssh utilisateur@ip -p 10523
```

	# Étape 9 – Interdire l’accès SSH en root (bonne pratique)

Par sécurité, il est fortement déconseillé de permettre une connexion directe du compte root par SSH. À la place, on se connecte avec un utilisateur normal, puis on élève les privilèges avec sudo.

Dans /etc/ssh/sshd_config, assurez-vous que la ligne suivante existe :

PermitRootLogin no

Cela empêche toute connexion directe de root à distance. Redémarrez ensuite le service :

```bash
systemctl restart ssh
```

	# Étape 10 – Activer le pare-feu et n’autoriser que ce qui est nécessaire

Ubuntu fournit un pare-feu intégré nommé UFW (Uncomplicated Firewall). Il est simple à utiliser et efficace. Il est conseillé de le configurer très tôt dans le processus pour n’ouvrir que les ports nécessaires.

Activez UFW et ouvrez les ports SSH et futurs ports mail (à adapter plus tard) :

```bash
ufw allow 10523/tcp
ufw allow 25/tcp
ufw allow 587/tcp
ufw allow 465/tcp
ufw enable
```

Vérifiez la configuration :

```bash
ufw status verbose
```
Cela vous montrera quels ports sont autorisés et depuis quelles adresses. Il est conseillé de n’autoriser que le strict nécessaire.

## 📬 Partie 2 – Installation de Postfix (serveur SMTP)

	# Étape 1 – Installer Postfix et les utilitaires mail

Postfix est un serveur de messagerie SMTP (Simple Mail Transfer Protocol) réputé pour sa fiabilité, sa rapidité et sa sécurité. Il permet à votre serveur d'envoyer des e-mails sortants vers d'autres serveurs. Pour pouvoir tester l'envoi de mails facilement, on installe aussi le paquet mailutils qui fournit la commande mail.

L'installation se fait depuis les dépôts Ubuntu, et le mode de configuration proposé par défaut vous permet de définir votre domaine.

```bash
apt install postfix mailutils -y
```

Pendant l’installation, sélectionnez le type Site Internet. Quand il vous demande un nom de domaine, saisissez domain.tld (ou le vôtre, par exemple osnetworking.com).

	# Étape 2 – Vérifier que Postfix est actif et fonctionne

Après l’installation, Postfix doit être automatiquement activé et lancé. Vérifiez cela avec :

```bash
systemctl status postfix
```

Vous pouvez également vérifier la version installée :

```bash
postconf mail_version
```

Cela vous indiquera par exemple mail_version = 3.6.4, ce qui confirme que Postfix est bien en place.

	# Étape 3 – Vérifier l’écoute sur le port 25 (SMTP)

Le port 25 est celui utilisé pour envoyer les e-mails entre serveurs. Votre Postfix doit impérativement l’écouter en entrée pour pouvoir fonctionner correctement.

Utilisez la commande suivante :

```bash
ss -lnpt | grep :25
```

Vous devez voir une ligne indiquant que le service master de Postfix est à l’écoute sur 0.0.0.0:25 (ou ::: pour IPv6).

	# Étape 4 – Ouvrir le port 25 dans UFW (si actif)

Si votre pare-feu UFW est activé, vous devez explicitement autoriser les connexions entrantes sur le port 25 (SMTP). Sinon, aucun mail ne pourra être envoyé ou accepté.

```bash
ufw allow 25/tcp
```

Vérifiez que la règle est bien appliquée :

```bash
ufw status numbered
```

	# Étape 5 – Tester la sortie SMTP vers Internet (Gmail)

Même si Postfix fonctionne localement, il est fréquent que des hébergeurs (OVH, Scaleway, Oracle…) bloquent le port 25 en sortie pour éviter le spam. Vérifiez donc que votre serveur peut contacter un serveur SMTP distant, comme celui de Gmail :

```bash
telnet gmail-smtp-in.l.google.com 25

Vous devez obtenir une réponse comme :

220 mx.google.com ESMTP...
```
Tapez QUIT pour fermer la session :

```bash
QUIT
```

Si la commande reste bloquée ou échoue, votre port 25 sortant est probablement bloqué. Il faudra demander son ouverture à votre hébergeur.

	# Étape 6 – Envoyer un mail de test simple

Pour tester l’envoi d’un e-mail, vous pouvez utiliser la commande sendmail qui est fournie avec Postfix. Cette commande envoie un message en texte brut à une adresse externe pour vérifier le bon fonctionnement du SMTP sortant.

```bash
echo "Test SMTP depuis Postfix" | sendmail adresse@email.com
```

Vous pouvez aussi utiliser la commande mail (fournie par mailutils) pour envoyer un message avec un objet :

```bash
mail -s "Sujet du test" destinataire@email.com
```

Tapez ensuite le corps du message, puis validez avec Entrée, et terminez par Ctrl + D pour envoyer.

	# Étape 7 – Vérifier que le message a été envoyé

Consultez les logs de Postfix pour confirmer que le message est bien parti :

```bash
tail -f /var/log/mail.log
```

Vous devriez voir une ligne indiquant status=sent si tout s’est bien passé.

	# Étape 8 – Vérifier la boîte locale (utilisateur root)

Par défaut, les messages destinés à root ou générés localement peuvent être stockés dans /var/mail/root ou /var/spool/mail/root. Vérifiez ce dossier :

```bash
ls -l /var/mail/
```

Puis utilisez la commande suivante pour lire le message :

```bash
mail
```

	# Étape 9 – Configurer les alias postmaster: et root:

Modifier le fichier /etc/aliases permet de rediriger les e-mails système (destinés à postmaster, root, etc.) vers une adresse réelle que vous consultez.

```bash
nano /etc/aliases
```

Ajoutez ou modifiez les lignes suivantes :

```bash
postmaster:    root
root:          votre@email.com
```

Appliquez la modification avec :

```bash
newaliases
```

	# Étape 10 – Redémarrer Postfix pour prendre en compte les changements

```bash
systemctl restart postfix
```
Cela garantit que les fichiers modifiés (main.cf, aliases, etc.) sont relus correctement.

	# Lexique des termes utilisés

DNS

Système qui permet d’associer une adresse lisible (comme mail.osnetworking.com) à une adresse IP. Il fonctionne comme un annuaire mondial distribué.

FQDN

Nom de domaine complet du serveur, incluant le nom d’hôte et le domaine principal (ex : mail.domain.tld).

SMTP

Protocole utilisé pour envoyer des emails entre serveurs. C’est le rôle de Postfix dans ce guide.

SSH

Protocole sécurisé pour accéder à distance à un serveur. Il remplace Telnet, qui est non sécurisé.

UFW

Uncomplicated Firewall. Pare-feu simple d’utilisation intégré à Ubuntu pour gérer les règles de sécurité réseau.

FAQ – Problèmes fréquents et solutions

Problème : le port 25 semble fermé

Vérifiez avec ss -lnpt | grep :25

```bash
ss -lnpt | grep :25
```

Si rien n’apparaît :

Postfix n’est pas démarré : systemctl start postfix

UFW bloque le port : 

```bash
ufw allow 25/tcp
```

Problème : mail non reçu par le destinataire

Vérifiez les logs :

```bash
tail -f /var/log/mail.log
```

Problèmes fréquents : erreur de DNS, blocage par le port 25 sortant, rejet côté destinataire

Problème : je ne reçois pas de mail système sur mon adresse

Vérifiez que le fichier /etc/aliases contient bien :

root: mon serveur

Puis :

```bash
newaliases && systemctl restart postfix
```

## 📁 Chapitre 3 – PostfixAdmin : Créer des boîtes aux lettres virtuelles

---

	# Étape 1 : Installer le serveur de base de données MariaDB/MySQL

MariaDB est un serveur de base de données relationnelles, très utilisé dans les environnements Linux pour stocker et gérer des données structurées. Dans le cadre de notre serveur mail, il est indispensable pour stocker les informations des utilisateurs, des domaines et des boîtes aux lettres, que ce soit pour Postfix ou Dovecot. On installe à la fois le serveur (qui héberge les bases de données) et le client (utile pour interagir en ligne de commande). L'activation automatique de MariaDB au démarrage garantit la disponibilité de vos services même après un redémarrage du serveur.

```bash
apt install mariadb-server mariadb-client
systemctl status mariadb
systemctl enable mariadb
```

	# Étape 2 : Télécharger PostfixAdmin sur Ubuntu Server

PostfixAdmin est une interface web très populaire pour administrer facilement un serveur de messagerie. Elle permet de créer des domaines, des boîtes aux lettres virtuelles, des alias, des redirections, etc., le tout depuis une interface graphique. Cette étape consiste à télécharger manuellement la dernière version stable depuis GitHub, à extraire les fichiers dans le répertoire approprié, et à les préparer pour l’hébergement via un serveur web (comme Apache ou Nginx). C’est une étape simple mais cruciale pour disposer d’un outil graphique moderne.

```bash
wget -P /opt/ https://github.com/postfixadmin/postfixadmin/archive/refs/tags/postfixadmin-3.3.15.tar.gz
tar -xzvf /opt/postfixadmin-3.3.15.tar.gz -C /var/www/
mv /var/www/postfixadmin-postfixadmin-3.3.15 /var/www/postfixadmin
```

	# Étape 3 : Configuration des autorisations

Lorsque vous déployez une application web comme PostfixAdmin, certains dossiers nécessitent des droits d’écriture. C’est le cas du répertoire templates_c/, qui est utilisé pour stocker les versions compilées des fichiers templates Smarty. Sans cette permission, PostfixAdmin échouera avec des erreurs HTTP 500. De plus, pour que l’interface puisse accéder aux certificats SSL ou aux sockets Dovecot, l’utilisateur www-data (utilisé par Apache) doit avoir les droits adéquats sur certains dossiers système. On utilise ici setfacl, un outil permettant d’attribuer des ACLs (Access Control Lists) de manière granulaire.

```bash
mkdir -p /var/www/postfixadmin/templates_c
apt install acl
setfacl -R -m u:www-data:rwx /var/www/postfixadmin/templates_c/
setfacl -R -m u:www-data:rx /etc/letsencrypt/live/ /etc/letsencrypt/archive/
```

	# Étape 4 : Créer une base de données et un utilisateur pour PostfixAdmin

PostfixAdmin a besoin d'une base de données pour fonctionner. Dans cette étape, vous créez une base nommée postfixadmin et un utilisateur SQL dédié (userpostfixadmin) avec les droits nécessaires sur cette base uniquement. Cela renforce la sécurité en évitant d'utiliser le compte root SQL. Modifier le bind-address permet à des outils comme DBeaver d’accéder à la base à distance. Pensez à redémarrer MariaDB après modification du fichier de configuration.

```bash
mysql -u root
CREATE USER 'userpostfixadmin'@'localhost' IDENTIFIED BY 'pwdpostfixadmin';
CREATE DATABASE postfixadmin;
GRANT ALL PRIVILEGES ON postfixadmin.* TO 'userpostfixadmin'@'localhost';
FLUSH PRIVILEGES;
```
Pour autoriser l'accès distant :

```bash
nano /etc/mysql/mariadb.conf.d/50-server.cnf

#bind-address = 127.0.0.1
bind-address = 0.0.0.0
systemctl restart mariadb
```

	# 🧩 Étape 5 – Installer les dépendances PHP pour PostfixAdmin
	
PostfixAdmin nécessite une série d’extensions PHP indispensables pour fonctionner : gestion des chaînes, support MySQL, CURL, sessions, fichiers ZIP/XML, etc. Sans ces extensions, vous risquez des erreurs HTTP 500, des pages blanches ou une interface qui ne charge pas. Cette étape garantit un environnement PHP complet et prêt pour l’exécution de l’interface web PostfixAdmin.

```bash
apt install php8.1 php8.1-cli php8.1-fpm php8.1-mysql php8.1-mbstring php8.1-intl php8.1-imap php8.1-curl php8.1-xml php8.1-zip php8.1-gd unzip -y
```

Merci de voir la version de PHP

```bash
php -v
```

	# 🌍 Étape 6 – Créer un VirtualHost Apache pour PostfixAdmin
	
Pour rendre PostfixAdmin accessible depuis un navigateur, il faut configurer un VirtualHost Apache. Cela permet d’associer le nom mail.domain.tld au répertoire /var/www/postfixadmin/public. On active également le module rewrite pour permettre les redirections internes nécessaires au fonctionnement de l’interface.

```bash

nano /etc/apache2/sites-available/postfixadmin.conf

```

Apache ne peut pas deviner comment servir ton application PostfixAdmin si vous ne lui dites pas quel nom de domaine utiliser et quel dossier servir. Le VirtualHost permet précisément cela. Dans cette étape, vous allez dire à Apache :

« Si quelqu’un visite mail.domain.tld, sers-lui les fichiers situés dans /var/www/postfixadmin/public. »

Le bloc <Directory> précise les droits d’accès. Il permet d’autoriser Apache à lire le contenu du dossier et d’autoriser les fichiers .htaccess. Ceux-ci peuvent être utilisés par PostfixAdmin pour gérer des redirections ou des règles de sécurité supplémentaires.

Les fichiers ErrorLog et CustomLog te permettent d’avoir des journaux spécifiques à PostfixAdmin : pratique pour diagnostiquer un problème de configuration.


Dans ce VirtualHost, on définit :

Le nom du serveur (ServerName)

Le dossier racine (DocumentRoot)

Les droits d’accès à ce dossier (via le bloc <Directory>)

Les chemins de logs personnalisés

On active aussi le module rewrite, utile pour certaines redirections dans PostfixAdmin.

Une fois le fichier créé, on active le site et on recharge Apache pour appliquer les changements.
👉 Si vous oubliez de recharger Apache, les modifications ne seront pas prises en compte.

```bash

<VirtualHost *:80>
    ServerName mail.domain.tld
    DocumentRoot /var/www/postfixadmin/public

    <Directory /var/www/postfixadmin/public>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/postfixadmin_error.log
    CustomLog ${APACHE_LOG_DIR}/postfixadmin_access.log combined
</VirtualHost>
```
Enfin, après avoir créé ce VirtualHost, il faut l’activer (a2ensite), activer mod_rewrite (si ce n’est pas déjà fait) et recharger Apache pour appliquer les changements. Sans cela, Apache ne prendra pas en compte la nouvelle configuration.

```bash
a2ensite postfixadmin.conf
a2enmod rewrite
systemctl reload apache2
```

	# ⚙️ Étape 7 – Copier et configurer config.inc.php
	
Le fichier config.inc.php est la colonne vertébrale de PostfixAdmin. C’est ici que Vous définissez tout ce qui est fondamental pour faire fonctionner l’application :

- langue par défaut,
- connexion à la base de données,
- sécurité du setup,
- quotas,
- activation ou non des alias catch-all, etc.

Vous ne devez jamais modifier le fichier .sample. C’est un modèle. Vous le copiez et vous modifies le nouveau fichier.


```bash
cd /var/www/postfixadmin
cp config.inc.php.sample config.inc.php
```

La ligne $CONF['configured'] = true; est indispensable. Elle indique à PostfixAdmin que le fichier est prêt à l’emploi.
Les variables $CONF['database_*'] permettent à PostfixAdmin de se connecter à la base de données créée à l’étape 4.
Si vous fais une faute dans le nom d’utilisateur ou le mot de passe ici, vous aurez une erreur SQL ou une page blanche au chargement.

En production, il est conseillé de restreindre l’accès en lecture à ce fichier (lecture seule pour www-data).

Ce fichier permet notamment de :

Connecter PostfixAdmin à MariaDB

Définir les options globales (quota, restrictions, etc.)

Activer le système


nano config.inc.php

Modifications minimales :

```bash
$CONF['configured'] = true;
$CONF['default_language'] = 'fr';
$CONF['database_type'] = 'mysqli';
$CONF['database_host'] = 'localhost';
$CONF['database_user'] = 'userpostfixadmin';
$CONF['database_password'] = 'pwdpostfixadmin';
$CONF['database_name'] = 'postfixadmin';
```

	# 🔐 Étape 8 – Générer le mot de passe hashé pour l'installation
	
Par mesure de sécurité, PostfixAdmin ne te permet pas de lancer l’installation tant que vous n’avez pas défini un mot de passe sécurisé pour accéder à setup.php.

Vous allez générer un hash sécurisé via l’interface web, puis l’insérer manuellement dans le fichier config.inc.php.
Ce mot de passe servira uniquement pour initialiser PostfixAdmin.

Rendez-vous ici :



http://mail.domain.tld/setup.php
Saisissez un mot de passe fort et copiez le hash généré. Puis éditez config.inc.php :

```bash
$CONF['setup_password'] = 'le_hash_généré';
```

	# 🧑💼 Étape 9 – Créer le compte administrateur
	
L’accès à la gestion des domaines et des utilisateurs passe par un compte administrateur principal.

Une fois le mot de passe hashé en place, la page setup.php t’autorisera à créer ce compte.
Ce compte n’est pas une boîte mail, mais un accès complet à l’interface d’administration.
👉 Choisis une adresse cohérente comme admin@domain.tld.


http://mail.domain.tld/setup.php

Remplissez les champs :

Adresse e-mail : admin@domain.tld

Mot de passe : fort et unique

Cliquez sur Ajouter un compte d'administrateur.

	# 🔒 Étape 10 – Supprimer setup.php par sécurité
	

Une fois le compte admin créé, il faut immédiatement supprimer le fichier setup.php.
Le laisser accessible met en danger ton installation : un attaquant pourrait l’utiliser pour reconfigurer ou ajouter un nouvel admin.

```bash
rm /var/www/postfixadmin/public/setup.php
```

	# 🧪 Étape 11 – Tester l’accès à PostfixAdmin
	
C’est le moment de vérifier que tout fonctionne correctement. Si vous avez bien suivi les étapes précédentes, vous devriez pouvoir accéder à l’interface PostfixAdmin depuis ton navigateur, en utilisant l’adresse de ton VirtualHost (souvent mail.domain.tld).

L’objectif ici est de valider que :

- L’interface s’affiche correctement
- Vous pouvez vous connecter avec le compte admin créé précédemment
- Il n’y a pas d’erreur PHP ou SQL visible

Vous pourrez ensuite naviguer dans les onglets Domaines, Utilisateurs, Alias, etc.
Si la page ne s’affiche pas ou si vous obtienez une erreur, retourne vérifier :

- Le VirtualHost Apache (étape 6)
- La configuration de config.inc.php (étape 7)
- Les modules PHP (étape 5)

Rendez-vous sur :


http://mail.domain.tld/

Connectez-vous avec l’adresse email et le mot de passe admin. Vérifiez que :

L’interface est fonctionnelle

Vous pouvez naviguer entre Domaines / Utilisateurs / Alias

Aucun message d’erreur n’est affiché

	# 🌐 Étape 12 – Activer HTTPS avec Certbot (optionnel mais recommandé)
	
Activer HTTPS est indispensable pour la sécurité : sans cela, tous les mots de passe sont transmis en clair.
Heureusement, tu peux obtenir un certificat gratuit via Let’s Encrypt en quelques secondes grâce à Certbot.

Si vous utilisez Apache, le mode --apache permet de :

- détecter automatiquement ton VirtualHost
- demander le certificat
- activer automatiquement la redirection HTTP → HTTPS

Certbot configure tout à ta place. Il vous proposera aussi de renouveler automatiquement les certificats avant expiration.

```bash
apt install certbot python3-certbot-apache -y
certbot --apache -d mail.domain.tld
```

Suivez les instructions pour obtenir et activer automatiquement le HTTPS.

	# 🛠️ Étape 13 – Ajouter un domaine dans l’interface
	
Une fois connecté à PostfixAdmin, vous pouvez commencer à ajouter les domaines que ton serveur va gérer.
Chaque domaine est une entité distincte contenant :

- Des utilisateurs (boîtes mail)
- Des alias
- Des redirections
- Des quotas personnalisés

Vous pouvez gérer autant de domaines que tu veux. C’est très pratique si vous hébergez plusieurs noms de domaine ou des clients différents.

Vous pouvez aussi définir des limites sur le nombre de comptes ou la taille globale autorisée.

Pas de commandes ici, tout se fait dans l’interface web :

Connectez-vous à PostfixAdmin, allez dans « Domaines » > « Ajouter un domaine » :

Domaine : domain.tld

Nombre max de boîtes : infinite ou 50 par exemple

Quota : 1000 Mo (ou ce que vous voulez)

Active : ✅

Puis cliquez sur Ajouter le domaine.


	# 📬 Étape 14 – Ajouter une boîte mail
	

Vous pouvez maintenant ajouter des utilisateurs rattachés au domaine.
Chaque boîte mail créée sera une entrée dans la base SQL. Elle pourra recevoir des mails, s’authentifier via IMAP/SMTP, et apparaîtra dans les logs de Dovecot/Postfix.

Vous pouvez aussi définir un quota par utilisateur, ce qui est utile pour éviter de saturer le disque.
Après avoir ajouté un domaine, vous pouvez créer une boîte utilisateur associée :

Menu Utilisateurs > Ajouter un utilisateur

Adresse e-mail : prenom.nom@domain.tld

Mot de passe : sécurisé

Quota : ex. 500 (en Mo)

Cliquez sur Ajouter un utilisateur.

	# 📤 Étape 15 – Ajouter un alias ou redirection
	
Un alias permet de rediriger une adresse vers une autre. C’est utile pour :

Les adresses génériques comme contact@, info@, support@
Les redirections vers plusieurs utilisateurs
Les redirections vers des boîtes externes (ex : Gmail)

Pas besoin de créer une vraie boîte pour chaque alias. Cela évite de consommer de l’espace disque inutilement.

Pour créer un alias (ex: contact@domain.tld vers prenom.nom@domain2.tld) :

Menu Alias > Ajouter un alias

Adresse source : contact@domain.tld

Destination : prenom.nom@domain2.tld

Domaine : domain.tld

Cliquez sur Ajouter l’alias.

	# ♻️ Étape 16 – Sauvegarde régulière de PostfixAdmin

Comme tout système en production, il est indispensable de sauvegarder régulièrement :

La base de données SQL (tous les utilisateurs, domaines, alias)

Le dossier /var/www/postfixadmin (pour les fichiers PHP)

Vous pouvez créer un script de sauvegarde simple, stocker les dumps dans /opt/backup/postfixadmin/ et planifier la tâche avec cron.
Pense aussi à nettoyer les anciens dumps pour éviter de saturer le disque.

Sauvegardez régulièrement la base SQL et les fichiers PHP de PostfixAdmin. Exemple de sauvegarde SQL automatisée :

Créer le dossier si ce n'est pas fait
```bash
mkdir -p /opt/backup/postfixadmin
```
🔹 Exemple de sauvegarde SQL

```bash
mysqldump -u userpostfixadmin -p'pwdpostfixadmin' postfixadmin > /opt/backup/postfixadmin/postfixadmin_$(date +%F).sql
```

🔹 Ajouter dans la crontab :


```bash
crontab -e
```

Tâche cron :

```bash
0 3 * * * /opt/script/backup_postfixadmin.sh
```
🔹 Nettoyage automatique des fichiers vieux de plus de 30 jours :

```bash
find /opt/backup/postfixadmin/ -type f -mtime +30 -delete
```