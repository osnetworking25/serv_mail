#!/bin/bash
content="

  Configuration de Postfix pour l utilisation avec PostfixAdmin

-----------------------

  Votre installation de Postfix DOIT prendre en charge les tables de consultation MySQL ou Postgres
ou Postgres.  Vous pouvez le vérifier avec 'postconf -m'

Il est généralement recommandé d'utiliser également le proxy (qui devrait également apparaître dans le champ
postconf -m) Trois variables main.cf sont impliquées :

virtual_mailbox_domains = proxy:mysql:/etc/postfix/sql/mysql_virtual_domains_maps.cf
virtual_alias_maps =
   proxy:mysql:/etc/postfix/sql/mysql_virtual_alias_maps.cf,
   proxy:mysql:/etc/postfix/sql/mysql_virtual_alias_domain_maps.cf,
   proxy:mysql:/etc/postfix/sql/mysql_virtual_alias_domain_catchall_maps.cf
virtual_mailbox_maps =
   proxy:mysql:/etc/postfix/sql/mysql_virtual_mailbox_maps.cf,
   proxy:mysql:/etc/postfix/sql/mysql_virtual_alias_domain_mailbox_maps.cf

# Pour la prise en charge des cartes de transport, utilisez également la configuration suivante :

relay_domains = proxy:mysql:/etc/postfix/sql/mysql_relay_domains.cf
transport_maps = proxy:mysql:/etc/postfix/sql/mysql_transport_maps.cf

# Définir également le paramètre transport=YES dans le fichier config.inc.php
# et ajoutez les choix de transport à transport_options.

# sivous laissez postfix stocker vos mails directement (sans utiliser maildrop, dovecot deliver etc.)
virtual_mailbox_base = /var/mail/vmail
# ou tout autre endroit où vous souhaitez stocker les courriers.

L'endroit où vous avez choisi de stocker les fichiers .cf n'a pas vraiment d'importance, mais ils seront
les mots de passe de la base de données sont stockés en texte clair et ne peuvent donc être lus que par les personnes suivantes
par l'utilisateur postfix, ou dans un répertoire uniquement accessible à l'utilisateur postfix.

Ce n'est pas nécessairement tout ce que vous devez faire pour que Postfix soit opérationnel.
en cours d'exécution.  Des modifications supplémentaires sont également nécessaires pour les vacances
fonctions de réponse automatique.

-------------------------

  Contenu des fichiers

Il ne s'agit que d'exemples, vous devrez et voudrez probablement procéder à des personnalisations.
personnalisations.  Vous devrez également prendre en compte les paramètres config.inc.php
pour domain_path et domain_in_mailbox.  Ces exemples
utilisent les valeurs domain_path=YES et domain_in_mailbox=NO

Vous pouvez créer ces fichiers (avec vos valeurs d'utilisateur, de mot de passe, d'hôtes et de
dbname) en exécutant ce fichier (sh POSTFIX_CONF.txt).
Veuillez noter que les fichiers générés sont destinés à être utilisés avec MySQL.

ISi vous utilisez PostgreSQL, vous devrez apporter quelques modifications aux requêtes :
- PostgreSQL utilise une implémentation différente pour les valeurs booléennes.
  vous devrez remplacer active='1' par active='t' dans toutes les requêtes
- PostgreSQL n'a pas de fonction concat(), à la place utilisez par exemple
  .... alias.address = '%u' || '@' || alias_domain.target_domain AND ....
 

mysql_virtual_alias_maps.cf:
user = postfix
password = password
hosts = localhost
dbname = postfix
query = SELECT goto FROM alias WHERE address='%s' AND active = '1'
#expansion_limit = 100

mysql_virtual_alias_domain_maps.cf:
user = postfix
password = password
hosts = localhost
dbname = postfix
query = SELECT goto FROM alias,alias_domain WHERE alias_domain.alias_domain = '%d' and alias.address = CONCAT('%u', '@', alias_domain.target_domain) AND alias.active='1' AND alias_domain.active='1'

mysql_virtual_alias_domain_catchall_maps.cf:
# handles catch-all settings of target-domain
user = postfix
password = password
hosts = localhost
dbname = postfix
query  = SELECT goto FROM alias,alias_domain WHERE alias_domain.alias_domain = '%d' and alias.address = CONCAT('@', alias_domain.target_domain) AND alias.active='1' AND alias_domain.active='1'

