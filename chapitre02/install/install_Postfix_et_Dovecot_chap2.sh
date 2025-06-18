#!/bin/bash
# =====================================================================
# 📬 Script d’installation Postfix et Dovecot – Serveur mail 2025
# 📘 Chapitre 02 – Installation sécurisée de Postfix + Dovecot (TLS)
# 🧾 Version : 1.0
# 🧑💼 Auteur : pontarlier-informatique - osnetworking
# =====================================================================

# ------------------------------------------------------------------
# 🌍 Bloc de sélection de la langue (multi-langue)
# ------------------------------------------------------------------

LANG="fr"
echo -e "\n🌐 Choisissez votre langue / Choose your language :"
echo "1) Français"
echo "2) English"
read -rp "➡️  Votre choix / Your choice [1-2] : " LANG_CHOICE
case "$LANG_CHOICE" in
  2|"en"|"EN") LANG="en" ;;
  1|"fr"|"FR"|*) LANG="fr" ;;
esac

LANG_FILE="/opt/serv_mail/lang/${LANG}.sh"
if [[ -f "$LANG_FILE" ]]; then
  source "$LANG_FILE"
else
  echo "❌ Erreur : fichier de langue manquant : $LANG_FILE"
  exit 1
fi


# ------------------------------------------------------------------
# 📥 Saisie des variables dynamiques
# ------------------------------------------------------------------

while [[ -z "$DOMAIN" ]]; do
  read -rp "$msg_prompt_domain_chap2 : " DOMAIN
done

while [[ -z "$MAIL_SERVER_FQDN" ]]; do
  read -rp "$msg_prompt_mail_fqdn_chap2 (ex: mail.${DOMAIN}) : " MAIL_SERVER_FQDN
done

# 📧 Demande d'adresse mail Let's Encrypt pour Certbot
while [[ -z "$CERTBOT_EMAIL" ]]; do
  read -rp "$(msg_prompt_certbot_email) : " CERTBOT_EMAIL
done


# ------------------------------------------------------------------
# 📁 Création de l’arborescence de travail
# ------------------------------------------------------------------

SERV_ROOT="/opt/serv_mail/chapitre_02"
LOGS_DIR="${SERV_ROOT}/logs"
BACKUP_DIR="/opt/serv_mail/chapitre02/backup/${DOMAIN}"
mkdir -p "$LOGS_DIR" "$BACKUP_DIR"

DATE_NOW="$(date +%F_%Hh%M)"
MAIN_CF="/etc/postfix/main.cf"
DOVECOT_CONF_10AUTH="/etc/dovecot/conf.d/10-auth.conf"
DOVECOT_CONF_10SSL="/etc/dovecot/conf.d/10-ssl.conf"
DOVECOT_CONF_10MASTER="/etc/dovecot/conf.d/10-master.conf"
OPENDKIM_CONF="etc/ssl/openssl.cnf"

# ------------------------------------------------------------------
# 📘 Introduction du Chapitre 2
# ------------------------------------------------------------------

echo -e "\n$sg_step0_banner_chap2"
echo -e "\n$msg_step0_intro_chap2"
echo -e "$msg_steps0_chap2"
echo -e "$msg_step0_steps_chap2"

# ------------------------------------------------------------------
# 📘 Étape 1 – Vérification de l'état de UFW et ouverture des ports
# ------------------------------------------------------------------
# 🧠 Cette étape vérifie si le pare-feu UFW est activé.
#
# ➤ Si UFW est **désactivé** :
#     - Le script demande à l'utilisateur s'il souhaite l’activer.
#     - En cas de réponse "oui", UFW est activé et les ports nécessaires sont ouverts.
#     - En cas de refus, aucun port n’est ouvert (⚠️ la sécurité réseau devra être gérée manuellement).
#
# ➤ Si UFW est **déjà activé** :
#     - Le script ouvre directement tous les ports nécessaires aux services mail, webmail et SSH.
#
# 🔓 Ports ouverts automatiquement :
#   - 80 (HTTP), 443 (HTTPS)
#   - 25 (SMTP), 465 (SMTPs), 587 (Submission)
#   - 143 (IMAP), 993 (IMAPS)
#   - 110 (POP3), 995 (POP3S)
#   - 22 (SSH)
# ------------------------------------------------------------------
Étape =1
echo -e "\n$(msg_step1_chap2_intro)"
echo -e "\n$msg_check_ufw"

