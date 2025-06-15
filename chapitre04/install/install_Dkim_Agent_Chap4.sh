#!/bin/bash
# ============================================================
# 🎯 Script de configuration SPF & DKIM pour Postfix/OpenDKIM
# 📅 Chapitre 4 – Serveur mail 2025
# 🧾 Version : 1.8
# 🧑💼 Auteur : osnetworking / pontarlier-informatique
# ============================================================

# ===================================================
# 🌍 Bloc de sélection de la langue (multi-langue)
# ✅ Full dynamique – pontarlier-informatique
# ===================================================

# Valeur par défaut
LANG="en"

# Interface de choix rapide (pas encore traduite)
echo -e "\n🌐 Choose your language / Choisissez votre langue :"
echo "1) Français"
echo "2) English"
read -rp "➡️  Your choice / Votre choix [1-2] : " LANG_CHOICE

case "$LANG_CHOICE" in
  2|"en"|"EN") LANG="en" ;;
  1|"fr"|"FR"|*) LANG="fr" ;;
esac

# Chargement dynamique du fichier de langue
LANG_FILE="/opt/serv_mail/lang/${LANG}.sh"
if [[ -f "$LANG_FILE" ]]; then
  source "$LANG_FILE"
else
  echo "❌ Error: missing language file: $LANG_FILE"
  exit 1
fi

# ✅ Affiche le message d’accueil dans la langue choisie
msg_lang


# Traduction automatique des titres si besoin (plus tard si internationalisation)

# === 📘 Bannière & introduction ===

msg_banner

msg_intro
echo -e "\n"

# === 🔧 Variables dynamiques principales ===

# 🌐 Nom de domaine principal
while [[ -z "$DOMAIN" ]]; do
  read -rp "🌐 Nom de domaine principal (ex: domain.tld) : " DOMAIN
done

# 📧 Adresse e-mail utilisée pour les tests
while [[ -z "$MAIL_FROM" ]]; do
  read -rp "📧 Adresse e-mail utilisée pour les tests (ex: contact@${DOMAIN}) : " MAIL_FROM
done

# 📨 Adresse de destination pour les tests
while [[ -z "$MAIL_DEST" ]]; do
  read -rp "📨 Adresse de destination pour les tests (ex: Gmail, Outlook) : " MAIL_DEST
done

# 🌐 FQDN du serveur mail
while [[ -z "$MAIL_SERVER_FQDN" ]]; do
  read -rp "🌐 FQDN du serveur (ex: mail.${DOMAIN}) : " MAIL_SERVER_FQDN
done

echo -e "\n"

# === 📂 Arborescence projet ===
SERV_ROOT="/opt/serv_mail/chapitre_04"
EXPORT_DIR="${SERV_ROOT}/export/${DOMAIN}"
BACKUP_DIR="${SERV_ROOT}/backup/${DOMAIN}"
LOGS_DIR="${SERV_ROOT}/logs"
DOCUMENTATION_DIR="${SERV_ROOT}/documentation"
# 📁 Fichier exporté dans le dossier standard chapitre_04
EXPORT_KEY_FILE="/opt/serv_mail/chapitre_04/export/${DOMAIN}/dkim_pubkey_${DOMAIN}.txt"

# === 🔐 DKIM / SPF / DNS ===
DKIM_SELECTOR="default"
DKIM_FOLDER="/etc/opendkim/keys/${DOMAIN}"
PRIVATE_KEY="${DKIM_FOLDER}/${DKIM_SELECTOR}.private"
PUBLIC_KEY="${DKIM_FOLDER}/${DKIM_SELECTOR}.txt"
KEYTABLE_FILE="/etc/opendkim/KeyTable"
SIGNINGTABLE_FILE="/etc/opendkim/SigningTable"
TRUSTEDHOSTS_FILE="/etc/opendkim/TrustedHosts"

# === 🔌 Configuration OpenDKIM / Postfix ===
OPENDKIM_CONF="/etc/opendkim.conf"
OPENDKIM_DEFAULT="/etc/default/opendkim"
POSTFIX_MAIN_CF="/etc/postfix/main.cf"
POSTFIX_MASTER_CF="/etc/postfix/master.cf"
OPENDKIM_SOCKET="/var/spool/postfix/opendkim/opendkim.sock"

# === 📨 Outils de test ===