(Voir la note ci-dessus concernant Concat + PostgreSQL)

mysql_virtual_domains_maps.cf:
user = postfix
password = password
hosts = localhost
dbname = postfix
query          = SELECT domain FROM domain WHERE domain='%s' AND active = '1'
#query          = SELECT domain FROM domain WHERE domain='%s'
#optional query to use when relaying for backup MX
#query           = SELECT domain FROM domain WHERE domain='%s' AND backupmx = '0' AND active = '1'
#optional query to use for transport map support
#query           = SELECT domain FROM domain WHERE domain='%s' AND active = '1' AND NOT (transport LIKE 'smtp%%' OR transport LIKE 'relay%%')
#expansion_limit = 100

mysql_virtual_mailbox_maps.cf:
user = postfix
password = password
hosts = localhost
dbname = postfix
query           = SELECT maildir FROM mailbox WHERE username='%s' AND active = '1'
#expansion_limit = 100

mysql_virtual_alias_domain_mailbox_maps.cf:
user = postfix
password = password
hosts = localhost
dbname = postfix
query = SELECT maildir FROM mailbox,alias_domain WHERE alias_domain.alias_domain = '%d' and mailbox.username = CONCAT('%u', '@', alias_domain.target_domain) AND mailbox.active='1' AND alias_domain.active='1'

mysql_relay_domains.cf:
user = postfix
password = password
hosts = localhost
dbname = postfix
query = SELECT domain FROM domain WHERE domain='%s' AND active = '1' AND (transport LIKE 'smtp%%' OR transport LIKE 'relay%%')

mysql_transport_maps.cf:
user = postfix
password = password
hosts = localhost
dbname = postfix
query = SELECT transport FROM domain WHERE domain='%s' AND active = '1'


(Voir la note ci-dessus concernant Concat + PostgreSQL)

# Pour la prise en charge des quotas

mysql_virtual_mailbox_limit_maps.cf:
user = postfix
password = password
hosts = localhost
dbname = postfix
query = SELECT quota FROM mailbox WHERE username='%s' AND active = '1'

-------------------------

  Plus d'informations - Documents d'aide qui utilisent PostfixAdmin

http://postfix.wiki.xs4all.nl/index.php?title=Virtual_Users_and_Domains_with_Courier-IMAP_and_MySQL
http://wiki.dovecot.org/HowTo/DovecotLDAPostfixAdminMySQL

" # fin du contenu

# générer des fichiers de configuration à partir de ce fichier
# pour ce faire, lancez sh POSTFIX_CONF.sh

POSTFIX_CONF="$0"

map_files="`sed -n '/^mysql.*cf:/ s/://p' < \"$0\"`"

mkdir -p /etc/postfix/sql || { echo "Erreur: n'a pas pu créer le dossier /etc/postfix/sql" >&2; exit 1; }
tmpdir="/etc/postfix/sql"

echo $tmpdir

if ls "$tmpdir"/*.cf >/dev/null 2>&1; then
    read -p "Des fichiers .cf existent déjà dans $tmpdir. Voulez-vous les supprimer ? (o/N) " confirm_delete
    if [ "$confirm_delete" = "o" ]; then
        rm -f "$tmpdir"/*.cf
        echo "🧹 Anciens fichiers supprimés."
    else
        echo "➡️  Les anciens fichiers ont été conservés."
    fi
else
    echo "ℹ️ Aucun fichier .cf existant à supprimer."
fi


echo 'Hôte de la base de données ? (souvent localhost)'
read hosts
test -z "$hosts" && hosts=localhost

echo 'Database name?'
read dbname
test -z "$dbname" && { echo "Erreur: vous n'avez pas saisi de nom de base de données" >&2 ; exit 1; }

echo Database user?
read user
test -z "$user" && { echo "Erreur: vous n'avez pas saisi de nom d'utilisateur pour la base de données" >&2 ; exit 1; }

echo Database password?
read password
test -z "$password" && { echo "Erreur: vous n'avez pas saisi le mot de passe de la base de données" >&2 ; exit 1; }

for file in $map_files ; do
	(
		echo "# $file"
		sed -n "/$file:/,/^$/ p" < "$POSTFIX_CONF" | sed "
			1d ; # filename
			s/^user =.*/user = $user/ ;
			s/^password =.*/password = $password/ ;
			s/^hosts =.*/hosts = $hosts/ ;
			s/^dbname =.*/dbname = $dbname/ ;
		"
	) > "$tmpdir/$file"
