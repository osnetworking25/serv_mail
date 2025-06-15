📘 README.txt – Scripts PostfixAdmin – Pontarlier Informatique

Ce dossier contient deux scripts automatisant des étapes critiques de la configuration Postfix + PostfixAdmin
en suivant le guide LinuxBabe, avec des améliorations professionnelles :

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ 1. Génération des fichiers SQL (*.cf)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🎯 Objectif :
Créer automatiquement les fichiers SQL de configuration de Postfix pour PostfixAdmin
(virtual_mailbox_domains, virtual_alias_maps, etc.)

📌 Détails :
- Génére tous les fichiers dans `/etc/postfix/sql/`
  - mysql_virtual_alias_maps.cf
  - mysql_virtual_domains_maps.cf
  - mysql_virtual_mailbox_maps.cf
  - mysql_virtual_email2email.cf
  - mysql_virtual_alias_domain_maps.cf
- Demande à l’utilisateur les informations :
  - Hôte de la base de données
  - Nom de la base
  - Utilisateur SQL
  - Mot de passe SQL
- Applique automatiquement :
  - Les bons droits (chmod 640)
  - Le propriétaire root:postfix
  - Les ACL nécessaires

🟢 Statut : OK – Script testé, conforme et prêt pour production

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ 2. Insertion dans main.cf (Postfix)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🎯 Objectif :
Modifier intelligemment le fichier `/etc/postfix/main.cf` pour insérer les paramètres nécessaires à PostfixAdmin.

📌 Détails :

a. Bloc PostfixAdmin :
Ajoute juste après la ligne `smtpd_tls_cert_file` les lignes suivantes :
  - `virtual_mailbox_domains = mysql:/etc/postfix/sql/mysql_virtual_domains_maps.cf`
  - `virtual_mailbox_maps = mysql:/etc/postfix/sql/mysql_virtual_mailbox_maps.cf`
  - `virtual_alias_maps = mysql:/etc/postfix/sql/mysql_virtual_alias_maps.cf`
  - `virtual_alias_domains =`
  - `virtual_alias_domain_maps = mysql:/etc/postfix/sql/mysql_virtual_alias_domain_maps.cf`
  - `virtual_mailbox_base = /var/vmail/`
  - `virtual_minimum_uid = 2000`
  - `virtual_uid_maps = static:2000`
  - `virtual_gid_maps = static:2000`

🟢 OK – Les lignes sont ajoutées exactement à l’endroit logique recommandé

b. Paramètre `mydestination` :
- Le script applique `postconf -e "mydestination = localhost"`
  (comme recommandé pour éviter les conflits avec les domaines virtuels)

🟢 OK – Appliqué automatiquement

c. Paramètre `virtual_transport` :
- Le script ajoute :
  - `virtual_transport = lmtp:unix:private/dovecot-lmtp`
- Si `mailbox_transport` existe dans main.cf, il est remplacé par `virtual_transport`
  (car `mailbox_transport` est obsolète pour les boîtes virtuelles)

🟢 OK – Bloc de remplacement sécurisé inclus

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ 3. Préparation de l’environnement vmail
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🎯 Objectif :
Créer le compte système `vmail`, définir l’UID/GID à 2000 et créer le dossier `/var/vmail`

📌 Détails :
- Crée l’utilisateur système `vmail` sans home directory :
  `sudo adduser vmail --system --group --uid 2000 --disabled-login --no-create-home`
- Crée le dossier `/var/vmail/`
- Assigne les droits :
  - Propriétaire : `vmail:vmail`
  - Permissions : `chown vmail:vmail /var/vmail/ -R`
  - Aucune ligne `chmod 770` par défaut (comme recommandé par LinuxBabe)

🟢 OK – Script séparé `prepare_vmail.sh`

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📁 Structure des fichiers
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

```bash
/opt/postfixadmin-scripts/
├── POSTFIX_CONF.sh           # Génère les fichiers .cf, modifie main.cf
├── prepare_vmail.sh          # Crée l'utilisateur vmail + /var/vmail
└── README.txt                # Explications pour toi ou un collègue futur

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚙️ Commande utile – Rendre les scripts exécutables
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Pour rendre tous les fichiers exécutables sauf le README.txt :
find /opt/postfixadmin-scripts/ -type f ! -name 'README.TXT' -exec chmod +x {} \;

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🧪 Vérification manuelle des fichiers SQL
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Après exécution du script `POSTFIX_CONF.sh`, vous pouvez vérifier la bonne création des fichiers `.cf` et leur contenu :
✅ Vérification des fichiers SQL générés :
📁 Lister tous les fichiers générés :

ls -l /etc/postfix/sql/

✅ Vérification de d'un fichier mysql_virtual_alias_maps.cf :
🔍 Lire les premières lignes d’un fichier pour voir les paramètres injectés :

head -n 10 /etc/postfix/sql/mysql_virtual_alias_maps.cf

✅ Vérification du contenu personnalisé :
🔎 Vérification groupée de tous les fichiers .cf (valeurs user, password, hosts, dbname) :

grep -H 'user\|password\|hosts\|dbname' /etc/postfix/sql/*.cf

✅ Tous les fichiers doivent contenir les valeurs correctes saisies lors de l’exécution du script.
Notamment :

hosts = localhost

dbname = ... (ex : P52OeahS842TADM)

user et password correspondants à votre base PostfixAdmin

✅ Vérification de l’absence de valeurs par défaut restantes :

grep -Hn 'user = postfix' /etc/postfix/sql/*.cf
grep -HEn '(user|password|hosts|dbname) = postfix' /etc/postfix/sql/*.cf

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🧪 Vérification complète après exécution
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅ Vérification de l’insertion correcte dans /etc/postfix/main.cf :
grep -A20 '^smtpd_tls_cert_file' /etc/postfix/main.cf

✅ Vérification de la configuration mydestination :
postconf mydestination

✅ Vérification du transport actif :
postconf virtual_transport

✅ Vérification de la désactivation de mailbox_transport :
grep '^mailbox_transport' /etc/postfix/main.cf


✅ Vérification de l’absence de valeurs par défaut restantes :

🟢 Ces fichiers doivent être lisibles par Postfix grâce aux ACL appliquées (setfacl -R -m u:postfix:rx).
drwxr-x---+   2 root postfix  4096 juin   3 16:47 sql/

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🧪 Vérification complète après exécution
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅ Vérification de l'existence de l'utilisateur système vmail :
grep vmail /etc/passwd
# ➜ Résultat attendu : vmail:x:2000:2000::/home/vmail:/usr/sbin/nologin

✅ Vérification de l'existence du groupe vmail :
grep vmail /etc/group
# ➜ Résultat attendu : vmail:x:2000:

✅ Vérification de la présence du dossier /var/vmail :
ls -ld /var/vmail
# ➜ Résultat attendu : drwxr-xr-x 2 vmail vmail 4096 [date] /var/vmail

✅ Vérification de la propriété (UID:GID) du dossier /var/vmail :
stat -c "%U %G" /var/vmail
# ➜ Résultat attendu : vmail vmail

✅ Vérification que le script n’applique les droits que si nécessaire :
# Testé manuellement en forçant root:root sur /var/vmail avant relance
chown root:root /var/vmail -R
sh /opt/postfixadmin-scripts/prepare_vmail.sh
# ➜ Le script détecte la mauvaise propriété et corrige en vmail:vmail

Dernière mise à jour : [03/06/2025]

