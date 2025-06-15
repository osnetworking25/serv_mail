# 📦 Uninstall Script – Postfix Base (Chapter 1)
This script is designed to **fully revert** all changes made during Chapter 1 of the mail server installation.

## 📁 File
- `uninstall_chapitre1.sh`

## 🔄 Purpose
The script will:
- Restore original backup of `/etc/hosts` if available.
- Restore original `/etc/postfix/main.cf` configuration.
- Remove Postfix and associated packages.
- Delete logs and backups created during installation.
- Optionally purge the aliases file or revert it to a known clean state.

## ⚠️ Warning
This script is **destructive** and should only be used if you intend to completely roll back Chapter 1.

## 📌 Usage

```bash
sudo bash /opt/serv_mail/chapitre_01/maintenance/uninstall_chapitre1.sh
```

## 📘 Language Support
Multi-language support via `/opt/serv_mail/lang/fr.sh` and `en.sh`. Prompts and messages are displayed based on your selected language.

## 🧑 Author
pontarlier-informatique – osnetworking

## 🛠 Tested With
- Ubuntu 22.04 LTS
- Postfix 3.6.4

---
> Script version 1.0 – for Chapter 1 uninstall process.