UFW_STATUS=$(sudo ufw status | grep -o "active")

if [[ "$UFW_STATUS" != "active" ]]; then
  echo "$msg_inactive_ufw"
  read -rp "$msg_enable_ufw : " ENABLE_UFW
  if [[ "$ENABLE_UFW" =~ ^[OoYy]$ ]]; then
    echo "$msg_enable_ufw_activate"
    sudo ufw enable
    echo "$msg_ufw_activated"
  else
    echo "$msg_ufw_disabled"
  fi
else
  echo "$msg_active_ufw"
fi

echo -e "\n$msg_open_ports"

for PORT in 80 443 587 465 143 993 110 995 22 25; do
  sudo ufw allow "$PORT"/tcp
done

sudo ufw status verbose
echo "$msg_open_ports_complete"

# ✅ Message dynamique de fin d'étape
echo -e "\n${msg_step_success_prefix} ${ETAPE} ${msg_step_success_suffix}"


 
# ------------------------------------------------------------------
# 📘 Étape 2 – Installation de Certbot et du serveur Apache
# ------------------------------------------------------------------
# 🧠 Cette étape prépare le serveur pour l’obtention d’un certificat TLS Let's Encrypt.
#
# ➤ Elle installe Certbot, le client officiel de Let's Encrypt.
# ➤ Elle met à jour le système via apt.
# ➤ Elle installe Apache + le plugin python3-certbot-apache si Apache n’est pas encore présent.
#
# Ces composants seront nécessaires dans l’étape suivante pour générer
# le certificat TLS (avec un virtualhost Apache temporaire).
# ------------------------------------------------------------------
ETAPE=2
echo -e "\n$(msg_step2_chap2_intro)"

# 🔄 Mise à jour complète du système
echo "$msg_update_system"
sudo apt update
sudo apt dist-upgrade -y

# 🔧 Installation de Certbot
echo "$msg_install_certbot_chap2"
sudo apt install -y certbot

# 🔧 Installation d'Apache + plugin Certbot pour Apache
echo "$msg_install_step2_apache_plugin_chap2"
sudo apt install -y apache2 python3-certbot-apache

echo -e "\n${msg_step_success_prefix} ${ETAPE} ${msg_step_success_suffix}"

# ------------------------------------------------------------------
# 📘 Étape 3 – Création du virtualhost Apache + certificat Let's Encrypt
# ------------------------------------------------------------------

ETAPE=3
echo -e "\n$(msg_step3_chap2_intro)"

# 📁 Création du virtualhost Apache
VHOST_PATH="/etc/apache2/sites-available/${MAIL_SERVER_FQDN}.conf"
echo -e "\n$msg_create_apache_vhost"
sudo bash -c "cat > $VHOST_PATH <<EOF
<VirtualHost *:80>
    ServerName $MAIL_SERVER_FQDN
    DocumentRoot /var/www/html/
</VirtualHost>
EOF"

# ✅ Activer le site et désactiver le défaut
echo -e "\n$msg_enable_apache_vhost"
sudo a2ensite "${MAIL_SERVER_FQDN}.conf"
sudo a2dissite 000-default
sudo systemctl reload apache2

# 🔐 Lancer Certbot
echo -e "\n$msg_run_certbot"
sudo certbot certonly -a apache \
  --agree-tos \
  --no-eff-email \
  --staple-ocsp \
  --email "$CERTBOT_EMAIL" \
  -d "$MAIL_SERVER_FQDN"

# ✅ Fin de l’étape
echo -e "\n${msg_step_success_prefix} ${ETAPE} ${msg_step_success_suffix}"