done

# Donner l'accès au répertoire
chown root:postfix /etc/postfix/sql
chmod 0750 /etc/postfix/sql

# Appliquer les droits sur tous les fichiers SQL (lecture pour postfix uniquement)
chmod 0640 /etc/postfix/sql/*
setfacl -R -m u:postfix:rx /etc/postfix/sql/


# Vérifier que setfacl est installé
if command -v setfacl >/dev/null 2>&1; then
    setfacl -R -m u:postfix:rx /etc/postfix/sql/
    echo "✅ ACL appliquées : postfix a les droits nécessaires sur /etc/postfix/sql/"
else
    echo "⚠️  setfacl n'est pas installé. Installation recommandée pour appliquer les ACL (apt install acl)"
fi


echo "✅ Les fichiers ont été créés et sécurisés dans /etc/postfix/sql/"
echo "🔧 N'oubliez pas d'éditer /etc/postfix/main.cf comme décrit dans ce script."

# Insertion automatique dans /etc/postfix/main.cf après TLS
postconf_file="/etc/postfix/main.cf"
insertion_point=$(grep -n '^smtpd_tls_cert_file' "$postconf_file" | cut -d: -f1)

if [ -n "$insertion_point" ]; then
    insertion_line=$((insertion_point + 1))
    sed -i "${insertion_line}r /dev/stdin" "$postconf_file" <<EOF

# Configuration PostfixAdmin – Virtual Mailboxes et Alias SQL
virtual_mailbox_domains = proxy:mysql:/etc/postfix/sql/mysql_virtual_domains_maps.cf
virtual_alias_maps =
    proxy:mysql:/etc/postfix/sql/mysql_virtual_alias_maps.cf,
    proxy:mysql:/etc/postfix/sql/mysql_virtual_alias_domain_maps.cf,
    proxy:mysql:/etc/postfix/sql/mysql_virtual_alias_domain_catchall_maps.cf
virtual_mailbox_maps =
    proxy:mysql:/etc/postfix/sql/mysql_virtual_mailbox_maps.cf,
    proxy:mysql:/etc/postfix/sql/mysql_virtual_alias_domain_mailbox_maps.cf
virtual_mailbox_base = /var/mail/vmail
virtual_minimum_uid = 2000
virtual_uid_maps = static:2000
virtual_gid_maps = static:2000

# 📨 Transports personnalisés (activables si besoin)
#relay_domains = proxy:mysql:/etc/postfix/sql/mysql_relay_domains.cf
#transport_maps = proxy:mysql:/etc/postfix/sql/mysql_transport_maps.cf
EOF

fi

 # 🔧 Modification de mydestination pour éviter les conflits avec les domaines virtuels
sudo postconf -e "mydestination = \$myhostname, localhost.\$mydomain, localhost"
echo "✅ Paramètre 'mydestination' mis à jour pour exclure les domaines apex – configuration conforme à une installation avec boîtes aux lettres virtuelles."

# 🔁 Commenter mailbox_transport s'il est défini
if grep -q "^mailbox_transport" "$postconf_file"; then
    sed -i 's/^mailbox_transport/#&/' "$postconf_file"
    echo "🔁 La ligne 'mailbox_transport' a été commentée."
fi

# ➕ Ajouter virtual_transport si absent
if ! grep -q '^virtual_transport' "$postconf_file"; then
    echo "virtual_transport = lmtp:unix:private/dovecot-lmtp" >> "$postconf_file"
    echo "✅ La ligne 'virtual_transport' a été ajoutée à la fin du fichier."
else
    echo "ℹ️ La ligne 'virtual_transport' existe déjà. Aucune modification effectuée."
fi

echo "✅ Les lignes PostfixAdmin ont été insérées dans $postconf_file après smtpd_tls_cert_file."


read -p "Souhaitez-vous relancer le service Postfix maintenant ? (o/N) " confirm
if [ "$confirm" = "o" ]; then
    systemctl reload postfix && echo "✅ Le service Postix est relancé"
else
    echo "❗ N'oubliez pas de relancer le service Postfix manuellement : sudo systemctl reload postfix"
fi



