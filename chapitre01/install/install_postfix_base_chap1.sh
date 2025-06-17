#!/bin/bash
# ============================================================
# 📬 Script d’installation Postfix de base – Serveur mail 2025
# 📘 Chapitre 1 – Installation Postfix (base)
# 🧾 Version : 1.0
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

# 🖥️ Affichage intro
echo -e "\n$msg_lang"
echo -e "$(msg_banner_chap1)"
echo -e "$(msg_intro_chap1)"
echo -e "\n$(msg_steps_chap1)\n"
echo -e "$(msg_steps_chap1_list)"


# === 🔧 Variables dynamiques ===

while [[ -z "$DOMAIN" ]]; do
  read -rp "🌐 $msg_prompt_domain : " DOMAIN
done

while [[ -z "$MAIL_FROM" ]]; do
  read -rp "📧 $msg_prompt_mail_from (ex: contact@${DOMAIN}) : " MAIL_FROM
done

while [[ -z "$MAIL_DEST" ]]; do
  read -rp "📨 $msg_prompt_mail_dest : " MAIL_DEST
done

read -rp "🌐 $msg_prompt_mail_fqdn (ex: mail.${DOMAIN}) : " MAIL_SERVER_FQDN
MAIL_SERVER_FQDN="${MAIL_SERVER_FQDN:-mail.${DOMAIN}}"  # Valeur par défaut si vide

echo -e "\n"

# === 📁 Variables interne (automatique) ===
SERV_ROOT="/opt/serv_mail/chapitre_01"
LOGS_DIR="${SERV_ROOT}/logs"
BACKUP_DIR="${SERV_ROOT}/backup/${DOMAIN}"
mkdir -p "$LOGS_DIR" "$BACKUP_DIR"

DATE_NOW="$(date +%F_%Hh%M)"
MAIN_CF="/etc/postfix/main.cf"
ALIASES_FILE="/etc/aliases"

# === ✅ Début des étapes ===
# ------------------------------------------------------------------
# 📘 Étape 1 – Initialisation du domaine principal
# ------------------------------------------------------------------

echo -e "$(msg_step1_title)"
echo -e "$(msg_step1_start)"

# 🔁 Afficher la valeur retenue
echo -e "✅ $(msg_step1_ok) : $DOMAIN"

# ------------------------------------------------------------------
# 🖋️ Étape 2 – Ajout du FQDN dans le fichier /etc/hosts
# ------------------------------------------------------------------

echo -e "$(msg_step2_title)"
echo -e "$(msg_step2_start)"

# 🧠 Construction du FQDN si absent
MAIL_SERVER_FQDN="${MAIL_SERVER_FQDN:-mail.${DOMAIN}}"

# 🔍 Vérifier si l'entrée existe déjà
if grep -q "127.0.1.1[[:space:]]\+${MAIL_SERVER_FQDN}" /etc/hosts; then
  echo -e "ℹ️  $(msg_step2_exists): ${MAIL_SERVER_FQDN}"
else
  # 📁 Sauvegarde de /etc/hosts avant modification
  cp /etc/hosts "/etc/hosts.bak_${DATE_NOW}"

  # ➕ Ajout de la ligne
  echo "127.0.1.1    ${MAIL_SERVER_FQDN}" >> /etc/hosts
  echo -e "✅ $(msg_step2_added): ${MAIL_SERVER_FQDN} → /etc/hosts"
fi

# ------------------------------------------------------------------
# 🖥️ Étape 3 – Vérification du hostname système
# ------------------------------------------------------------------

echo -e "$(msg_step3_title)"
echo -e "$(msg_step3_start)"

CURRENT_HOSTNAME=$(hostnamectl --static)
echo -e "\n🔍 $(msg_step3_current): $CURRENT_HOSTNAME"

read -rp "➡️ $(msg_step3_prompt) [$MAIL_SERVER_FQDN] : " NEW_HOSTNAME
NEW_HOSTNAME=${NEW_HOSTNAME:-$MAIL_SERVER_FQDN}

# 🔐 Vérification du format du hostname
if [[ ! "$NEW_HOSTNAME" =~ ^[a-z0-9.-]+$ ]]; then
  echo -e "\n$(msg_step3_hostname_invalid)"
  echo -e "$(msg_step3_hostname_allowed)"
  echo -e "$(msg_step3_hostname_kept): $CURRENT_HOSTNAME"