SMTP_SERVER="127.0.0.1"
PORT25_EMAIL="check-auth@verifier.port25.com"
SIGNATURE="(Société Exemple - monserveurmail)"
SERVER_HOSTNAME=$(hostname)

# === 🕒 Date et heure pour timestamp logs/backup
DATE_NOW="$(date +%F_%H%M%S)"

# === ✅ Étapes d'installation SPF & DKIM ===
# Chaque bloc d’étape est encapsulé dans une variable conditionnelle (ETAPE_X_OK)
# pour permettre un contrôle simple et une future modularité.

# ✅ ⬇️ AJOUTE ICI la fonction configure_opendkim_conf

# === 🧩 Configuration automatique du fichier /etc/opendkim.conf ===
configure_opendkim_conf() {
  CONF_FILE="/etc/opendkim.conf"

  echo "🛠️  Configuration automatique du fichier $CONF_FILE..."

  # Canonicalization
  sed -i 's/^#Canonicalization.*/Canonicalization   relaxed\/simple/' "$CONF_FILE"

  # LogWhy (décommenter si présent commenté)
  sed -i 's/^#LogWhy/LogWhy/' "$CONF_FILE"

  # Mode et SubDomains
  sed -i 's/^#Mode.*/#Mode               sv/' "$CONF_FILE"
  sed -i 's/^#SubDomains.*/#SubDomains         no/' "$CONF_FILE"
  sed -i 's/^SubDomains.*/SubDomains         no/' "$CONF_FILE"

  # UserID (ne rien faire, il est déjà présent correctement)

  # Ajouter les lignes si manquantes
  grep -q '^KeyTable' "$CONF_FILE" || {
    echo "KeyTable           refile:/etc/opendkim/key.table" >> "$CONF_FILE"
    echo "SigningTable       refile:/etc/opendkim/signing.table" >> "$CONF_FILE"
    echo "ExternalIgnoreList /etc/opendkim/trusted.hosts" >> "$CONF_FILE"
    echo "InternalHosts      /etc/opendkim/trusted.hosts" >> "$CONF_FILE"
  }

  echo "✅ Fichier $CONF_FILE configuré avec succès."
}


# Étapes 1 à 9 incluses ci-dessous...
# (💬 Pour garder le message lisible, je peux te les afficher immédiatement ou générer un fichier)

#################################################
### ✅ =========== INTRODUCTION ============= ###
#################################################

echo "------------------------------------------------------------------"
echo "          CHAPITRE 4                     "
echo "------------------------------------------------------------------"

###################################################
### ✅ === ÉTAPE 1 : Enregistrement DNS SPF === ###
###################################################

ETAPE1_OK=false

msg_step1_title
echo
msg_step1_instruction

read -rp "$(msg_step1_continue_prompt)"
echo

msg_step1_dig_check
echo
dig +short TXT "${DOMAIN}"
sleep 2

read -rp "$(msg_step1_confirm_prompt)" CONFIRM_SPF
if [[ "$CONFIRM_SPF" =~ ^[OoYy1]$ ]]; then
  msg_step1_confirmed
  ETAPE1_OK=true
else
  msg_step1_not_confirmed
fi
echo -e"\n\n "

#############################################################
### ✅ === ÉTAPE 2 : Installation du SPF Policy Agent === ###
#############################################################

ETAPE2_OK=false

msg_step2_title
msg_step2_check_installed

# Vérifier si le paquet est déjà installé
if dpkg -l | grep -qw postfix-policyd-spf-python; then
  msg_step2_already_installed
  ETAPE2_OK=true
else
  msg_step2_installing
  if sudo apt update && sudo apt install -y postfix-policyd-spf-python; then
    msg_step2_success
    ETAPE2_OK=true
  else
    msg_step2_failure
    ETAPE2_OK=false
  fi
fi

# Configurer /etc/postfix/master.cf
if [ "$ETAPE2_OK" = true ]; then
  echo "📁 Sauvegarde de /etc/postfix/master.cf..."
  sudo cp /etc/postfix/master.cf "/etc/postfix/master.cf.bak_$(date +%F_%H%M%S)"

  echo "📁 Ajout de la configuration SPF dans master.cf..."
  cat <<'EOF' | sudo tee -a /etc/postfix/master.cf > /dev/null

