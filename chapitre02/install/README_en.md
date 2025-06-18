# 📘 Chapter 02 – Installing Postfix and Dovecot

This chapter walks you through the installation of a secure mail server on Ubuntu, following best practices from the LinuxBabe tutorial.

---

## 🧾 Steps performed in this script

1. 🔒 UFW firewall check and opening required ports
2. 📥 Install Certbot and Apache server
3. 🌐 Create Apache virtualhost + Let's Encrypt certificate
4. 📤 Install Postfix + enable ports 465/587 in master.cf
5. 📥 Install Dovecot (IMAP, POP3)
6. 💾 Enable Maildir format in Dovecot
7. 📬 Configure email delivery to message store via LMTP
8. 🔐 Set up SASL authentication (Postfix ↔︎ Dovecot)
9. 🧑‍💻 Configure Dovecot authentication mechanisms
10. 🔐 Configure TLS for Dovecot with Let's Encrypt certificates
11. 🛡️ Disable OpenSSL FIPS provider (Ubuntu 22.04)
12. 📡 Enable SASL socket listener for Postfix
13. ♻️ Auto-renewal of TLS certificate via Certbot (cron)
14. 🔍 Test TLS renewal with `--dry-run`
15. 🔁 Enable automatic Dovecot restart via systemd
16. 🔄 Restart Postfix and Dovecot services


---

## 📁 Related files

- `install/install_Postfix_et_Dovecot_chap2.sh` → Main installation script
- `lang/fr.sh` → French language file
- `lang/en.sh` → English language file

---

## 📌 Notes

- All messages are dynamic and multilingual
- Each step includes proper file backups (`.bak`)
- TLS certificate is obtained via Apache + Certbot (HTTP-01 challenge)
- IMAP test uses OpenSSL to verify secure port 993 (Dovecot)

---

## 👨‍💻 Author

**Pontarlier-Informatique** – _osnetworking_
