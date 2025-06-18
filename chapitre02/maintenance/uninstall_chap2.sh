#!/bin/bash
# 🧹 Script de désinstallation – Chapitre 2 : Postfix & Dovecot
# pontarlier-informatique - osnetworking

# ============================================================
# 🌍 Sélection de la langue
# ============================================================
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
  echo "❌ Fichier de langue manquant : $LANG_FILE"
  exit 1
fi

# ============================================================
# 📥 Variables
# ============================================================
DOMAIN="domain.tld"

# Fichiers de configuration
DOVECOT_CONF="/etc/dovecot/dovecot.conf"
DOVECOT_CONF_10MAIL="/etc/dovecot/conf.d/10-mail.conf"
DOVECOT_CONF_10MASTER="/etc/dovecot/conf.d/10-master.conf"
DOVECOT_CONF_10AUTH="/etc/dovecot/conf.d/10-auth.conf"
DOVECOT_CONF_10SSL="/etc/dovecot/conf.d/10-ssl.conf"
SYSTEMD_RESTART_CONF="/etc/systemd/system/dovecot.service.d/restart.conf"
OPENSSL_CONF="/etc/ssl/openssl.cnf"
APACHE_SITE="/etc/apache2/sites-available/$DOMAIN.conf"
POSTFIX_MAIN_CF="/etc/postfix/main.cf"
POSTFIX_MASTER_CF="/etc/postfix/master.cf"

# Fichiers originaux
BACKUP_DIR="/opt/serv_mail/chapitre02/backup/${DOMAIN}"
ORIGINAL_DOVECOT_CONF="$BACKUP_DIR/dovecot.conf.original"
ORIGINAL_10MAIL="$BACKUP_DIR/10-mail.conf.original"
ORIGINAL_10MASTER="$BACKUP_DIR/10-master.conf.original"
ORIGINAL_10AUTH="$BACKUP_DIR/10-auth.conf.original"
ORIGINAL_10SSL="$BACKUP_DIR/10-ssl.conf.original"
ORIGINAL_MAIN_CF="$BACKUP_DIR/main.cf.original"
ORIGINAL_MASTER_CF="$BACKUP_DIR/master.cf.original"
ORIGINAL_OPENSSL_CONF="$BACKUP_DIR/openssl.cnf.original"

# ============================================================
# 🧼 Étape 1 – Restauration des fichiers de configuration
# ============================================================
ETAPE=1
echo -e "\n🔁 $msg_step1_restore_configs"

[[ -f "$ORIGINAL_DOVECOT_CONF" ]] && cp "$ORIGINAL_DOVECOT_CONF" "$DOVECOT_CONF"
[[ -f "$ORIGINAL_10MAIL" ]]         && cp "$ORIGINAL_10MAIL" "$DOVECOT_CONF_10MAIL"
[[ -f "$ORIGINAL_10MASTER" ]]       && cp "$ORIGINAL_10MASTER" "$DOVECOT_CONF_10MASTER"
[[ -f "$ORIGINAL_10AUTH" ]]         && cp "$ORIGINAL_10AUTH" "$DOVECOT_CONF_10AUTH"
[[ -f "$ORIGINAL_10SSL" ]]          && cp "$ORIGINAL_10SSL" "$DOVECOT_CONF_10SSL"
[[ -f "$ORIGINAL_MAIN_CF" ]]        && cp "$ORIGINAL_MAIN_CF" "$POSTFIX_MAIN_CF"
[[ -f "$ORIGINAL_MASTER_CF" ]]      && cp "$ORIGINAL_MASTER_CF" "$POSTFIX_MASTER_CF"
[[ -f "$ORIGINAL_OPENSSL_CONF" ]]   && cp "$ORIGINAL_OPENSSL_CONF" "$OPENSSL_CONF"

echo -e "\n${msg_step_success_prefix} ${ETAPE} ${msg_step_success_suffix}"

# ============================================================
# 🧼 Étape 1 bis – Restauration du crontab root (si sauvegardé)
# ============================================================
CRONTAB_BACKUP="${BACKUP_DIR}/crontab_root.original"
if [[ -f "$CRONTAB_BACKUP" ]]; then
  crontab "$CRONTAB_BACKUP"
  echo -e "🗂️ Crontab root restauré depuis ${CRONTAB_BACKUP}"
fi

# ============================================================
# 🧼 Étape 2 – Suppression redémarrage automatique Dovecot
# ============================================================
ETAPE=2
echo -e "\n🗑️ $msg_step2_remove_restart"
rm -f "$SYSTEMD_RESTART_CONF"
systemctl daemon-reexec
echo -e "\n${msg_step_success_prefix} ${ETAPE} ${msg_step_success_suffix}"

# ============================================================
# 🧼 Étape 3 – Suppression vhost Apache + Certbot
# ============================================================
ETAPE=3
echo -e "\n🗑️ $msg_step3_apache_certbot"
a2dissite "$DOMAIN.conf" 2>/dev/null
rm -f "$APACHE_SITE"
apt remove --purge -y certbot python3-certbot-apache apache2
echo -e "\n${msg_step_success_prefix} ${ETAPE} ${msg_step_success_suffix}"

# ============================================================
# 🧼 Étape 4 – Suppression paquets Dovecot (hors Postfix)
# ============================================================
ETAPE=4
echo -e "\n📦 $msg_step4_remove_dovecot"
apt remove --purge -y dovecot-core dovecot-imapd dovecot-pop3d dovecot-lmtpd
echo -e "\n${msg_step_success_prefix} ${ETAPE} ${msg_step_success_suffix}"

# ============================================================
# 🔄 Étape 5 – Redémarrage des services
# ============================================================
ETAPE=5
echo -e "\n🔄 $msg_step5_restart"
systemctl restart postfix
systemctl restart dovecot
echo -e "\n${msg_step_success_prefix} ${ETAPE} ${msg_step_success_suffix}"

# ============================================================
# ✅ Fin de désinstallation
# ============================================================
echo -e "\n$msg_uninstall_success"