# Postfix to start the SPF policy daemon
policyd-spf  unix  -       n       n       -       0       spawn
    user=policyd-spf argv=/usr/bin/policyd-spf
EOF

  echo "📁 Sauvegarde de /etc/postfix/main.cf..."
  sudo cp /etc/postfix/main.cf "/etc/postfix/main.cf.bak_$(date +%F_%H%M%S)"

  echo "📁 Ajout des restrictions SPF dans main.cf..."
  cat <<'EOF' | sudo tee -a /etc/postfix/main.cf > /dev/null

policyd-spf_time_limit = 3600
smtpd_recipient_restrictions =
   permit_mynetworks,
   permit_sasl_authenticated,
   reject_unauth_destination,
   check_policy_service unix:private/policyd-spf
EOF

  echo "🔄 Redémarrage de Postfix..."
  sudo systemctl restart postfix && echo "✅ Postfix redémarré avec succès." || echo "❌ Échec du redémarrage de Postf>
fi
#####################################################
###  ✅ === ÉTAPE 3 : Installation d’OpenDKIM === ###
#####################################################

ETAPE3_OK=false

msg_step3_title
msg_step3_start

# Installation des paquets
if sudo apt install -y opendkim opendkim-tools; then

  # Ajout de postfix au groupe opendkim
  sudo gpasswd -a postfix opendkim

  # Sauvegarde du fichier
  sudo cp /etc/opendkim.conf "/etc/opendkim.conf.bak_$(date +%F_%H%M%S)"

  # Configuration automatique
  configure_opendkim_conf

  # Bloc additionnel recommandé
  cat <<EOF | sudo tee -a /etc/opendkim.conf > /dev/null

# === Ajout automatique – configuration recommandée générique ===
AutoRestart         yes
AutoRestartRate     10/1M
Background          yes
DNSTimeout          5
SignatureAlgorithm  rsa-sha256
EOF

  msg_step3_success
  ETAPE3_OK=true

else
  echo "❌ Échec de l'installation d'OpenDKIM."
fi

###############################################################################
### ✅ === ÉTAPE 4 : Création des fichiers DKIM (signing, key, trusted) === ###
###############################################################################

ETAPE4_OK=false

msg_step4_title
msg_step4_prepare_dirs

# Création des répertoires
sudo mkdir -p /etc/opendkim
sudo mkdir -p /etc/opendkim/keys

# Droits sur les dossiers
sudo chown -R opendkim:opendkim /etc/opendkim
sudo chmod go-rw /etc/opendkim/keys

# Dossier spécifique au domaine
KEYDIR="/etc/opendkim/keys/${DOMAIN}"
sudo mkdir -p "$KEYDIR"
sudo chmod go-rwx "$KEYDIR"
sudo chown -R opendkim:opendkim "$KEYDIR"

# Création du fichier signing.table
SIGNING_TABLE="/etc/opendkim/signing.table"
cat <<EOF | sudo tee "$SIGNING_TABLE" > /dev/null
*@${DOMAIN}    default._domainkey.${DOMAIN}
*@*.${DOMAIN}    default._domainkey.${DOMAIN}
EOF
msg_step4_signing_table_ok

# Création du fichier key.table
KEY_TABLE="/etc/opendkim/key.table"
cat <<EOF | sudo tee "$KEY_TABLE" > /dev/null
default._domainkey.${DOMAIN}     ${DOMAIN}:default:/etc/opendkim/keys/${DOMAIN}/default.private
EOF
msg_step4_key_table_ok

# Création du fichier trusted.hosts
TRUSTED_HOSTS="/etc/opendkim/trusted.hosts"
cat <<EOF | sudo tee "$TRUSTED_HOSTS" > /dev/null
127.0.0.1
localhost

.${DOMAIN}
EOF
msg_step4_trusted_hosts_ok

msg_step4_files_created
ETAPE4_OK=true


ETAPE5_OK=false

msg_step5_title

# Vérifie si la clé privée existe déjà pour éviter une régénération
if [[ -f "$PRIVATE_KEY" ]]; then
  msg_step5_existing_key
  echo "📎 Clé privée déjà présente : $PRIVATE_KEY"
  echo "📎 Clé publique associée    : $PUBLIC_KEY"
  ETAPE5_OK=true