# ------------------------------------------------------------------
# 📘 Étape 4 – Installation de Postfix + configuration master.cf
# ------------------------------------------------------------------
# 🧠 Cette étape installe Postfix pour gérer l’envoi des emails sortants (SMTP).
#
# ➤ Le paquet `postfix` fournit le serveur de mail principal.
# ➤ `postfix-mysql` permet de l'intégrer à une base de données MySQL/PostfixAdmin plus tard.
# ➤ `mailutils` permet de tester l’envoi de mails en ligne de commande.
#
# Une fois installé, Postfix est configuré avec :
#   - le FQDN du serveur (myhostname)
#   - le nom de domaine principal (mydomain)
#   - la boîte aux lettres au format Maildir (home_mailbox)
#   - la compatibilité IPv4 uniquement (inet_protocols)
#
# 💬 Ensuite, on active dans `master.cf` les services standardisés :
#   - `submission` (port 587) pour les clients authentifiés
#   - `smtps` (port 465) pour les connexions sécurisées TLS implicites
#
# 💾 Avant toute modification, une sauvegarde de `main.cf` et `master.cf` est effectuée.


# ------------------------------------------------------------------
# 📘 Step 4 – Configure submission (587) and smtps (465) in master.cf
# ------------------------------------------------------------------

# 🔢 Définir le numéro de l'étape
ETAPE=4

echo -e "\n$(msg_step4_chap2_mastercf_intro)"

# 💾 Sauvegarde de master.cf
cp /etc/postfix/master.cf "${BACKUP_DIR}/master.cf.original"
echo "$msg_step4_mastercf_done"

# 🔧 Ajout des blocs submission et smtps si absents
if ! grep -q "submission inet" /etc/postfix/master.cf; then
  cat <<'EOF' >> /etc/postfix/master.cf

# ----------------------------------------------
# 🌐 Ajout – Service Submission (Port 587)
# ----------------------------------------------
submission inet n       -       y       -       -       smtpd
  -o syslog_name=postfix/submission
  -o smtpd_tls_security_level=encrypt
  -o smtpd_sasl_auth_enable=yes
  -o smtpd_tls_auth_only=yes
  -o smtpd_reject_unlisted_recipient=no
  -o smtpd_client_restrictions=$mua_client_restrictions
  -o smtpd_helo_restrictions=$mua_helo_restrictions
  -o smtpd_sender_restrictions=$mua_sender_restrictions
  -o smtpd_recipient_restrictions=
  -o smtpd_relay_restrictions=permit_sasl_authenticated,reject
  -o milter_macro_daemon_name=ORIGINATING

# ----------------------------------------------
# 🔒 Ajout – Service SMTPS (Port 465)
# ----------------------------------------------
smtps     inet  n       -       y       -       -       smtpd
  -o syslog_name=postfix/smtps
  -o smtpd_tls_wrappermode=yes
  -o smtpd_sasl_auth_enable=yes
  -o smtpd_reject_unlisted_recipient=no
  -o smtpd_client_restrictions=$mua_client_restrictions
  -o smtpd_helo_restrictions=$mua_helo_restrictions
  -o smtpd_sender_restrictions=$mua_sender_restrictions
  -o smtpd_recipient_restrictions=
  -o smtpd_relay_restrictions=permit_sasl_authenticated,reject
  -o milter_macro_daemon_name=ORIGINATING

EOF
  echo -e "$(msg_step4_chap2_mastercf_added)"
else
  echo -e "$(msg_step4_chap2_mastercf_already_present)"
fi

# ------------------------------------------------------------------
# 📘 Step 4 – Installation de Postfix
# ------------------------------------------------------------------

echo -e "\n$(msg_step4_chap2_intro)"

# 💾 Sauvegarde de main.cf
cp "$MAIN_CF" "${MAIN_CF}.original"
echo "$msg_step4_maincf_done"

# ⚙️ Configuration de base de Postfix
echo "$msg_step4_postfix_config_chap2"
echo -e "\n$(msg_step4_postfix_config_domain_chap2)"
sudo postconf -e "myhostname = $MAIL_SERVER_FQDN"
sudo postconf -e "mydomain = $DOMAIN"
sudo postconf -e "myorigin = /etc/mailname"
sudo postconf -e "inet_interfaces = all"
sudo postconf -e "inet_protocols = ipv4"
sudo postconf -e "home_mailbox = Maildir/"

# # 🔄 Restart Postfix after main.cf and master.cf changes
systemctl restart postfix
echo -e "$(msg_step4_chap2_mastercf_success)"

# 🧪 Optional: test socket
sudo ss -lnpt | grep master

