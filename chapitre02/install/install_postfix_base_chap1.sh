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

msg_lang
msg_banner
msg_intro
echo -e "\n"

# === 🔧 Variables dynamiques principales ===

while [[ -z "$DOMAIN" ]]; do
  read -rp "🌐 $(msg_prompt_domain) : " DOMAIN
done

while [[ -z "$MAIL_FROM" ]]; do
  read -rp "📧 $(msg_prompt_mail_from) (ex: contact@${DOMAIN}) : " MAIL_FROM
done

while [[ -z "$MAIL_DEST" ]]; do
  read -rp "📨 $(msg_prompt_mail_dest) : " MAIL_DEST
done

while [[ -z "$MAIL_SERVER_FQDN" ]]; do
  read -rp "🌐 $(msg_prompt_mail_fqdn) (ex: mail.${DOMAIN}) : " MAIL_SERVER_FQDN
done

echo -e "\n"

# === 📁 Arborescence projet (Chapitre 1) ===
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

msg_step1_title
msg_step1_start

# 🌐 Demander le nom de domaine principal (ex: domain.tld)
while [[ -z "$DOMAIN" ]]; do
  read -rp "🌐 $(msg_step1_prompt) : " DOMAIN
done

# 🔁 Afficher la valeur retenue
echo -e "✅ $(msg_step1_ok) : $DOMAIN"

# ------------------------------------------------------------------
# 🖋️ Étape 2 – Ajout du FQDN dans le fichier /etc/hosts
# ------------------------------------------------------------------

msg_step2_title
msg_step2_start

# 🧠 Construction du FQDN
MAIL_SERVER_FQDN="mail.${DOMAIN}"

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

msg_step3_title
msg_step3_start

CURRENT_HOSTNAME=$(hostnamectl --static)
echo -e "\n🔍 $(msg_step3_current): $CURRENT_HOSTNAME"

read -rp "➡️ $(msg_step3_prompt) [$MAIL_SERVER_FQDN] : " NEW_HOSTNAME
NEW_HOSTNAME=${NEW_HOSTNAME:-$MAIL_SERVER_FQDN}

if [[ "$CURRENT_HOSTNAME" != "$NEW_HOSTNAME" ]]; then
  hostnamectl set-hostname "$NEW_HOSTNAME"
  echo -e "✅ $(msg_step3_set): $NEW_HOSTNAME"

  # 📝 Log facultatif (utile en entreprise ou environnement de déploiement)
  echo "[$DATE_NOW] hostnamectl set-hostname $NEW_HOSTNAME (ancien: $CURRENT_HOSTNAME)" >> "$LOGS_DIR/hostname.log"

else
  echo -e "✅ $(msg_step3_ok): $CURRENT_HOSTNAME"
fi

# ------------------------------------------------------------------
# 🌐 Étape 4 – Vérification des enregistrements DNS
# ------------------------------------------------------------------

msg_step4_title
msg_step4_start

# 🔎 Rappel des enregistrements à créer chez votre registrar
echo -e "\n🌐 $(msg_step4_dns_reminder):"
echo -e "\n🧾 $(msg_step4_dns_examples):\n"

echo -e "🔹 MX RECORD"
echo -e "   @      300 IN MX 10 mail.${DOMAIN}"

echo -e "\n🔹 SPF RECORD"
echo -e "   @      300 IN TXT \"v=spf1 mx -all\""

echo -e "\n🔹 DMARC RECORD"
echo -e "   _dmarc 300 IN TXT \"v=DMARC1; p=none; rua=mailto:dmarc@${DOMAIN}; pct=100\"\n"

# ⏸️ Pause pour que l'utilisateur configure ses enregistrements DNS
read -rp "⏸️  Appuyez sur [Entrée] une fois les DNS ajoutés chez votre registrar... " _

# 🧪 Tests de propagation DNS
echo -e "\n🧪 $(msg_step4_testing_dns)"

echo -e "\n🔍 Champ MX pour ${DOMAIN} :"
dig +short MX "${DOMAIN}"

