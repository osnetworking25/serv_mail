#!/bin/bash
# ============================================================
# ♻️ Script de restauration SPF & DKIM – Chapitre 4 – Version 1.1
# 🧑‍💼 Auteur : osnetworking / pontarlier-informatique
# 📅 Dernière mise à jour : 11/06/2025
# ============================================================

echo "🌐 Choisissez votre langue / Choose your language :"
read -rp "fr (Français) / en (English) : " LANG_CHOICE
LANG=${LANG_CHOICE:-fr}

source "/opt/serv_mail/lang/${LANG}.sh"

echo
msg_revert_intro
echo

echo "📦 Suppression des paquets OpenDKIM et SPF Policy Agent..."
apt-get remove --purge -y opendkim opendkim-tools postfix-policyd-spf-python >/dev/null

echo "🗑️ Suppression des dossiers de configuration et clés..."
rm -rf /etc/opendkim /etc/opendkim.conf /etc/default/opendkim

echo "🔧 Nettoyage de Postfix (milter, main.cf, master.cf)..."
postconf -X milter_default_action
postconf -X milter_protocol
postconf -X smtpd_milters
postconf -X non_smtpd_milters

# Nettoyage manuel de main.cf (policyd-spf)
sed -i '/policyd-spf_time_limit/d' /etc/postfix/main.cf
sed -i '/check_policy_service unix:private\/policyd-spf/d' /etc/postfix/main.cf
sed -i '/^smtpd_recipient_restrictions/,/^$/s/^ *check_policy_service .*//g' /etc/postfix/main.cf

# Nettoyage du master.cf (policyd-spf)
sed -i '/^policyd-spf[[:space:]]\+unix/d' /etc/postfix/master.cf
sed -i '/argv=\/usr\/bin\/policyd-spf/d' /etc/postfix/master.cf

# Autoremove final pour nettoyer les dépendances
echo "🧹 Suppression des dépendances inutiles restantes..."
apt autoremove --purge -y >/dev/null

# Export & Backup : Suppression facultative
ask_optional_cleanup

echo
msg_revert_warning
msg_revert_done
