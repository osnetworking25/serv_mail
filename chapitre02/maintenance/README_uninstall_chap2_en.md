# 🧹 Uninstall Script – Chapter 2: Postfix & Dovecot

This Bash script reverts **all system changes made during Chapter 2**, which covered the installation of **Postfix with TLS** and **Dovecot with Maildir**.

It restores the system to the exact same state as **the end of Chapter 1**, without touching the PostfixAdmin database or other previous chapters.

---

## 📦 Script name

```bash
uninstall_chap2.sh
```

---

## 🎯 Script goal

This script will:

- Restore all configuration files modified in Chapter 2 using `.original` backups
- Remove services installed during this chapter: Dovecot, Apache, Certbot
- Revert TLS configuration and the Dovecot service as if never installed
- Remove automatic restart configuration for Dovecot
- Restore root’s crontab if it was changed
- Restart services to ensure clean operational state

---

## 🔁 Steps performed by the script

1. Loads language file `fr.sh` or `en.sh` based on your choice
2. Defines `DOMAIN` and backup directory `BACKUP_DIR`
3. Restores system configuration files:
   - `/etc/dovecot/dovecot.conf`
   - `/etc/dovecot/conf.d/10-*.conf` (mail, auth, ssl, master)
   - `/etc/postfix/main.cf`
   - `/etc/postfix/master.cf`
   - `/etc/ssl/openssl.cnf`
4. Restores root's crontab if available
5. Removes Dovecot auto-restart config (`restart.conf`)
6. Removes Apache vhost file and uninstalls Certbot + Apache
7. Completely purges Dovecot and its modules (imap, pop3, lmtp)
8. Restarts Postfix and Dovecot for clean reload
9. Displays final success message

---

## 📂 Requirements

The `.original` backups must exist inside:

```bash
/opt/serv_mail/chapitre02/backup/${DOMAIN}
```

---

## ⚠️ Important warnings

This script restores system configuration files **based on `.original` backups created during Chapter 2**. It is designed to revert your system to a stable state identical to the end of Chapter 1, just before Dovecot and TLS were introduced.

At this point in the documentation (Chapter 2), **no virtual mailboxes or users have been created** via PostfixAdmin. Therefore, this script does **not touch the PostfixAdmin database**, and does not remove any domain or mailbox because they do **not yet exist**.

However, it is **strongly recommended** to manually check the following files and directories after running the script to ensure clean restoration:

- `/etc/postfix/main.cf` → should only contain Chapter 1 settings (no TLS, no milters, no dovecot LDA)
- `/etc/postfix/master.cf` → same: no dovecot or modified submission lines
- `/etc/dovecot/` → should be removed or restored to default if present
- `/etc/apache2/sites-available/` → `$DOMAIN.conf` must not remain
- `/etc/systemd/system/dovecot.service.d/restart.conf` → should be deleted
- `/etc/ssl/openssl.cnf` → should be restored if previously altered
- `/var/spool/cron/crontabs/root` → should match the saved backup

This script does **not remove Postfix or its base configuration** from Chapter 1. It does not empty PostfixAdmin’s database, nor does it delete any project script or documentation.

Finally, this script **does not handle manual customizations** you may have made to TLS settings, Apache configuration, Dovecot behavior, or certificates. If in doubt, restore those files manually from your own backups or from a clean Chapter 1 state.

---

🟢 If you've followed all chapters carefully, this script is sufficient to restore your system to a clean state matching the end of Chapter 1: Postfix is installed, but no TLS, no Dovecot, no Apache — ready for the next steps.

---

## 📘 Multilingual support

All messages are displayed using either:

- `/opt/serv_mail/lang/fr.sh`
- `/opt/serv_mail/lang/en.sh`

---

## 🧑 Author

**pontarlier-informatique – osnetworking**

---

## 🛠 Tested with

- Ubuntu Server 22.04 LTS
- Postfix 3.6.4
- Dovecot 2.3
- Apache 2.4
- Certbot (snap or apt)

---

📌 Version 1.0 – Validated on June 18, 2025