echo -e "\n🔍 Champ SPF pour ${DOMAIN} :"
dig +short TXT "${DOMAIN}" | grep spf || echo "⚠️  Aucun SPF trouvé."

echo -e "\n🔍 Champ DMARC pour ${DOMAIN} :"
dig +short TXT "_dmarc.${DOMAIN}" || echo "⚠️  Aucun enregistrement DMARC trouvé."

# Pause finale
read -rp "⏸️  Appuyez sur [Entrée] pour continuer..." _

msg_step4_success


# ------------------------------------------------------------------
# 🧰 Étape 5 – Mise à jour du système - installation postfix
# ------------------------------------------------------------------

msg_step5_title
msg_step5_start

# 🔄 Mise à jour des paquets
echo -e "\n🔄 $(msg_step5_update)"
apt update

# ℹ️ Instructions d'installation interactive
echo -e "\n🛠️ $(msg_step5_config_info)"
echo -e "   ➤ 1. Sélectionnez : « Site Internet »"
echo -e "   ➤ 2. Entrez votre domaine principal : ${DOMAIN}"

# 📦 Installation de Postfix
echo -e "\n📦 $(msg_step5_installing)"
apt install -y postfix

# 🧾 Vérification de la version de Postfix
echo -e "\n📦 $(msg_step5_check_version):"
postconf mail_version

# 🔌 Vérification que le port 25 est ouvert
echo -e "\n🔌 $(msg_step5_check_port):"
ss -lnpt | grep master || echo "❌ Postfix ne semble pas écouter sur le port 25."

# 📁 Liste des binaires Postfix
echo -e "\n📁 $(msg_step5_check_binaries):"
dpkg -L postfix | grep /usr/sbin/

msg_step5_success

# ------------------------------------------------------------------
# 🔥 Étape 6 – Vérification de l’état du pare-feu
# ------------------------------------------------------------------

msg_step6_title
msg_step6_start

# Vérifie si ufw est installé
if command -v ufw >/dev/null; then
  echo -e "\n🔎 ufw status:"
  ufw status verbose
else
  echo -e "⚠️  UFW n’est pas installé. Aucun pare-feu UFW actif."
fi

# Pause informative
read -rp "⏸️  $(msg_step5_confirm_continue) [Entrée] " _
msg_step6_success

# ------------------------------------------------------------------
# 📘 Étape 7 – Test de connexion sortante vers port 25 (SMTP)
# ------------------------------------------------------------------

sg_step7_title
msg_step7_start

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

msg_step7_success


# ------------------------------------------------------------------
# 📘 Étape 8 – Envoi d’un e-mail de test avec Postfix (sendmail)
# ------------------------------------------------------------------

msg_step8_title
msg_step8_start

# 📤 Envoi d’un e-mail de test avec sendmail
echo -e "\n📤 $(msg_step8_test_sendmail)"
echo "📝 $(msg_step8_content)"
echo -e "\n➡️ $(msg_step8_dest): $MAIL_DEST"

echo "test email" | sendmail "$MAIL_DEST"

# 📁 Vérification de la boîte aux lettres locale
MAILBOX_DIR=$(postconf -h mail_spool_directory)
echo -e "\n📂 $(msg_step8_local_mailbox): $MAILBOX_DIR"
ls -l "$MAILBOX_DIR"

# 📁 Rappel emplacement logs
echo -e "\n📝 $(msg_step8_log_hint)"
echo "   ➤ /var/log/mail.log"

msg_step8_success

# ------------------------------------------------------------------
# 📘 Étape 9 – Installation de Mailutils et test d’envoi local
# ------------------------------------------------------------------
msg_step9_title
msg_step9_start

# 📦 Installation de Mailutils (MUA en ligne de commande)
echo -e "\n📦 Installation de mailutils (agent utilisateur de messagerie)..."
apt install -y mailutils &>/dev/null