# ✅ End of step
echo -e "\n${msg_step_success_prefix} ${ETAPE} ${msg_step_success_suffix}"

# ------------------------------------------------------------------
# 📘 Étape 5 – Installation de Dovecot
# ------------------------------------------------------------------
# 🧠 Cette étape installe Dovecot, le serveur IMAP/POP3 utilisé pour
# recevoir les courriels des utilisateurs.
#
# ➤ `dovecot-core` : composant principal
# ➤ `dovecot-imapd` : support IMAP (protocole moderne)
# ➤ `dovecot-pop3d` : support POP3 (optionnel)
#
# Cette étape configure également :
#   - le stockage des boîtes mail au format Maildir
#   - le chiffrement TLS à partir des certificats Let's Encrypt
# ------------------------------------------------------------------

ETAPE=5
echo -e "\n$(msg_step5_chap2_intro)"

# 📦 Installation de Dovecot
echo "$msg_step5_install_dovecot_chap2"
sudo apt install -y dovecot-core dovecot-imapd dovecot-pop3d

# 🔍 Vérification de la version installée
echo -e "\n$msg_step5_msg_check_dovecot_version"
dovecot --version

# ✅ Fin d’étape
echo -e "\n${msg_step_success_prefix} ${ETAPE} ${msg_step_success_suffix}"

# ------------------------------------------------------------------
# 📘 Étape 6 – Activer les protocoles IMAP et POP3 dans Dovecot
# ------------------------------------------------------------------
# 🧠 Cette étape configure Dovecot pour activer les protocoles de
# récupération des mails par les clients (IMAP et POP3).
#
# ➤ Le protocole IMAP permet de lire les mails à distance (recommandé).
# ➤ Le protocole POP3 permet de télécharger les mails localement.
#
# ✍️ La directive `protocols = imap pop3` est ajoutée dans le fichier
#      /etc/dovecot/dovecot.conf
#
# 💾 Une sauvegarde du fichier de configuration est effectuée avant
# toute modification.
#
# 🔄 Enfin, le service Dovecot est redémarré pour appliquer les changements.
# ------------------------------------------------------------------
ETAPE=6
echo -e "\n$(msg_step6_chap2_intro)"

# 💾 Sauvegarde de /etc/dovecot/dovecot.conf
DOVECOT_CONF="/etc/dovecot/dovecot.conf"
cp "$DOVECOT_CONF" "${BACKUP_DIR}/dovecot.conf.original"
echo "$msg_step6_dovecot_bak"

# 🔧 Activation des protocoles imap et pop3
echo "$msg_step6_enable_protocols"
sudo sed -i '/^protocols *=/d' "$DOVECOT_CONF"
echo "protocols = imap pop3" | sudo tee -a "$DOVECOT_CONF" >/dev/null

# 🔄 Redémarrage de Dovecot
echo "$msg_step6_restart_dovecot"
sudo systemctl restart dovecot

# ✅ Fin d’étape
echo -e "\n${msg_step_success_prefix} ${ETAPE} ${msg_step_success_suffix}"

# ------------------------------------------------------------------
# 📘 Étape 7 – Configuration du stockage Maildir dans Dovecot
# ------------------------------------------------------------------
# 🧠 Par défaut, Dovecot utilise le format mbox, stocké dans /var/mail.
#
# ➤ Cette étape configure le stockage en format Maildir :
#     - Plus moderne
#     - Compatible avec les utilisateurs virtuels
#     - Recommandé pour une meilleure gestion des boîtes mail
#
# 📁 Le fichier concerné est : /etc/dovecot/conf.d/10-mail.conf
#     - On y définit `mail_location = maildir:~/Maildir`
#     - Et on ajoute `mail_privileged_group = mail`
# ------------------------------------------------------------------

ETAPE=7
echo -e "\n$(msg_step7_chap2_intro)"

MAIL_CONF="/etc/dovecot/conf.d/10-mail.conf"
cp "$MAIL_CONF" "${BACKUP_DIR}/10-mail.conf.original"
echo "$msg_step7_dovecot_mail_bak_done"

# 🔧 Modification mail_location et ajout mail_privileged_group
echo "$msg_step7_config_mail_location"
sudo sed -i 's|^#*\s*mail_location\s*=.*|mail_location = maildir:~/Maildir|' "$MAIL_CONF"

