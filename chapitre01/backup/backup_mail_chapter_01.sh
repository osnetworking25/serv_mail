#!/bin/bash
# =====================================================================================================================
# 📂 Script de sauvegarde – Chapitre 1 – Serveur mail 2025
# 📘 Objectif : sauvegarder les fichiers essentiels de la configuration de base Postfix (et autres éléments Chapitre 1)
# 🧑‍💼 Auteur : pontarlier-informatique / Osnetworking
# 🗓️ Version : 1.1 – 2025-06-17
# =====================================================================================================================

# ===================================================
# 🌍 Bloc de sélection de la langue (multi-langue)
# ✅ Full dynamique – pontarlier-informatique
# ===================================================

LANG="en"
echo -e "\n🌐 Choose your language / Choisissez votre langue :"
echo "1) Français"
echo "2) English"
read -rp "➞️  Your choice / Votre choix [1-2] : " LANG_CHOICE
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

msg_lang_chap1
msg_banner_chap1
msg_intro_chap1
echo -e "\n"

# === 🔧 Domaine concerné ===
while [[ -z "$DOMAIN" ]]; do
  read -rp "🌐 ${msg_prompt_domain_chap1} : " DOMAIN
done

# === 📁 Arborescence projet (Chapitre 01) ===
SERV_ROOT="/opt/serv_mail/chapitre_01"
LOGS_DIR="${SERV_ROOT}/logs"
BACKUP_DIR="${SERV_ROOT}/backup/${DOMAIN}"
mkdir -p "$LOGS_DIR" "$BACKUP_DIR"

DATE_NOW="$(date +%F_%Hh%M)"
BACKUP_FILE="${BACKUP_DIR}/backup_mail_chap1_${DATE_NOW}.tar.gz"

# === 🛠️ Fichiers à sauvegarder ===
MAIN_CF="/etc/postfix/main.cf"
ALIASES_FILE="/etc/aliases"

echo "$msg_backup_start_chap1"

tar -czf "$BACKUP_FILE" \
  /etc/hosts \
  /etc/hostname \
  /etc/resolv.conf \
  /etc/postfix \
  /etc/mailname \
  "$MAIN_CF" \
  "$ALIASES_FILE" \
  2>> "$LOGS_DIR/backup_errors.log"

if [[ $? -eq 0 ]]; then
  echo "✅ ${msg_backup_success_chap1}"
  echo "$BACKUP_FILE"
else
  echo "❌ ${msg_backup_fail_chap1}"
fi

# === 🔍 Fin ===
echo "$msg_end_chap1"