# 📤 Envoi d’un e-mail local avec Postfix
echo -e "\n📤 Envoi d’un e-mail local (Postfix via mailutils)..."
echo -e "✅ Postfix OK – test Chapitre 1\n\n$(hostname)" | mail -s "✅ Test Chapitre 1" "$MAIL_DEST" -- -f "$MAIL_FROM"

# 📥 Vérification réception
read -rp "📬 $(msg_step9_ask_received) (y/N) : " RECEIVED
if [[ "$RECEIVED" =~ ^[Yy]$ ]]; then
  echo "✅ OK : le mail a bien été reçu ✅"
else
  echo "⚠️ Le mail ne semble pas reçu. Nous vérifierons à la fin du chapitre."
fi

msg_step9_success


# ------------------------------------------------------------------
# 📘 Étape 10 – Définir la taille maximale des e-mails (message_size_limit)
# ------------------------------------------------------------------

msg_step10_title
msg_step10_start

# 📏 Récupération des valeurs actuelles
CURRENT_MSG_LIMIT=$(postconf -h message_size_limit)
CURRENT_BOX_LIMIT=$(postconf -h mailbox_size_limit)

echo -e "\n📏 $(msg_step10_current): $CURRENT_MSG_LIMIT octets"
echo -e "📥 $(msg_step10_box_limit): $CURRENT_BOX_LIMIT octets"

# 🧠 Demande d’une nouvelle valeur
read -rp "📏 $(msg_step10_ask_size) (ex: 52428800 pour 50 Mo) [Entrée=inchangé] : " SIZE_LIMIT

if [[ -n "$SIZE_LIMIT" ]]; then
  if [[ "$CURRENT_BOX_LIMIT" -ne 0 && "$SIZE_LIMIT" -gt "$CURRENT_BOX_LIMIT" ]]; then
    echo -e "\n⚠️ $(msg_step10_warn_box)"
    read -rp "❓ $(msg_step10_confirm_apply) (y/N) : " CONFIRM
    [[ "$CONFIRM" != [Yy] ]] && echo "❌ $(msg_step10_abort)" && exit 1
  fi
  postconf -e "message_size_limit = $SIZE_LIMIT"
  echo "✅ $(msg_step10_applied) : $SIZE_LIMIT octets"
else
  echo "ℹ️ $(msg_step10_default) : $CURRENT_MSG_LIMIT"
fi

# 🔄 Rechargement Postfix
systemctl restart postfix && echo "🔄 Postfix redémarré."

msg_step10_success

# ------------------------------------------------------------------
# 📘 Étape 11 – Définir myhostname dans Postfix (FQDN recommandé))
# ------------------------------------------------------------------
msg_step11_title

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
echo -e "\n# 👇 Déclaré dans le script Chapitre 1 – Configuration Postfix\nmyhostname = $NEW_MYHOSTNAME" >> "$MAIN_CF"

echo -e "✅ $(msg_step11_applied): $NEW_MYHOSTNAME"

msg_step11_success

# ------------------------------------------------------------------
# 📘 Étape 12 – Création des alias mail requis (RFC 2142)
# ------------------------------------------------------------------

msg_step12_title

# 🔒 Sauvegarde préalable
cp "$ALIASES_FILE" "${ALIASES_FILE}.bak"

# ✅ postmaster → root (si absent)
if ! grep -q "^postmaster:" "$ALIASES_FILE"; then
  echo "postmaster: root" >> "$ALIASES_FILE"
  echo "➕ Alias ajouté : postmaster → root"
fi

# 👤 root → utilisateur réel (non-root recommandé)
read -rp "👤 $(msg_step12_prompt_alias) (ex: serv2025) : " ALIAS_USER
if [[ -n "$ALIAS_USER" ]]; then
  sed -i "s/^root:.*/root: ${ALIAS_USER}/" "$ALIASES_FILE"
  echo "✅ Alias modifié : root → ${ALIAS_USER}"
else
  echo "ℹ️ Aucun alias personnalisé fourni. L’alias root reste inchangé."
