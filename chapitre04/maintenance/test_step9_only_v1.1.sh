#!/bin/bash
# 🎯 Script de test final SPF / DKIM / DMARC
# 📅 Chapitre 4 – Étape 9 uniquement
# 🧾 Version : 1.1
# 👤 Auteur : pontarlier-informatique - osnetworking

# 🌍 Silencer les avertissements de locale
export LANG=C.UTF-8
export LC_ALL=C.UTF-8

# === 🌐 Sélection dynamique de la langue ===
echo -e "\n🌐 Choose your language / Choisissez votre langue :"
echo "1) Français"
echo "2) English"
echo -n "➡️  Your choice / Votre choix [1-2] : "
read -r LANG_CHOICE
case "$LANG_CHOICE" in
  1|"fr"|"FR") LANG="fr" ;;
  2|"en"|"EN") LANG="en" ;;
  *) LANG="en" ;;
esac
source "/opt/serv_mail/lang/${LANG}.sh"

# === 🧭 Variables dynamiques ===
read -rp "🌐 Domaine principal (ex : domain.tld) : " DOMAIN
read -rp "📧 Adresse mail expéditrice (ex : contact@domain.tld) : " MAIL_FROM
read -rp "📨 Adresse mail destinataire pour test (ex : test@gmail.com) : " MAIL_DEST
read -rp "🔧 Nom d'hôte complet du serveur SMTP (ex : mail.domain.tld) : " MAIL_SERVER_FQDN

# === 📁 Répertoires par défaut ===
CHAP="chapitre_04"
BASE_DIR="/opt/serv_mail"
EXPORT_DIR="${BASE_DIR}/${CHAP}/export/${DOMAIN}"
BACKUP_DIR="${BASE_DIR}/${CHAP}/backup/${DOMAIN}"
LOGS_DIR="${BASE_DIR}/${CHAP}/logs"
DATE_NOW=$(date +%Y-%m-%d_%Hh%M)

# === 🔑 Clés DKIM (non utilisées ici mais déclarées pour standardisation) ===
DKIM_SELECTOR="default"
DKIM_DIR="/etc/opendkim/keys/${DOMAIN}"
PUBLIC_KEY="${DKIM_DIR}/${DKIM_SELECTOR}.txt"
PRIVATE_KEY="${DKIM_DIR}/${DKIM_SELECTOR}.private"
DNS_EXPORT_FILE="${EXPORT_DIR}/dkim_pubkey_${DOMAIN}.txt"

# === 🚀 Démarrage du test SPF / DKIM / DMARC ===
echo -e "\n🚀 Lancement des tests SPF / DKIM / DMARC pour ${DOMAIN}"

# 📤 Vérification et installation de swaks si manquant
if ! command -v swaks &>/dev/null; then
  echo "📦 Installation du paquet swaks pour les tests SMTP..."
  apt install -y swaks
fi

# 📤 Envoi vers check-auth@verifier.port25.com
echo "✉️ Envoi d’un email de test vers check-auth@verifier.port25.com"
read -rsp "🔑 Mot de passe du compte ${MAIL_FROM} : " MAIL_PASS
echo
swaks --from "${MAIL_FROM}" \
      --to "check-auth@verifier.port25.com" \
      --server "${MAIL_SERVER_FQDN}" \
      --tls \
      --auth LOGIN \
      --auth-user "${MAIL_FROM}" \
      --auth-password "${MAIL_PASS}" \
      --header "Subject: Test DKIM/SPF depuis ${MAIL_SERVER_FQDN}" \
      --body "Test technique depuis le serveur mail ${MAIL_SERVER_FQDN}" \
      2>&1 | tee "${LOGS_DIR}/step9_swaks_port25_${DATE_NOW}.log"

echo -e "\n📥 Attends quelques secondes, puis vérifie que SPF / DKIM / DMARC passent correctement (PASS)"
read -rp "✔️ Appuie sur Entrée une fois que tu as vu le résultat..."

# 📤 Test Mail-tester si souhaité
read -rp "Souhaitez-vous faire un test Mail-tester ? (O/N) : " TEST_MT
if [[ "$TEST_MT" =~ ^[Oo]$ ]]; then
  read -rp "➡️ Adresse de test mail-tester (copiée depuis l’interface) : " MT_ADDR
  read -rsp "🔑 Mot de passe du compte ${MAIL_FROM} : " MAIL_PASS
  echo
  echo "✉️ Envoi d’un email vers $MT_ADDR"

  swaks --from "${MAIL_FROM}" \
        --to "${MT_ADDR}" \
        --server "${MAIL_SERVER_FQDN}" \
        --tls \
        --auth LOGIN \
        --auth-user "${MAIL_FROM}" \
        --auth-password "${MAIL_PASS}" \
        --header "Subject: Mail-tester depuis ${MAIL_SERVER_FQDN}" \
        --body "Test de validation DKIM/SPF/DMARC depuis le serveur mail ${MAIL_SERVER_FQDN}" \
        2>&1 | tee "${LOGS_DIR}/step9_swaks_mailtester_${DATE_NOW}.log"

  echo "🔗 Vérifie ton score sur : https://www.mail-tester.com"
fi

# 🔐 Test STARTTLS avec OpenSSL
echo
echo "🔐 Test STARTTLS sur le port 587 avec OpenSSL"
openssl s_client -starttls smtp -crlf -connect "${MAIL_SERVER_FQDN}":587

echo -e "\n✅ Tous les tests de l'étape 9 ont été exécutés."