else
  msg_step5_key_generating

  # Création du dossier si nécessaire
  sudo mkdir -p "$(dirname "$PRIVATE_KEY")"

  # Génération de la paire de clés
  if sudo opendkim-genkey -b 2048 -d "$DOMAIN" -D "$DKIM_FOLDER" -s "$DKIM_SELECTOR" -v; then
    # Propriétaire et permissions sécurisées
    sudo chown opendkim:opendkim "$PRIVATE_KEY"
    sudo chmod 600 "$PRIVATE_KEY"

    msg_step5_key_success
    echo "📎 Clé privée : $PRIVATE_KEY"
    echo "📎 Clé publique (à copier dans le DNS) : $PUBLIC_KEY"
    ETAPE5_OK=true
  else
    echo "❌ Échec de la génération de la paire de clés DKIM."
    ETAPE5_OK=false
  fi
fi

############################################################################
### ✅ === ÉTAPE 6 : Publication de la clé publique DKIM dans le DNS === ###
############################################################################

ETAPE6_OK=false

msg_step6_title

# Chemin de la clé publique générée automatiquement à l’étape 5
PUBKEY_FILE="${PUBLIC_KEY}"
EXPORT_DIR="$(dirname "$EXPORT_KEY_FILE")"
DNS_EXPORT_FILE="${EXPORT_KEY_FILE}"

# Vérifie que le fichier existe
if [[ ! -f "$PUBKEY_FILE" ]]; then
  echo "❌ Fichier de clé publique introuvable : $PUBKEY_FILE"
  echo "🛑 Impossible de poursuivre l'étape 6."
  ETAPE6_OK=false
else
  # === Affichage brut ===
  msg_step6_dkim_raw_display
  echo
  cat "$PUBKEY_FILE"

  # === Affichage nettoyé (copiable dans DNS) ===
  msg_step6_dkim_cleaned_intro
  echo
  sed -n '/^default\._domainkey/,/^)  ;/p' "$PUBKEY_FILE" \
    | tr -d '\n' \
    | sed -E 's/^.*"v=DKIM1;/v=DKIM1;/; s/"[[:space:]]*"//g; s/"//g; s/ *\).*//' \
    | xargs -0 -I{} printf "     %s\n" "{}"

  # === Pause utilisateur pour copier dans l’interface DNS ===
  msg_step6_dns_insert
  echo
  msg_step6_dkim_pause_copy
  read -r

  # === Export de la version nettoyée ===
  mkdir -p "$EXPORT_DIR"
  sed -n '/^default\._domainkey/,/^)  ;/p' "$PUBKEY_FILE" \
    | tr -d '\n' \
    | sed -E 's/^.*"v=DKIM1;/v=DKIM1;/; s/"[[:space:]]*"//g; s/"//g; s/ *\).*//' \
    | xargs -0 -I{} printf "%s\n" "{}" > "$DNS_EXPORT_FILE"

  # === Message de confirmation ===
  msg_step6_dkim_exported
  echo "📁 Fichier exporté : $DNS_EXPORT_FILE"

  # === Félicitations ===
  msg_step6_success
  ETAPE6_OK=true
fi

##############################################################################
### ✅ === ÉTAPE 7 : Vérification de la clé DKIM avec opendkim-testkey === ###
##############################################################################

ETAPE7_OK=false
msg_step7_title
msg_step7_checking

# Exécution du test
TEST_RESULT=$(sudo opendkim-testkey -d ${DOMAIN} -s default -vvv 2>&1)

# Affichage brut du résultat
echo "$TEST_RESULT"

# Vérification d’une éventuelle erreur de type DNS (timeout)
if echo "$TEST_RESULT" | grep -q "query timed out"; then
  msg_step7_timeout_error

  # Vérifie et commente la ligne TrustAnchorFile dans /etc/opendkim.conf si présente
  if grep -q "^TrustAnchorFile" /etc/opendkim.conf; then
    msg_step7_fixing_anchor
    sudo sed -i 's/^TrustAnchorFile/#TrustAnchorFile/' /etc/opendkim.conf
    sudo systemctl restart opendkim
    msg_step7_opendkim_restarted
  else
    msg_step7_no_anchor
  fi
else
  msg_step7_valid_key
  ETAPE7_OK=true
fi

msg_step7_success

####################################################################
### ✅ ÉTAPE 8 : Connexion d'OpenDKIM à Postfix via socket       ###
####################################################################

ETAPE8_OK=false
msg_step8_title