else
  if [[ "$CURRENT_HOSTNAME" != "$NEW_HOSTNAME" ]]; then
    hostnamectl set-hostname "$NEW_HOSTNAME"
    echo -e "✅ $(msg_step3_set): $NEW_HOSTNAME"

    # 📝 Log
    echo "[$DATE_NOW] hostnamectl set-hostname $NEW_HOSTNAME (ancien: $CURRENT_HOSTNAME)" >> "$LOGS_DIR/hostname.log"
  else
    echo -e "✅ $(msg_step3_ok): $CURRENT_HOSTNAME"
  fi
fi

# ------------------------------------------------------------------
# 🌐 Étape 4 – Vérification des enregistrements DNS
# ------------------------------------------------------------------

echo -e "$(msg_step4_title)"
echo -e "$(msg_step4_start)"

# 🔎 Rappel des enregistrements à créer chez votre registrar
echo -e "\n🌐 $(msg_step4_dns_reminder):"
echo -e "\n🧾 $(msg_step4_dns_examples):\n"

echo -e "🔹 MX RECORD"
echo -e "$(msg_step4_mx_example)"

echo -e "\n🔹 SPF RECORD"
echo -e "\n$(msg_step4_spf_example)"

echo -e "\n🔹 DMARC RECORD"
echo -e "\n$(msg_step4_dmarc_example)\n"

# ⏸️ Pause pour que l'utilisateur configure ses enregistrements DNS
read -rp "$(msg_step4_wait_user) " _

# 🧪 Tests de propagation DNS
echo -e "\n🧪 $(msg_step4_testing_dns)"

echo -e "\n$(msg_step4_mx_title) ${DOMAIN} :"
dig +short MX "${DOMAIN}"

echo -e "\n$(msg_step4_spf_title) ${DOMAIN} :"
dig +short TXT "${DOMAIN}" | grep spf || echo "$(msg_step4_spf_missing)"

echo -e "\n$(msg_step4_dmarc_title) ${DOMAIN} :"
dig +short TXT "_dmarc.${DOMAIN}" || echo "$(msg_step4_dmarc_missing)"

# Pause finale
read -rp "$(msg_step4_continue)" _

echo -e "\n$(msg_step4_success)"


# ------------------------------------------------------------------
# 🧰 Étape 5 – Mise à jour du système - installation postfix
# ------------------------------------------------------------------

echo -e "$(msg_step5_title)"
echo -e "$(msg_step5_start)"

# 🔄 Mise à jour des paquets
echo -e "\n🔄 $(msg_step5_update)"
apt update

# ℹ️ Instructions d'installation interactive
echo -e "\n🛠️ $(msg_step5_config_info)"
echo -e "$(msg_step5_config_1)"
echo -e "$(msg_step5_config_2): ${DOMAIN}"

# 📦 Installation de Postfix
echo -e "\n📦 $(msg_step5_installing)"
apt install -y postfix

# 🧾 Vérification de la version de Postfix
echo -e "\n📦 $(msg_step5_check_version)"
postconf mail_version

# 🔌 Vérification que le port 25 est ouvert
echo -e "\n🔌 $(msg_step5_check_port)"
ss -lnpt | grep master || echo "$(msg_step5_port_warning)"

# 📁 Liste des binaires Postfix
echo -e "\n📁 $(msg_step5_check_binaries)"
dpkg -L postfix | grep /usr/sbin/

echo -e "\n$(msg_step5_success)"

# ------------------------------------------------------------------
# 🔥 Étape 6 – Vérification de l’état du pare-feu UFW
# ------------------------------------------------------------------

echo -e "\n$(msg_step6_title)"
echo -e "$(msg_step6_start)"

# Vérifie si UFW est installé
if ! command -v ufw >/dev/null 2>&1; then
  echo -e "⚠️  $(msg_ufw_not_installed)"
