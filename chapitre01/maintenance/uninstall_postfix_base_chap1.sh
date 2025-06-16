#!/bin/bash
# ==========================================================
# 🧹 Script de désinstallation – Chapitre 1 (Postfix Basique)
# 📦 Suppression des modifications effectuées par le chapitre 1
# 🧾 Version : 1.0
# 🧑💼 Auteur : pontarlier-informatique
# ==========================================================

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
msg_uninstall_intro

# === 📁 Variables ===
SERV_ROOT="/opt/serv_mail/chapitre_01"
MAIN_CF="/etc/postfix/main.cf"
ALIASES_FILE="/etc/aliases"
DATE_NOW=$(date +%F_%Hh%M)
BACKUP_DIR="${SERV_ROOT}/backup_uninstall"

mkdir -p "$BACKUP_DIR"

# === 📦 Sauvegardes ===
cp -n "$MAIN_CF" "$BACKUP_DIR/main.cf.$DATE_NOW.bak"
cp -n "$ALIASES_FILE" "$BACKUP_DIR/aliases.$DATE_NOW.bak"

# === 🧽 Nettoyage fichier /etc/hosts ===
sed -i '/127\.0\.1\.1.*mail\./d' /etc/hosts

# === 🧽 Nettoyage main.cf (myhostname, inet_protocols, message_size_limit)
sed -i '/^myhostname *=/d' "$MAIN_CF"
sed -i '/^inet_protocols *=/d' "$MAIN_CF"
sed -i '/^message_size_limit *=/d' "$MAIN_CF"

# === 🧽 Nettoyage fichier aliases
sed -i '/^postmaster:/d' "$ALIASES_FILE"
sed -i '/^root:/d' "$ALIASES_FILE"
newaliases

# === 🧼 Suppression Postfix si demandé
read -rp "❓ $(msg_uninstall_ask_remove_postfix) (y/N): " REMOVE_POSTFIX
if [[ "$REMOVE_POSTFIX" =~ ^[Yy]$ ]]; then
  apt remove --purge -y postfix
  apt autoremove --purge -y
  echo "✅ Postfix $(msg_uninstall_removed)"
else
  echo "⏭️ Postfix $(msg_uninstall_skipped)"
fi

msg_uninstall_success