if ! grep -q "^mail_privileged_group" "$MAIL_CONF"; then
  echo "mail_privileged_group = mail" | sudo tee -a "$MAIL_CONF" >/dev/null
  echo "$msg_step7_add_priv_group"
else
  echo "$msg_step7_priv_group_already"
fi

# ➕ Ajout de dovecot au groupe mail
echo "$msg_step7_add_usergroup"
sudo adduser dovecot mail

# 🔄 Redémarrage Dovecot
echo "$msg_step7_restart_dovecot"
sudo systemctl restart dovecot

# ✅ Fin d’étape
echo -e "\n${msg_step_success_prefix} ${ETAPE} ${msg_step_success_suffix}"

# ------------------------------------------------------------------
# 📘 Étape 8 – Configuration de Postfix pour utiliser LMTP avec Dovecot
# ------------------------------------------------------------------
# 🧠 Cette étape permet à Postfix de déléguer la distribution locale des emails à Dovecot,
# via le protocole LMTP, ce qui garantit une livraison au format Maildir.
#
# ➤ `dovecot-lmtpd` : service à installer pour activer le protocole LMTP côté Dovecot.
# ➤ `protocols = imap lmtp` : active IMAP et LMTP dans dovecot.conf.
# ➤ `10-master.conf` : configure le socket Unix utilisé par LMTP.
# ➤ `main.cf` de Postfix : ajoute la directive `mailbox_transport` pour pointer vers LMTP.
# ------------------------------------------------------------------

ETAPE=8
echo -e "\n$(msg_step8_chap2_intro)"

# 📦 Installer le paquet dovecot-lmtpd
echo "$msg_step8_install_lmtpd"
sudo apt install -y dovecot-lmtpd

# 🔧 Activer le protocole LMTP dans dovecot.conf
echo "$msg_step8_enable_lmtp"
DOVECOT_CONF="/etc/dovecot/dovecot.conf"

cp "$DOVECOT_CONF" "${DOVECOT_CONF}.original"
sed -i 's/^protocols = .*/protocols = imap lmtp/' "$DOVECOT_CONF"

# 🔧 Configurer le socket LMTP dans 10-master.conf
echo "$msg_step8_configure_lmtp_socket"
MASTER_CONF="/etc/dovecot/conf.d/10-master.conf"
cp "$MASTER_CONF" "${MASTER_CONF}.original"
sed -i '/^service lmtp {/,$d' "$MASTER_CONF"

cat <<'EOF' >> "$MASTER_CONF"

service lmtp {
  unix_listener /var/spool/postfix/private/dovecot-lmtp {
    mode = 0600
    user = postfix
    group = postfix
  }
}
EOF

# 📬 Ajouter la configuration dans main.cf de Postfix
echo "$msg_step8_configure_postfix_lmtp"
POSTFIX_CF="/etc/postfix/main.cf"
cp "$POSTFIX_CF" "${POSTFIX_CF}.original"

postconf -e "mailbox_transport = lmtp:unix:private/dovecot-lmtp"
postconf -e "smtputf8_enable = no"

# ✅ Fin d’étape
echo -e "\n${msg_step_success_prefix} ${ETAPE} ${msg_step_success_suffix}"


# ------------------------------------------------------------------
# 📘 Étape 9 – Configuration de l’authentification Dovecot
# ------------------------------------------------------------------
# 🧠 Cette étape configure le fichier 10-auth.conf pour :
#  - Désactiver l'authentification en clair sans TLS
#  - Simplifier le format d'utilisateur en supprimant le domaine
#  - Ajouter le mécanisme LOGIN pour les anciens clients

ETAPE=9
echo -e "\n$(msg_step9_chap2_intro)"

# 💾 Sauvegarde du fichier 10-auth.conf
cp "$DOVECOT_CONF_10AUTH" "${DOVECOT_CONF_10AUTH}.original"
echo "$msg_step9_10auth_done"

# 🔧 Configuration du fichier
echo "$msg_step9_dovecot_disable_plaintext"
sed -i 's/^#\?disable_plaintext_auth.*/disable_plaintext_auth = yes/' "$DOVECOT_CONF_10AUTH"