else
  echo -e "\n🔍 ufw status:"
  ufw status verbose

  # Vérifie si UFW est activé
  if ufw status | grep -q "Status: active"; then
    echo -e "\n$(msg_active_ufw)"
    read -rp "➡️  $(msg_ufw_keep_enabled) " UFW_KEEP
    if [[ "$UFW_KEEP" =~ ^[Nn]$ ]]; then
      echo -e "$(msg_ufw_disabling)"
      ufw disable
      echo -e "$(msg_ufw_disabled)"
    fi
  else
    echo -e "\n$(msg_inactive_ufw)"
    read -rp "➡️  $(msg_enable_ufw) " ENABLE_UFW
    if [[ "$ENABLE_UFW" =~ ^[OoYy]$ ]]; then
      echo -e "\n$(msg_open_ports)"
      ufw allow OpenSSH
      ufw allow 25/tcp
      ufw allow 587/tcp
      ufw allow 465/tcp
      ufw --force enable
      echo -e "\n$(msg_open_ports_complete_chap2)"
    else
      echo -e "$(msg_ufw_left_disabled)"
    fi
  fi
fi

# Pause finale
read -rp "$(msg_press_enter)" _
echo -e "$(msg_step6_success)"


# ------------------------------------------------------------------
# 📘 Étape 7 – Test de connexion sortante vers port 25 (SMTP)
# ------------------------------------------------------------------

echo -e "$(msg_step7_title)"
echo -e "$(msg_step7_start)"

# 🔎 Test de connexion sortante vers Gmail
echo -e "\n📤 $(msg_step7_smtp_test)"
echo -e "$(msg_step7_explanation)\n"

# Installation de telnet si absent
if ! command -v telnet >/dev/null; then
  echo -e "⚠️ $(msg_step7_telnet_missing)"
  apt install -y telnet
fi

# Lancer le test
telnet smtp.gmail.com 25

# ✅ Message final
echo -e "$(msg_step7_success)"


# ------------------------------------------------------------------
# 📘 Étape 8 – Envoi d’un e-mail de test avec Postfix (sendmail)
# ------------------------------------------------------------------

echo -e "$(msg_step8_title)"
echo -e "$(msg_step8_start)"

# 📤 Envoi d’un e-mail de test avec sendmail
echo -e "\n📤 $(msg_step8_test_sendmail)"
echo "📝 $(msg_step8_content)"
echo -e "\n➡️ $(msg_step8_dest): $MAIL_DEST"

# Envoi réel
echo "test email" | sendmail "$MAIL_DEST"

# ⏳ Petite pause pour laisser le temps au log de s’écrire
sleep 2

# 📂 Vérification de la boîte aux lettres locale
MAILBOX_DIR=$(postconf -h mail_spool_directory)
echo -e "\n📂 $(msg_step8_local_mailbox): $MAILBOX_DIR"
ls -l "$MAILBOX_DIR"

# 📁 Vérification des logs postfix
echo -e "\n📝 $(msg_step8_log_hint)"
tail -n 20 /var/log/mail.log | grep "$MAIL_DEST" | grep -i 'status='

# ✅ Vérification automatique du succès
if grep "$MAIL_DEST" /var/log/mail.log | grep -qi 'status=sent'; then
  echo -e "\n✅ $(msg_step8_verification_ok)"
else
  echo -e "\n❌ $(msg_step8_verification_fail)"
fi

# Pause finale
read -rp "$(msg_press_enter)" _

echo -e "$(msg_step8_success)"

# ------------------------------------------------------------------
# 📘 Étape 9 – Installation de Mailutils et test d’envoi local
# ------------------------------------------------------------------

echo -e "$(msg_step9_title)"
echo -e "$(msg_step9_start)"

# 📦 Installation de Mailutils (MUA en ligne de commande)
echo -e "\n📦 $(msg_step9_installing)"
apt install -y mailutils &>/dev/null

# 📤 Envoi d’un e-mail local avec Postfix
echo -e "\n📤 $(msg_step9_sending)"
echo -e "➡️  $MAIL_DEST"
echo -e "✉️  $(msg_step9_subject_display): $msg_step9_mail_subject"

echo -e "$msg_step9_mail_body" | mail -s "$msg_step9_mail_subject" "$MAIL_DEST" -- -f "$MAIL_FROM"

# 📥 Vérification réception
read -rp "📬 $(msg_step9_ask_received) (y/N) : " RECEIVED
if [[ "$RECEIVED" =~ ^[Yy]$ ]]; then
  echo "✅ OK : $(msg_step9_received)"