# 1. Créer le dossier pour le socket
sudo mkdir -p /var/spool/postfix/opendkim
sudo chown opendkim:postfix /var/spool/postfix/opendkim

# 2. Modifier /etc/opendkim.conf (sauvegarde + changement du socket)
msg_step8_conf_opendkim
sudo cp /etc/opendkim.conf /etc/opendkim.conf.bak

if grep -q '^Socket' /etc/opendkim.conf; then
  msg_step8_socket_replaced
  sudo sed -i 's/^\(Socket.*\)/#\1\nSocket    local:\/var\/spool\/postfix\/opendkim\/opendkim.sock/' /etc/opendkim.conf
else
  msg_step8_socket_added
  echo "# === Ajout socket pour Postfix ===" | sudo tee -a /etc/opendkim.conf
  echo "Socket    local:/var/spool/postfix/opendkim/opendkim.sock" | sudo tee -a /etc/opendkim.conf
fi

# 3. Modifier /etc/default/opendkim
msg_step8_conf_default
sudo cp /etc/default/opendkim /etc/default/opendkim.bak

sudo sed -i 's/^SOCKET=.*/#&\nSOCKET="local:\/var\/spool\/postfix\/opendkim\/opendkim.sock"/' /etc/default/opendkim ||>
echo 'SOCKET="local:/var/spool/postfix/opendkim/opendkim.sock"' | sudo tee -a /etc/default/opendkim

# 4. Ajouter à la fin de /etc/postfix/main.cf
msg_step8_conf_postfix
msg_step8_postfix_milter
cat << 'EOF' | sudo tee -a /etc/postfix/main.cf

# 📬 OpenDKIM Milter
milter_default_action = accept
milter_protocol = 6
smtpd_milters = unix:/opendkim/opendkim.sock
non_smtpd_milters = unix:/opendkim/opendkim.sock
EOF

# 5. Redémarrage des services
msg_step8_services_restart
sudo systemctl restart opendkim postfix

msg_step8_success
ETAPE8_OK=true

########################################################################
### ✅ Étape 9 : Vérification SPF / DKIM / DMARC via envoi réel     ###
########################################################################

msg_step9_start

# 📦 Vérifier swaks
if ! command -v swaks &>/dev/null; then
  msg_step9_install_swaks
  apt install -y swaks
fi

# ✉️ Test vers check-auth@verifier.port25.com
msg_step9_check_auth
read -rsp "🔑 Mot de passe du compte ${MAIL_FROM} : " MAIL_PASS
echo

swaks --from "${MAIL_FROM}" \
      --to "check-auth@verifier.port25.com" \
      --server "${MAIL_SERVER_FQDN}" \
      --port 587 \
      --tls \
      --auth LOGIN \
      --auth-user "${MAIL_FROM}" \
      --auth-password "${MAIL_PASS}" \
      --header "Subject: Test DKIM/SPF depuis ${MAIL_SERVER_FQDN}" \
      --body "Test DKIM/SPF envoyé depuis ${SERVER_HOSTNAME} - pontarlier-informatique / osnetworking"

msg_step9_wait_result
read -rp "$(msg_step9_prompt_continue)"

# 📤 Test Mail-tester
read -rp "$(msg_step9_ask_mailtester)" TEST_MT
if [[ "$TEST_MT" =~ ^[Oo]$ ]]; then
  read -rp "$(msg_step9_prompt_mailtester)" MT_ADDR
  read -rsp "🔑 Mot de passe du compte ${MAIL_FROM} : " MAIL_PASS
  echo
  msg_step9_sending_mailtester
  swaks --from "${MAIL_FROM}" \
        --to "${MT_ADDR}" \
        --server "${MAIL_SERVER_FQDN}" \
        --port 587 \
        --tls \
        --auth LOGIN \
        --auth-user "${MAIL_FROM}" \
        --auth-password "${MAIL_PASS}" \
        --header "Subject: Mail-tester depuis ${MAIL_SERVER_FQDN}" \
        --body "Test DKIM/SPF/DMARC depuis ${SERVER_HOSTNAME}"

  msg_step9_mailtester_link
fi

# 🔐 STARTTLS check
msg_step9_tls_check
openssl s_client -starttls smtp -crlf -connect "${MAIL_SERVER_FQDN}":587

msg_step9_success