echo "$msg_step9_dovecot_username_format"
sed -i 's/^#\?auth_username_format.*/auth_username_format = %n/' "$DOVECOT_CONF_10AUTH"

echo "$msg_step9_dovecot_mechanisms"
sed -i 's/^#\?auth_mechanisms.*/auth_mechanisms = plain login/' "$DOVECOT_CONF_10AUTH"

# ✅ Fin d’étape
echo -e "\n${msg_step_success_prefix} ${ETAPE} ${msg_step_success_suffix}"

# ------------------------------------------------------------------
# 📘 Étape 10 – Configuration TLS/SSL dans Dovecot
# ------------------------------------------------------------------
ETAPE=10
echo -e "\n$(msg_step10_chap2_intro)"

# 🔐 Configuration TLS de Dovecot
echo "$msg_step10_chap2_tls_config"
echo -e "\n$(msg_step10_chap2_tls_domain)"

# 💾 Sauvegarde avant modification
cp "$DOVECOT_CONF_10SSL" "${DOVECOT_CONF_10SSL}.original"
echo "$msg_step10_chap2_tls_backup_done"

# 🔧 Réécriture complète du fichier TLS
sudo bash -c "cat > $DOVECOT_CONF_10SSL <<EOF
ssl = required
ssl_cert = </etc/letsencrypt/live/$DOMAIN/fullchain.pem
ssl_key = </etc/letsencrypt/live/$DOMAIN/privkey.pem
ssl_prefer_server_ciphers = yes
ssl_min_protocol = TLSv1.2
EOF"

# ✅ Fin d’étape
echo -e "\n${msg_step_success_prefix} ${ETAPE} ${msg_step_success_suffix}"

# ------------------------------------------------------------------
# 📘 Étape 11 – Désactiver le provider FIPS d’OpenSSL (Ubuntu 22.04)
# ------------------------------------------------------------------
ETAPE=11
echo -e "\n$(msg_step11_chap2_intro)"

# 💾 Sauvegarde du fichier openssl.cnf
cp "$OPENSSL_CONF" "${OPENSSL_CONF}.original"
echo "$msg_step11_chap2_openssl_backup_done"

# 🛠️ Désactivation de la ligne "providers = provider_sect"
if grep -q "^providers *= *provider_sect" "$OPENSSL_CONF"; then
  sudo sed -i 's/^providers *= *provider_sect/#&/' "$OPENSSL_CONF"
  echo "$msg_step11_chap2_fips_disabled"
else
  echo "$msg_step11_chap2_already_commented"
fi

# 🔍 Vérification rapide de la config OpenSSL
echo -e "\n$(msg_step11_chap2_openssl_check)"
openssl version -a | grep "^FIPS"


# ✅ Fin d’étape
echo -e "\n${msg_step_success_prefix} ${ETAPE} ${msg_step_success_suffix}"

# ------------------------------------------------------------------
# 📘 Étape 12 – Configuration de l'authentification SASL (SMTP AUTH)
# ------------------------------------------------------------------
ETAPE=12
echo -e "\n$(msg_step12_chap2_intro)"

# 💾 Sauvegarde du fichier 10-master.conf
cp "$DOVECOT_CONF_10MASTER" "${DOVECOT_CONF_10MASTER}.original"
echo "$msg_step12_chap2_backup_done"

# 🔍 Vérification si le bloc auth est déjà configuré
if grep -q "/var/spool/postfix/private/auth" "$DOVECOT_CONF_10MASTER"; then
  echo "$msg_step12_chap2_already_configured"
else
  # 🧼 Suppression de l'ancien bloc 'service auth' (si présent)
  sudo sed -i '/^service auth {/,/^}/d' "$DOVECOT_CONF_10MASTER"

  # 📝 Ajout du bloc auth pour Postfix
  sudo bash -c "cat >> $DOVECOT_CONF_10MASTER << 'EOF'

service auth {
  unix_listener /var/spool/postfix/private/auth {
    mode = 0660
    user = postfix
    group = postfix
  }
}
EOF"

  echo "$msg_step12_chap2_sasl_auth_configured"
fi

echo -e "\n${msg_step_success_prefix} ${ETAPE} ${msg_step_success_suffix}"