else
  echo "⚠️ $(msg_step9_not_received)"
fi

echo -e "$(msg_step9_success)"


# ------------------------------------------------------------------
# 📘 Étape 10 – Définir la taille maximale des e-mails (message_size_limit)
# ------------------------------------------------------------------

echo -e "$(msg_step10_title)"
echo -e "$(msg_step10_start)"

# 📏 Récupération des valeurs actuelles
CURRENT_MSG_LIMIT=$(postconf -h message_size_limit)
CURRENT_BOX_LIMIT=$(postconf -h mailbox_size_limit)

# 📏 Affichage lisible (en octets + Mo)
echo -e "\n📏 $(msg_step10_current): $CURRENT_MSG_LIMIT octets ($(($CURRENT_MSG_LIMIT / 1048576)) Mo)"
echo -e "📥 $(msg_step10_box_limit): $CURRENT_BOX_LIMIT octets ($(($CURRENT_BOX_LIMIT / 1048576)) Mo)"

# 🧠 Demande d’une nouvelle valeur
read -rp "📏 $(msg_step10_ask_size) (ex: 52428800 pour 50 Mo) [Entrée=inchangé] : " SIZE_LIMIT

if [[ -n "$SIZE_LIMIT" ]]; then
  if [[ "$CURRENT_BOX_LIMIT" -ne 0 && "$SIZE_LIMIT" -gt "$CURRENT_BOX_LIMIT" ]]; then
    echo -e "\n$(msg_step10_warn_box)"
    read -rp "❓ $(msg_step10_confirm_apply) (y/N) : " CONFIRM
    [[ "$CONFIRM" != [Yy] ]] && echo "❌ $(msg_step10_abort)" && exit 1
  fi
  postconf -e "message_size_limit = $SIZE_LIMIT"
  echo -e "✅ $(msg_step10_applied): $SIZE_LIMIT octets"
else
  echo -e "ℹ️ $(msg_step10_default): $CURRENT_MSG_LIMIT"
fi

# 🔄 Rechargement Postfix
systemctl restart postfix && echo "🔄 Postfix redémarré."

echo -e "$(msg_step10_success)"


# ------------------------------------------------------------------
# 📘 Étape 11 – Définir myhostname dans Postfix (FQDN recommandé)
# ------------------------------------------------------------------

echo -e "$(msg_step11_title)"

# 💡 Suggestion : utiliser un FQDN de type mail.domain.tld
SUGGESTED_HOSTNAME="mail.${DOMAIN}"

# 🔍 Récupérer la valeur actuelle dans la conf Postfix
CURRENT_HOSTNAME=$(postconf -h myhostname)
echo -e "\n🔍 $(msg_step11_current): $CURRENT_HOSTNAME"

# ✍️ Saisie interactive avec valeur par défaut proposée
read -rp "➡️ $(msg_step11_prompt) [$SUGGESTED_HOSTNAME] : " NEW_MYHOSTNAME
NEW_MYHOSTNAME=${NEW_MYHOSTNAME:-$SUGGESTED_HOSTNAME}

# ⚠️ Avertir si l’utilisateur saisit un domaine apex
if [[ "$NEW_MYHOSTNAME" == "$DOMAIN" ]]; then
  echo -e "\n⚠️  $(msg_step11_warn_apex): ${NEW_MYHOSTNAME}"
  echo -e "👉 $(msg_step11_suggest_fqdn): mail.${DOMAIN}\n"
fi

# 🛠️ Mise à jour dans le fichier main.cf (avec sauvegarde préalable)
cp "$MAIN_CF" "$MAIN_CF.bak"
sed -i '/^myhostname *=/d' "$MAIN_CF"
echo -e "\n# $(msg_step11_comment_header)\nmyhostname = $NEW_MYHOSTNAME" >> "$MAIN_CF"

echo -e "✅ $(msg_step11_applied): $NEW_MYHOSTNAME"

echo -e "$(msg_step11_success)"



# ------------------------------------------------------------------
# 📘 Étape 12 – Création des alias mail requis (RFC 2142)
# ------------------------------------------------------------------

echo -e "$(msg_step12_title)"

