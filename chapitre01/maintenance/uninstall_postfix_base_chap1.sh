#!/bin/bash
# ==========================================================
# 🧹 Script de désinstallation – Chapitre 1 (Postfix Basique)
# 📦 Suppression des modifications effectuées par le chapitre 1
# 🧾 Version : 1.1
# 🧑💼 Auteur : pontarlier-informatique – osnetworking
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

# === 🟦 Messages d'introduction ===
msg_lang
msg_uninstall_intro

# === 📁 Variables ===
SERV_ROOT="/opt/serv_mail/chapitre_01"
MAIN_CF="/etc/postfix/main.cf"
ALIASES_FILE="/etc/aliases"
DATE_NOW=$(date +%F_%Hh%M)
BACKUP_DIR="${SERV_ROOT}/backup_uninstall"
mkdir -p "$BACKUP_DIR"

# === 💾 Sauvegardes ===
echo -e "\n📁 $msg_uninstall_backup"
cp -n "$MAIN_CF" "$BACKUP_DIR/main.cf.$DATE_NOW.bak"
cp -n "$ALIASES_FILE" "$BACKUP_DIR/aliases.$DATE_NOW.bak"

# === 🧽 Nettoyage /etc/hosts ===
echo -e "\n🧹 $msg_uninstall_clean_hosts"
sed -i '/127\.0\.1\.1.*mail\./d' /etc/hosts

# === 🧽 Nettoyage main.cf (myhostname, inet_protocols, message_size_limit)
echo -e "🧹 $msg_uninstall_clean_maincf"
sed -i '/^myhostname *=/d' "$MAIN_CF"
sed -i '/^inet_protocols *=/d' "$MAIN_CF"
sed -i '/^message_size_limit *=/d' "$MAIN_CF"

# === 🧽 Nettoyage fichier aliases
echo -e "🧹 $msg_uninstall_clean_aliases"
sed -i '/^postmaster:/d' "$ALIASES_FILE"
sed -i '/^root:/d' "$ALIASES_FILE"
newaliases

# === ❓ Suppression conditionnelle de Postfix
echo -e "\n❓ $msg_uninstall_ask_remove_postfix"
read -rp "➡️ [$msg_prompt_yes_no_default] : " REMOVE_POSTFIX
if [[ "$REMOVE_POSTFIX" =~ ^[YyOo]$ ]]; then
  if dpkg -l | grep -q "^ii  postfix "; then
    echo -e "\n📦 $msg_uninstall_removing"
    apt remove --purge -y postfix
    apt autoremove --purge -y
    echo -e "✅ $msg_uninstall_removed"
  else
    echo -e "⏭️ $msg_uninstall_not_installed"
  fi
else
  echo -e "⏭️ $msg_uninstall_skipped"
fi

# === ✅ Fin
echo -e "\n$msg_uninstall_success"