# ------------------------------------------------------------------
# 📘 Étape 13 – Auto-renouvellement du certificat TLS via Certbot
# ------------------------------------------------------------------
ETAPE=13
echo -e "\n$(msg_step13_chap2_intro)"

# 📁 Sauvegarde du crontab root dans un fichier timestampé
CRONTAB_BACKUP="/root/crontab_root.original"
sudo crontab -l > "$CRONTAB_BACKUP" 2>/dev/null && echo "$msg_step13_chap2_crontab_backup"

# 🧪 Détection du serveur Web utilisé
if systemctl is-active --quiet apache2; then
  WEB_SERVER="apache2"
elif systemctl is-active --quiet nginx; then
  WEB_SERVER="nginx"
else
  WEB_SERVER=""
fi

# 📌 Ligne à insérer
CRON_LINE="@daily certbot renew --quiet && systemctl reload postfix dovecot $WEB_SERVER"

# 🔄 Ajout dans le crontab si la ligne n'existe pas déjà
if sudo crontab -l | grep -Fq "$CRON_LINE"; then
  echo "$msg_step13_chap2_already_present"
else
  (sudo crontab -l 2>/dev/null; echo "$CRON_LINE") | sudo crontab -
  echo "$msg_step13_chap2_added"
fi

# ------------------------------------------------------------------
# 📘 Étape 14 – 🔍 Vérification du renouvellement avec --dry-run
# ------------------------------------------------------------------
ETAPE=14

echo -e "\n$(msg_step13_chap2_dryrun_check)"
if certbot renew --dry-run &>/tmp/certbot_dryrun_test.log; then
  echo "$msg_step13_chap2_dryrun_success"
else
  echo "$msg_step13_chap2_dryrun_failed"
  echo -e "\n📄 $(msg_step13_chap2_log_hint): /tmp/certbot_dryrun_test.log"
fi


echo -e "\n${msg_step_success_prefix} ${ETAPE} ${msg_step_success_suffix}"

# ------------------------------------------------------------------
# 📘 Étape 15 – Redémarrage automatique de Dovecot via systemd
# ------------------------------------------------------------------

ETAPE=15
echo -e "\n$(msg_step14_chap2_intro)"

# 📁 Création du répertoire de surcharge systemd
SYSTEMD_DOVECOT_DIR="/etc/systemd/system/dovecot.service.d"
mkdir -p "$SYSTEMD_DOVECOT_DIR"

# 💾 Sauvegarde si fichier déjà présent
RESTART_CONF="${SYSTEMD_DOVECOT_DIR}/restart.conf"
if [[ -f "$RESTART_CONF" ]]; then
  cp "$RESTART_CONF" "${RESTART_CONF}.original"
  echo "$msg_step14_chap2_backup_done"
fi

# 🔧 Écriture du fichier restart.conf
echo "$msg_step14_chap2_create_file"
sudo bash -c "cat > '$RESTART_CONF' <<EOF
[Service]
Restart=always
RestartSec=5s
EOF"

# 🔄 Rechargement de systemd
echo "$msg_step14_chap2_reload_systemd"
sudo systemctl daemon-reload

# ✅ Fin d'étape
echo -e "\n${msg_step_success_prefix} ${ETAPE} ${msg_step_success_suffix}"


# ------------------------------------------------------------------
# 📘 Étape 16 – Redémarrage des services Postfix et Dovecot
# ------------------------------------------------------------------
# 🧠 Cette étape redémarre les deux services critiques du serveur mail :
#   ➤ Postfix (agent de transport SMTP)
#   ➤ Dovecot (serveur IMAP/POP3)
#
# Elle affiche également leur statut de fonctionnement via systemctl.
# ------------------------------------------------------------------
Étape =16
echo -e "\n$(msg_step8_chap2_intro)"

# 🔄 Redémarrage des services
echo "$msg_restart_services_chap2"
sudo systemctl restart postfix
sudo systemctl restart dovecot

# 🔍 Vérification de l’état des services
echo "$msg_status_postfix"
sudo systemctl status postfix --no-pager
echo "$msg_status_dovecot"
sudo systemctl status dovecot --no-pager

# ✅ Fin de l'étape
echo -e "\n${msg_step_success_prefix} ${ETAPE} ${msg_step_success_suffix}"
