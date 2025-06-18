# 📘 Documentation complète – Chapter 2 : Installation de Postfix (TLS) et Dovecot (IMAP/POP3)

---

## 🎯 Objectif du chapitre

Ce chapitre vous guide dans la mise en place d’un serveur mail sécurisé sous Ubuntu, capable d’envoyer et de recevoir des e-mails via Postfix et Dovecot, avec support TLS (Let’s Encrypt) et format de stockage Maildir.

Vous apprendrez à configurer manuellement un serveur de messagerie basique mais sécurisé en utilisant **Postfix** pour l’envoi des emails et **Dovecot** pour la réception via **IMAP**/**POP3**, le tout en **chiffrement TLS** avec des certificats **Let’s Encrypt**.

Ce guide est conçu pour un niveau **débutant à avancé**, et chaque command est expliquée. À la fin, votre serveur sera capable de recevoir et d’envoyer des mails avec chiffrement, pour un seul domaine.


---

## 🚀 Deux méthodes d’installation

| Méthode         | Description |
|-----------------|-------------|
| 🧠 **Manuelle** | Steps réalisées une par une à la main. Recommandée pour comprendre chaque fichier et chaque configuration. |
| 🤖 **Scriptée** | Exécution du script `install_Postfix_et_Dovecot_chap2.sh` pour automatiser les étapes avec supervision et sauvegarde intégrée. |

---


## 📂 Organisation du Chapter 2

| Section | Description |
|--------|-------------|
| 1️⃣ | Configuration des ports et du pare-feu |
| 2️⃣ | Installation d'Apache + Certbot pour TLS |
| 3️⃣ | Configuration Apache temporaire pour valider le domaine |
| 4️⃣ | Obtention du certificat Let's Encrypt |
| 5️⃣ | Installation et configuration de Postfix |
| 6️⃣ | Activation de TLS sur Postfix |
| 7️⃣ | Activation du port submission (587) |
| 8️⃣ | Installation de Dovecot |
| 9️⃣ | Configuration du format Maildir |
| 🔟 | Activation de TLS dans Dovecot |
| 1️⃣1️⃣ | Authentification Dovecot |
| 1️⃣2️⃣ | Intégration Postfix ↔ Dovecot via LMTP |
| 1️⃣3️⃣ | Configuration complémentaire Maildir dans Postfix |
| 1️⃣4️⃣ | Tests finaux, redémarrage, vérification |


---

## 🧱 Prérequis

- Ubuntu 22.04 ou supérieur
- Un domain name pointant vers votre serveur (ex: `mail.domain.tld`)
- Avoir terminé le Chapitre 1 (hostname, DNS, reverse DNS, mise à jour système)

---

## 🛠 Manual Installation – Steps détaillées

---
## 🛠 Steps détaillées

### 1️⃣ Ouvrir les ports nécessaires

```bash
ufw allow OpenSSH
ufw allow 25,587,993/tcp
ufw reload
```

Cela permet les connexions SMTP (25, 587) et IMAPS (993).

---

### 2️⃣ Installer Apache et Certbot

Apache est utilisé temporairement pour valider le domaine avec Let’s Encrypt.

```bash
apt install apache2 certbot python3-certbot-apache -y
```

---

### 3️⃣ Configurer un vhost Apache

Créez le fichier `/etc/apache2/sites-available/mail.domain.tld.conf` :

```apache
<VirtualHost *:80>
    ServerName mail.domain.tld
    DocumentRoot /var/www/html
</VirtualHost>
```

Activez le site :

```bash
a2ensite mail.domain.tld
systemctl reload apache2
```

---

### 4️⃣ Obtenir un certificat TLS

```bash
certbot --apache -d mail.domain.tld
```

Après validation, le certificat est généré dans `/etc/letsencrypt/live/mail.domain.tld/`.

---

### 5️⃣ Installer Postfix

```bash
apt install postfix -y
```

Lors du prompt, choisissez "Site Internet" et entrez `mail.domain.tld`.

---

### 6️⃣ Configurer TLS pour Postfix

Dans `/etc/postfix/main.cf`, ajoutez :

```bash
smtpd_tls_cert_file=/etc/letsencrypt/live/mail.domain.tld/fullchain.pem
smtpd_tls_key_file=/etc/letsencrypt/live/mail.domain.tld/privkey.pem
smtpd_use_tls=yes
smtpd_tls_auth_only=yes
```

---

### 7️⃣ Activer le port 587

Dans `/etc/postfix/master.cf`, décommentez le bloc `submission` et ajoutez :

```bash
-o smtpd_tls_security_level=encrypt
-o smtpd_sasl_auth_enable=yes
```

---

### 8️⃣ Installer Dovecot

```bash
apt install dovecot-core dovecot-imapd dovecot-pop3d dovecot-lmtpd -y
```

---

### 9️⃣ Configurer le format Maildir

Dans `/etc/dovecot/conf.d/10-mail.conf` :

```bash
mail_location = maildir:~/Maildir
```

---

### 🔟 Activer TLS dans Dovecot

Dans `/etc/dovecot/conf.d/10-ssl.conf` :

```bash
ssl = yes
ssl_cert = </etc/letsencrypt/live/mail.domain.tld/fullchain.pem
ssl_key = </etc/letsencrypt/live/mail.domain.tld/privkey.pem
```

---

### 1️⃣1️⃣ Authentification

Dans `/etc/dovecot/conf.d/10-auth.conf` :

```bash
disable_plaintext_auth = yes
auth_mechanisms = plain login
```

---

### 1️⃣2️⃣ Intégration LMTP (Postfix → Dovecot)

Dans `/etc/dovecot/conf.d/10-master.conf`, ajoutez dans la section `service lmtp` :

```bash
unix_listener /var/spool/postfix/private/dovecot-lmtp {
  mode = 0600
  user = postfix
  group = postfix
}
```

---

### 1️⃣3️⃣ Configuration complémentaire dans Postfix

Ajoutez dans `/etc/postfix/main.cf` :

```bash
home_mailbox = Maildir/
```

---

### 1️⃣4️⃣ Redémarrer et tester

```bash
systemctl restart postfix
systemctl restart dovecot
```

Envoyez un email local :

```bash
echo "Test Chapter 2" | mail -s "Maildir OK" user
```

Vérifiez avec `ls ~/Maildir/new`.

---

## 🧼 Uninstallation (facultatif)

Si vous souhaitez revenir à l’état du chapitre 1, utilisez :

```bash
/opt/serv_mail/Chapitre_2/uninstall_chap2.sh
```

---

## 🤖 Installation automatisée

Si vous souhaitez exécuter toutes les étapes ci-dessus automatiquement :

```bash
/opt/serv_mail/Chapitre_2/install_Postfix_et_Dovecot_chap2.sh
```

Ce script gère la sauvegarde, la configuration, et l’interaction dans votre langue.

---

## 📂 Directory de sauvegarde

Les fichiers modifiés sont sauvegardés dans :

```bash
/opt/serv_mail/chapitre02/backup/${DOMAIN}
```

---

## 🤖 Installation avec script (automatisée)

Si vous préférez automatiser toutes ces étapes avec contrôle interactif, exécutez le script :

```bash
/opt/serv_mail/Chapitre_2/install_Postfix_et_Dovecot_chap2.sh
```

Le script est interactif, propose la langue (fr/en), sauvegarde les fichiers modifiés, et vous guide étape par étape.

📘 Voir :
- `README_fr.md` pour les explications détaillées en français
- `README_en.md` pour la version anglaise

---

## 🧼 Uninstallation et retour à l’état du Chapitre 1

Pour annuler tous les changements du Chapter 2 et restaurer le système dans l’état du Chapitre 1 :

```bash
/opt/serv_mail/Chapitre_2/uninstall_chap2.sh
```

Ce script restaure les fichiers `.original`, désinstalle Dovecot, Apache, Certbot, et redémarre Postfix proprement.

---

👤 Auteur : pontarlier-informatique – osnetworking  
📅 Dernière mise à jour : 18 juin 2025