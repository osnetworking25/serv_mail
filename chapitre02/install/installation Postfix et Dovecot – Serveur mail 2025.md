#!/bin/bash
# ============================================================
# 📬 Script d’installation Postfix et Dovecot – Serveur mail 2025
# 📘 Chapitre 2 – Installation et configuration de Dovecot et Postfix (TLS activé)
# 🧾 Version : 1.0
# 🧑💼 Auteur : osnetworking / pontarlier-informatique
# ============================================================

# ===================================================
# 🌍 Bloc de sélection de la langue (multi-langue)
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

# Charger le fichier de langue
LANG_FILE="/opt/serv_mail/lang/${LANG}.sh"
if [[ -f "$LANG_FILE" ]]; then
  source "$LANG_FILE"
else
  echo "❌ Error: missing language file: $LANG_FILE"
  exit 1
fi

# Afficher les messages dynamiques du Chapitre 2
echo -e "$msg_intro_chap2"
echo -e "$msg_steps_chap2"

echo -e "\n"

# === 🔧 Variables dynamiques principales ===

while [[ -z "$DOMAIN" ]]; do
  read -rp "$msg_prompt_domain_chap2 : " DOMAIN
done

while [[ -z "$MAIL_SERVER_FQDN" ]]; do
  read -rp "$msg_prompt_mail_fqdn_chap2 (e.g. mail.${DOMAIN}) : " MAIL_SERVER_FQDN
done

echo -e "\n"

# === 📁 Arborescence projet ===
SERV_ROOT="/opt/serv_mail/chapitre_02"
LOGS_DIR="${SERV_ROOT}/logs"
BACKUP_DIR="${SERV_ROOT}/backup/${DOMAIN}"
mkdir -p "$LOGS_DIR" "$BACKUP_DIR"

DATE_NOW="$(date +%F_%Hh%M)"
MAIN_CF="/etc/postfix/main.cf"
ALIASES_FILE="/etc/aliases"

# === ✅ Début des étapes ===

# ------------------------------------------------------------------
# 📘 Étape 1 – Vérification de l'état de UFW et ouverture des ports
# ------------------------------------------------------------------

echo "$msg_check_ufw_chap2"
echo "🌐 Vérification de l'état de UFW (pare-feu)..."

# Vérification de l'état de UFW
UFW_STATUS=$(sudo ufw status | grep -o "active")

if [[ "$UFW_STATUS" != "active" ]]; then
    echo "$msg_inactive_ufw_chap2"
    read -rp "$msg_enable_ufw_chap2 : " ENABLE_UFW
    if [[ "$ENABLE_UFW" =~ ^[Yy]$ ]]; then
        echo "$msg_enable_ufw_activate_chap2"
        sudo ufw enable
        echo "$msg_ufw_activated_chap2"
        # Ouverture des ports nécessaires une fois UFW activé
        echo "$msg_open_ports_chap2"
        sudo ufw allow 80/tcp    # HTTP (Certbot + Webmail)
        sudo ufw allow 443/tcp   # HTTPS (HAProxy / Webmail sécurisé)
        sudo ufw allow 587/tcp   # SMTP Submission
        sudo ufw allow 465/tcp   # SMTP SSL (facultatif, selon configuration)
        sudo ufw allow 143/tcp   # IMAP
        sudo ufw allow 993/tcp   # IMAPS (IMAP sécurisé)
        sudo ufw allow 110/tcp   # POP3
        sudo ufw allow 995/tcp   # POP3S (POP3 sécurisé)
        sudo ufw allow 22/tcp    # SSH (Accès distant sécurisé)
        sudo ufw allow 25/tcp    # SMTP (Envoi de mails)
        sudo ufw status verbose
    else
        echo "$msg_ufw_disabled_chap2"
    fi