# 🔒 Sauvegarde préalable
cp "$ALIASES_FILE" "${ALIASES_FILE}.bak"

# ✅ postmaster → root (si absent)
if ! grep -q "^postmaster:" "$ALIASES_FILE"; then
  echo "postmaster: root" >> "$ALIASES_FILE"
  echo -e "$(msg_step12_add_postmaster)"
fi

# 👤 root → utilisateur réel (non-root recommandé)
read -rp "👤 $(msg_step12_prompt_alias) (ex: serv2025) : " ALIAS_USER
if [[ -n "$ALIAS_USER" ]]; then
  sed -i "s/^root:.*/root: ${ALIAS_USER}/" "$ALIASES_FILE"
  echo -e "$(msg_step12_root_modified) ${ALIAS_USER}"
else
  echo -e "$(msg_step12_no_change)"
fi

# 🔃 Génération de la table des alias
newaliases && echo -e "$(msg_step12_newaliases)"

echo -e "$(msg_step12_success)"


# ------------------------------------------------------------------
# 📘 Étape 13 – Configuration des protocoles IP (IPv4 / IPv6)
# ------------------------------------------------------------------

echo -e "$(msg_step13_title)"

# 🔍 Affichage de la valeur actuelle
CURRENT_PROTO=$(postconf -h inet_protocols)
echo -e "\n🔍 $(msg_step13_current): $CURRENT_PROTO"

# 🧭 Instructions utilisateur
echo -e "\n🌐 $(msg_step13_explain)"
echo -e "   1) IPv4 uniquement"
echo -e "   2) IPv6 uniquement"
echo -e "   3) IPv4 + IPv6 (valeur par défaut)"
read -rp "➡️  $(msg_step13_prompt_choice) [$(msg_press_enter_word)=$(msg_step13_keep_default)] : " PROTO_CHOICE

# 🔧 Application du choix
case "$PROTO_CHOICE" in
  1)
    sed -i '/^inet_protocols *=/d' "$MAIN_CF"
    echo -e "\n# 🖧 $(msg_step13_comment)" >> "$MAIN_CF"
    echo "inet_protocols = ipv4" >> "$MAIN_CF"
    echo "$(msg_step13_set_ipv4)"
    ;;
  2)
    sed -i '/^inet_protocols *=/d' "$MAIN_CF"
    echo -e "\n# 🖧 $(msg_step13_comment)" >> "$MAIN_CF"
    echo "inet_protocols = ipv6" >> "$MAIN_CF"
    echo "$(msg_step13_set_ipv6)"
    ;;
  3)
    sed -i '/^inet_protocols *=/d' "$MAIN_CF"
    echo -e "\n# 🖧 $(msg_step13_comment)" >> "$MAIN_CF"
    echo "inet_protocols = all" >> "$MAIN_CF"
    echo "$(msg_step13_set_all)"
    ;;
  *)
    echo "$(msg_step13_keep): $CURRENT_PROTO"
    ;;
esac

# 🔄 Redémarrage Postfix
echo -e "\n🔁 $(msg_step13_restart)"
systemctl restart postfix

# 📊 Vérification de l’état
systemctl status postfix --no-pager | grep -E "Active|Loaded"

echo -e "$(msg_step13_success)"


# ------------------------------------------------------------------
# 📘 Étape 14 – Mise à jour de Postfix (préserver la configuration)
# ------------------------------------------------------------------

echo -e "\n📦 $(msg_step14_update_notice)"
echo -e "   $(msg_step14_upgrade_tip1)"
echo -e "   $(msg_step14_upgrade_tip2)"

apt update && apt upgrade -y

echo -e "$(msg_step14_success)"


# ------------------------------------------------------------------
# 📘 Étape 15 – Sauvegarde main.cf (non destructif)
# ------------------------------------------------------------------
echo -e "$(msg_step15_title)"
cp "$MAIN_CF" "${BACKUP_DIR}/main.cf.orig_${DATE_NOW}"
echo -e "$(msg_step15_success)"


# ------------------------------------------------------------------
# 📘 Étape 16 – Redémarrage Postfix
# ------------------------------------------------------------------
echo -e "$(msg_step16_title)"
systemctl restart postfix
systemctl status postfix --no-pager
echo -e "$(msg_step16_success)"