fi

# 🔃 Génération de la table des alias
newaliases && echo "✅ Table des alias mise à jour avec succès."

msg_step12_success

# ------------------------------------------------------------------
# 📘 Étape 13 – Configuration des protocoles IP (IPv4 / IPv6)
# ------------------------------------------------------------------

msg_step13_title

# 🔍 Affichage de la valeur actuelle
CURRENT_PROTO=$(postconf -h inet_protocols)
echo -e "\n🔍 $(msg_step13_current): $CURRENT_PROTO"

# 🧭 Instructions utilisateur
echo -e "\n🌐 $(msg_step13_explain)"
echo -e "   1) IPv4 uniquement"
echo -e "   2) IPv6 uniquement"
echo -e "   3) IPv4 + IPv6 (valeur par défaut)"
read -rp "➡️  $(msg_step13_prompt_choice) [Entrée=laisser par défaut] : " PROTO_CHOICE

# 🔧 Application du choix
case "$PROTO_CHOICE" in
  1)
    sed -i '/^inet_protocols *=/d' "$MAIN_CF"
    echo -e "\n# 🖧 Protocole IP défini par script Chapitre 1\ninet_protocols = ipv4" >> "$MAIN_CF"
    echo "✅ inet_protocols défini sur ipv4"
    ;;
  2)
    sed -i '/^inet_protocols *=/d' "$MAIN_CF"
    echo -e "\n# 🖧 Protocole IP défini par script Chapitre 1\ninet_protocols = ipv6" >> "$MAIN_CF"
    echo "✅ inet_protocols défini sur ipv6"
    ;;
  3)
    sed -i '/^inet_protocols *=/d' "$MAIN_CF"
    echo -e "\n# 🖧 Protocole IP défini par script Chapitre 1\ninet_protocols = all" >> "$MAIN_CF"
    echo "✅ inet_protocols défini sur all"
    ;;
  *)
    echo "ℹ️ Aucun changement effectué. Valeur actuelle conservée : $CURRENT_PROTO"
    ;;
esac

# 🔄 Redémarrage Postfix
echo -e "\n🔁 $(msg_step13_restart)"
systemctl restart postfix

# 📊 Vérification de l’état
systemctl status postfix --no-pager | grep -E "Active|Loaded"

msg_step13_success

# ------------------------------------------------------------------
# 📘 Étape 14 – Mise à jour de Postfix (préserver la configuration)
# ------------------------------------------------------------------

msg_step14_title

echo -e "\n📦 $(msg_step14_update_notice)"
echo -e "   🧠 Lorsque la mise à jour vous propose de choisir une configuration, sélectionnez :"
echo -e "   ➤ « ❌ Aucun (No configuration) » pour préserver vos fichiers actuels."

# 🆙 Mise à jour système (Postfix inclus si besoin)
apt update && apt upgrade -y

msg_step14_success




# ------------------------------------------------------------------
# 📘 Étape 14 – Sauvegarde main.cf (non destructif)
# ------------------------------------------------------------------
msg_step13_title
cp "$MAIN_CF" "${BACKUP_DIR}/main.cf.orig_${DATE_NOW}"





# ------------------------------------------------------------------
# 📘 Étape 16 – Redémarrage Postfix
# ------------------------------------------------------------------
msg_step16_title
systemctl restart postfix
systemctl status postfix --no-pager



# ------------------------------------------------------------------
# 📘 Étape 18 – Rappel sauvegarde distante (optionnel)
# ------------------------------------------------------------------
msg_step18_title
echo -e "\n⚠️ $(msg_step18_note)"
echo -e "📁 Exemple : rsync -avz /etc/postfix root@NAS:/sauvegardes/postfix/\n"

# ------------------------------------------------------------------
# 📘 Étape 19 – Fin et rappel vérifications
# ------------------------------------------------------------------
msg_step19_title
echo -e "\n✅ $(msg_step19_success)\n"
echo -e "📌 $(msg_step19_reminder)\n"

exit 0
