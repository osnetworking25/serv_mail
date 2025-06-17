# 📘 Chapter 1 – Installing and Configuring Basic Postfix

This chapter installs and configures **Postfix** to handle basic email sending on your server, following the **LinuxBabe** tutorial with professional improvements for production use.

---

## 🎯 Goal

The goal is to set up a fully functional **Postfix SMTP server** with a **custom domain**, clean configuration, and proper maintenance tools.

---

## ⚙️ Requirements

- A **valid domain name** (e.g., `example.com`)
- A **Ubuntu server** (22.04 recommended)
- A **TLS/SSL certificate** (Let's Encrypt or equivalent)
- **Root or sudo privileges**
- Correct DNS setup (A / MX / SPF / DKIM records recommended)

---

## 🧱 Directory Structure

```bash
/opt/serv_mail/
├── chapitre_01
│   ├── install/
│   │   └── install_postfix_base_chap1.sh     # Installation script
│   ├── backup/
│   │   └── backup_postfix_base_chap1.sh      # Backup script
│   ├── maintenance/
│   │   └── uninstall_postfix_base_chap1.sh   # Uninstall script
│   ├── logs/                                 # Logs from install and backup
│   ├── export/                               # Exported files (DNS, keys, etc.)
│   ├── documentation/
│   │   ├── README_chapitre_01_fr.md
│   │   └── README_chapitre_01_en.md
│   └── README_fr.md / README.md              # Simplified doc
```


## 🚀 Running the Installation Script

## 1. 📁 Script Location

Place install_postfix_base_chap1.sh in:

```bash
/opt/serv_mail/chapitre_01/install/
```

## 2. ✅ Make it Executable

```bash
chmod +x install_postfix_base_chap1.sh
```

## 3. ▶️ Run the Installation

```bash
sudo ./install_postfix_base_chap1.sh
```

## 💾 Backup Script

After installing the mail server, run the backup script to save critical files:

```bash
sudo /opt/serv_mail/chapitre_01/backup/backup_postfix_base_chap1.sh
```

Files backed up include:

/etc/hosts

/etc/hostname

/etc/resolv.conf

/etc/postfix/

/etc/mailname

/etc/aliases

Backups are saved in:

```bash
/opt/serv_mail/chapitre_01/backup/<domain>/backup_mail_chap1_<date>.tar.gz
```

# 🧹 Uninstall Script (Rollback / Cleanup)

If needed (for testing, reset, reinstallation), run the uninstall script:

```bash
sudo /opt/serv_mail/chapitre_01/maintenance/uninstall_postfix_base_chap1.sh
```

Features:

Performs a pre-deletion backup

Cleans /etc/hosts, main.cf, and aliases

Offers optional Postfix removal

Fully multilingual and interactive

## 🗂️ Files Modified

/etc/postfix/main.cf

/etc/aliases

/etc/hosts

/etc/hostname

/etc/resolv.conf

## 🔐 Next Steps

Test sending email via Postfix (mail or sendmail)

Install Dovecot (Chapter 2) for receiving emails

Secure your mail setup with SPF, DKIM, DMARC (Chapter 4)

Add a mail admin UI like PostfixAdmin (Chapter 3)

## 🧑‍💼 Author

pontarlier-informatique

Project: Osnetworking

Last updated: 2025-06-17

Based on LinuxBabe, fully adapted with logs, structure, and maintenance scripts

##  🌐 References
Osnetworking Guide – Chapter 1


















