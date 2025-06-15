#!/bin/bash
# ============================================================
# ♻️ Script de désinstallation SPF & DKIM – Chapitre 4
# 📅 Projet : Serveur Mail 2025
# 🧾 Version : 1.2
# 🧑💼 Auteur : osnetworking / pontarlier-informatique
# ============================================================

# ===================================================
# 🌍 Bloc de sélection de la langue (multi-langue)
# ✅ Full dynamique – pontarlier-informatique
# ===================================================

LANG="en"

echo -e "\n🌐 Choose your language / Choisissez votre langue :"
echo "1) Français"
echo "2) English"
read -rp "➡️  Your choice / Votre choix [1-2] : " LANG_CHOICE

case "$LANG_CHOICE" in
  2|"en"|"EN") LANG="en" ;;
  1|"fr"|"FR"|*) LANG="fr" ;;
esac

LANG_FILE="/opt/serv_mail/lang/${LANG}.sh"
if [[ -f "$LANG_FILE" ]]; then
  source "$LANG_FILE"
else
  echo "❌ Error: missing language file: $LANG_FILE"
  exit 1
fi

msg_lang

# ===================================================
# 📋 Liste des variables
# ===================================================

OPENDKIM_CONF="/etc/opendkim.conf"
OPENDKIM_DEFAULT="/etc/default/opendkim"
POSTFIX_MAIN_CF="/etc/postfix/main.cf"
POSTFIX_MASTER_CF="/etc/postfix/master.cf"
LOG_DIR="/var/log/opendkim"
SOCKET_PATH="/var/spool/postfix/opendkim/opendkim.sock"
BACKUP_PATTERN=".bak_*"

# === 📘 Introduction ===
msg_revert_intro
sleep 1

# === 🧹 Nettoyage fichiers de configuration .bak ===
echo "🧽 Suppression des fichiers de sauvegarde .bak générés..."
find /etc/opendkim -type f -name "*.bak_*" -exec rm -f {} \;

# === 🧹 Nettoyage du fichier main.cf (SPF + DKIM) ===
echo "🧹 Nettoyage des directives SPF & DKIM dans $POSTFIX_MAIN_CF..."

# Suppression directives SPF
postconf -X policyd-spf_time_limit
postconf -X smtpd_recipient_restrictions

# Suppression directives DKIM
postconf -X milter_default_action
postconf -X milter_protocol
postconf -X smtpd_milters
postconf -X non_smtpd_milters

# === 🧹 Nettoyage du fichier master.cf ===
echo "🧹 Nettoyage du fichier $POSTFIX_MASTER_CF..."
sed -i '/^# Postfix to start the SPF policy daemon/,+1d' "$POSTFIX_MASTER_CF"
sed -i '/^ *user=policyd-spf /d' "$POSTFIX_MASTER_CF"

# === 📦 Suppression des paquets (à la fin) ===
echo -e "\n📦 Suppression des paquets OpenDKIM et SPF Policy Agent..."
apt-get remove --purge -y opendkim opendkim-tools postfix-policyd-spf-python

# === ⚠️ AVERTISSEMENT FINAL ===
echo -e "\n\e[1;31m"
echo "██████████████████████████████████████████████████████████████████"
echo "⚠️  ATTENTION : Ce script ne supprime pas 100% des modifications."
echo "🛠️  Veuillez vérifier manuellement les fichiers suivants :"
echo "    → $POSTFIX_MAIN_CF"
echo "    → $POSTFIX_MASTER_CF"
echo "    → /etc/opendkim/ (si encore présent)"
echo "██████████████████████████████████████████████████████████████████"
echo
echo "============================================================"
echo "                   ⚠️  AVERTISSEMENT                       "
echo "============================================================"
echo
echo "██████████████████████████████████████████████████████████████████"
echo "⚠️  CE SCRIPT PEUT SUPPRIMER DES FICHIERS CRITIQUES"
echo "⚠️  AUCUNE RESPONSABILITÉ N'EST ENGAGÉE EN CAS DE PERTE DE DONNÉES"
echo "██████████████████████████████████████████████████████████████████"
echo -e "\e[0m"

# === ✅ Résumé final ===
echo
msg_revert_warning
msg_revert_done

exit 0