else
    echo "$msg_active_ufw_chap2"
    
    # Ouverture des ports nécessaires pour le serveur mail (si UFW est déjà activé)
    echo "$msg_open_ports_chap2"
    sudo ufw allow 80/tcp    # HTTP (Certbot + Webmail)
    sudo ufw allow 443/tcp   # HTTPS (HAProxy / Webmail sécurisé)
    sudo ufw allow 587/tcp   # SMTP Submission
    sudo ufw allow 465/tcp   # SMTP SSL (facultatif, selon configuration)
    sudo ufw allow 143/tcp   # IMAP
    sudo ufw allow 993/tcp   # IMAPS (IMAP sécurisé)
    sudo ufw allow 110/tcp   # POP3
    sudo ufw allow 995/tcp   # POP3S (POP3 sécurisé)
    sudo ufw allow 22/tcp    # SSH (Accès distant sécurisé)
    sudo ufw allow 25/tcp    # SMTP (Envoi de mails)
    
    # Vérification de l'état du pare-feu
    sudo ufw status verbose
fi

# ------------------------------------------------------------------
# 📘 Étape 2 – Installation de Postfix
# ------------------------------------------------------------------

echo "$msg_postfix_config_chap2"
echo "$msg_install_postfix_chap2"
sudo apt update
sudo apt install -y postfix postfix-mysql mailutils

# Configuration de Postfix pour accepter les connexions sécurisées
echo "$msg_postfix_config_chap2"
echo "Configuration de Postfix avec le domaine $DOMAIN..."
sudo postconf -e "myhostname = $MAIL_SERVER_FQDN"
sudo postconf -e "mydomain = $DOMAIN"
sudo postconf -e "myorigin = /etc/mailname"
sudo postconf -e "inet_interfaces = all"
sudo postconf -e "inet_protocols = ipv4"
sudo postconf -e "home_mailbox = Maildir/"

# ------------------------------------------------------------------
# 📘 Étape 3 – Installation de Dovecot
# ------------------------------------------------------------------

echo "$msg_dovecot_maildir_config_chap2"
echo "$msg_install_dovecot_chap2"
sudo apt install -y dovecot-core dovecot-imapd dovecot-pop3d

# Configuration de Dovecot pour utiliser Maildir
echo "$msg_dovecot_maildir_config_chap2"
echo "Configuration de Dovecot pour Maildir..."
sudo postconf -e "mail_location = maildir:/var/mail/vmail/%d/%n/Maildir"

# Configuration TLS pour Dovecot
echo "$msg_dovecot_tls_config_chap2"
echo "Configuration de Dovecot pour TLS..."
sudo bash -c "cat > /etc/dovecot/conf.d/10-ssl.conf <<EOF
ssl = required
ssl_cert = </etc/letsencrypt/live/$DOMAIN/fullchain.pem
ssl_key = </etc/letsencrypt/live/$DOMAIN/privkey.pem
ssl_prefer_server_ciphers = yes
ssl_min_protocol = TLSv1.2
EOF"

# ------------------------------------------------------------------
# 📘 Étape 4 – Activation du chiffrement TLS sur Postfix
# ------------------------------------------------------------------

echo "$msg_config_tls_postfix_chap2"
sudo bash -c "cat >> /etc/postfix/main.cf <<EOF
smtpd_tls_cert_file=/etc/letsencrypt/live/$DOMAIN/fullchain.pem
smtpd_tls_key_file=/etc/letsencrypt/live/$DOMAIN/privkey.pem
smtpd_tls_security_level=may
smtp_tls_security_level=may
smtpd_tls_loglevel=1
smtp_tls_loglevel=1
smtp_tls_session_cache_database=btree:${data_directory}/smtp_scache
EOF"

# ------------------------------------------------------------------
# 📘 Étape 5 – Test de la configuration
# ------------------------------------------------------------------

# Demander le sujet et la description de l'email
read -rp "$msg_test_email_chap2 - $msg_prompt_subject : " EMAIL_SUBJECT
read -rp "$msg_test_email_chap2 - $msg_prompt_description : " EMAIL_DESCRIPTION

# Envoi de l'email de test
echo "$EMAIL_DESCRIPTION" | mail -s "$EMAIL_SUBJECT" "$MAIL_FROM"

# Test IMAP
echo "$msg_test_imap_chap2"
openssl s_client -connect $MAIL_SERVER_FQDN:993

# ------------------------------------------------------------------
# 📘 Étape 6 – Redémarrage des services
# ------------------------------------------------------------------

echo "$msg_restart_services_chap2"
sudo systemctl restart postfix
sudo systemctl restart dovecot

# Vérification du statut des services
sudo systemctl status postfix
sudo systemctl status dovecot

echo -e "\n🎉 $msg_success_chap2"
