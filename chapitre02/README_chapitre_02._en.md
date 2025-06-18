# 📘 Mail Server 2025 – Chapter 02  
## Installing Postfix and Dovecot with TLS (Let's Encrypt)

---

## 🧭 Chapter Goal

This chapter details the complete installation of a basic mail server using **Postfix** (for sending emails) and **Dovecot** (for receiving via IMAP/POP3), with **Let's Encrypt TLS** encryption enabled from the start. It is designed for **professional use** on Ubuntu (22.04 or 24.04), with clear explanations, `.bak` backups before each change, and multilingual messages.

---

## 📋 Detailed Steps

### 1️⃣ UFW Firewall Check
The script checks if UFW is enabled. If so, it allows the necessary ports (25, 465, 587, 993, 443, etc.) to ensure that mail and web services function correctly. A simple but essential step to prevent network blocks.

### 2️⃣ Apache Installation + Certbot
Installs Apache, Certbot, and SSL modules to handle TLS certificate requests for the mail server. These tools allow future automation of certificate renewal.

### 3️⃣ TLS Certificate with Let's Encrypt
Automatically generates a TLS certificate with Certbot for your FQDN using Apache as the authenticator. Certbot will save the certificate in `/etc/letsencrypt/live/`.

### 4️⃣ Postfix Installation and master.cf Configuration
Installs Postfix, configures basic settings in `main.cf`, and enables submission (587) and smtps (465) services in `master.cf`.

### 5️⃣ Dovecot Installation
Installs the Dovecot core packages for IMAP and optional POP3 support, required for clients to retrieve emails.

### 6️⃣ Enable IMAP/POP3 Protocols
Configures Dovecot to enable the desired mail protocols in `dovecot.conf`.

### 7️⃣ Maildir Mailbox Format
Modifies `10-mail.conf` to switch from mbox to Maildir format, which stores emails as individual files for better performance and reliability.

### 8️⃣ LMTP Delivery via Dovecot
Configures Postfix to pass incoming mail to Dovecot using LMTP (Local Mail Transfer Protocol) via a UNIX socket. This ensures proper Maildir delivery.

### 9️⃣ Dovecot Authentication
Adjusts `10-auth.conf` to define how usernames are processed (`%n`) and allows both `plain` and `login` mechanisms.

### 🔟 TLS Settings in Dovecot
Configures `10-ssl.conf` to enforce TLS, replace the default self-signed certificate with the Let's Encrypt certificate, and disable weak protocols (SSLv3, TLSv1.0).

### 1️⃣1️⃣ Disable OpenSSL FIPS Provider
If using Ubuntu 22.04, disables OpenSSL’s FIPS provider in `openssl.cnf` to prevent TLS startup failures with Dovecot.

### 1️⃣2️⃣ SASL for Postfix (via Dovecot)
Configures `10-master.conf` so Postfix can use Dovecot’s SASL for SMTP authentication. A `unix_listener` socket is added for communication.

### 1️⃣3️⃣ Certbot Auto-Renewal
Adds a cron job for daily auto-renewal of the certificate and reloads Postfix/Dovecot/Apache after each renewal.

### 1️⃣4️⃣ Dry-Run Renewal Test
Executes a test of the auto-renewal system with `certbot renew --dry-run` to validate everything works before real expiration.

### 1️⃣5️⃣ Dovecot Auto-Restart via systemd
Adds a systemd override to ensure Dovecot restarts automatically on failure with a 5-second delay.

### 1️⃣6️⃣ Final Service Restart
Postfix and Dovecot are restarted to apply all configurations.

---

## 🗂️ Modified Configuration Files

```text
/etc/postfix/main.cf
/etc/postfix/master.cf
/etc/dovecot/dovecot.conf
/etc/dovecot/conf.d/10-mail.conf
/etc/dovecot/conf.d/10-auth.conf
/etc/dovecot/conf.d/10-ssl.conf
/etc/dovecot/conf.d/10-master.conf
/etc/systemd/system/dovecot.service.d/restart.conf
/etc/ssl/openssl.cnf
```

---

## 📦 Generated Files and Backups

- All modified files are backed up with `.bak_YYYYMMDD` before being overwritten.
- Temporary files and logs are stored under `/opt/serv_mail/Chapitre_2/install/` and `/logs/`.

---

## 🧱 Recommended Directory Structure

```text
/opt/serv_mail/
├── Chapitre_1/
├── Chapitre_2/
│   ├── install/
│   ├── maintenance/
│   ├── logs/
│   └── README_en.md
├── lang/
│   ├── fr.sh
│   └── en.sh
```

---

## ✍️ Author

**Pontarlier-Informatique – Osnetworking**  
📅 Last update: June 2025  