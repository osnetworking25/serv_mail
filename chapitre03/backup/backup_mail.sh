#!/bin/bash

# ============================================================================
# Script interactif de sauvegarde via rsync (SSH sécurisé)
# Auteur : Pontarlier-Informatique
# Version : 1.1 - 2025-06-04
# ============================================================================

# === CONFIG DE BASE ===
DATE=$(date +"%Y-%m-%d_%Hh%M")
TMP_DIR="/tmp/backup_mail_$DATE"
LOGFILE="/var/log/backup_mail.log"
mkdir -p "$TMP_DIR"
exec > >(tee -a "$LOGFILE") 2>&1

# === INFOS SSH ===
echo "⚠️  Merci de vérifier que le service SSH (port $SSH_PORT) ET Rsync sont bien activés sur le NAS Synology (Panneau de configuration > Terminal / rsync)"

read -rp "❓ Voulez-vous continuer ? (o/N) : " confirm
if [[ ! "$confirm" =~ ^[oO]$ ]]; then
  echo "❌ Opération annulée."
  exit 1
fi


echo "🔐 Connexion au NAS (rsync sécurisé)"
read -rp "Adresse IP du NAS : " NAS_IP
read -rp "Nom d'utilisateur SSH : " NAS_USER
SSH_PORT=10523
REMOTE="$NAS_USER@$NAS_IP"

# === INFOS SQL ===
read -rp "Nom de la base MariaDB : " SQL_DB
read -rp "Utilisateur MariaDB : " SQL_USER
read -rsp "Mot de passe MariaDB : " SQL_PASS
echo ""

# === ARCHIVE DES FICHIERS DE CONFIGURATION ===
echo "📦 Sauvegarde des fichiers de configuration..."
tar czf "$TMP_DIR/configs.tar.gz" \
  /etc/hosts \
  /etc/hostname \
  /etc/postfix/main.cf \
  /etc/postfix/master.cf \
  /etc/postfix/sql \
  /etc/dovecot/dovecot.conf \
  /etc/dovecot/dovecot-sql.conf.ext \
  /etc/dovecot/conf.d/10-auth.conf \
  /etc/dovecot/conf.d/10-mail.conf \
  /etc/dovecot/conf.d/10-master.conf \
  /etc/dovecot/conf.d/15-mailboxes.conf \
  /etc/dovecot/conf.d/20-lmtp.conf \
  /etc/postfixadmin/config.local.php \
  /etc/letsencrypt \
  /var/www/postfixadmin \
  /opt/postfixadmin-scripts \
  /opt/sources \
  2>/dev/null

# === DUMP SQL ===
echo "🗄️ Sauvegarde de la base MariaDB..."
if ! mysqldump -u "$SQL_USER" -p"$SQL_PASS" "$SQL_DB" > "$TMP_DIR/postfixadmin_db.sql" 2>/dev/null; then
  echo "❌ ERREUR : échec du dump MariaDB. Vérifiez les identifiants ou le nom de la base."
  exit 1
fi

# === ARCHIVE DES MAILS ===
echo "📬 Sauvegarde des mails (Maildir)..."
tar czf "$TMP_DIR/vmail.tar.gz" /var/mail/vmail 2>/dev/null

# === TRANSFERT VIA RSYNC SUR PORT SSH 10523 ===
echo "🚀 Transfert des sauvegardes vers le NAS..."
ssh -p "$SSH_PORT" "$REMOTE" "mkdir -p /volume1/Sauvegardes/Serveur_mail/$DATE" 2>/dev/null
rsync -avz -e "ssh -p $SSH_PORT" "$TMP_DIR/" "$REMOTE:/volume1/Sauvegardes/Serveur_mail/$DATE"

# === NETTOYAGE LOCAL ===
echo "🧹 Nettoyage temporaire..."
rm -rf "$TMP_DIR"

# === FIN ===
echo "✅ Sauvegarde terminée avec succès : /volume1/Sauvegardes/Serveur_mail/$DATE"
