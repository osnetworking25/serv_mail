# 📬 Mail Server 2025 – Complete Configuration (Ubuntu + Postfix + Dovecot)

> 🔒 Professional multi-domain mail server based on [LinuxBabe's guide](https://www.linuxbabe.com)

---

## 🔧 Project Overview

This repository provides a fully structured and automated mail server setup with:

- **Postfix**, **Dovecot**, **MariaDB**
- **SPF**, **DKIM**, **DMARC**
- **PostfixAdmin**, **Roundcube**
- **Let's Encrypt**, **Fail2Ban**, **Cron jobs**
- **Multi-domain**, multilingual, modular architecture

Each step is split into dedicated folders with scripts and language files:
- Fully interactive
- Designed for production usage
- With backup and restore support

---

## 📁 Repository Structure

|--------------------|----------------------------------------------------------------------|
| Folder             | Content Description                                                  |
|--------------------|----------------------------------------------------------------------|
| `chapitre_01/`     | Base system setup,                  |
| `chapitre_02/`     | Mail server DNS records and TLS certificate preparation              |
| `chapitre_03/`     | Postfix virtual mailbox setup using PostfixAdmin and MariaDB         |
| `chapitre_04/`     | SPF and DKIM signing with OpenDKIM integration                       |
| `chapitre_05/`     | PostfixAdmin secure installation and domain/user management          |
| `chapitre_06/`     | Deliverability improvement and anti-spam best practices              |
| `chapitre_07/`     | Roundcube webmail configuration with plugin extensions               |
| `chapitre_08/`     | Multi-domain support with Postfix and PostfixAdmin                   |
| `chapitre_09/`     | Postfix-level spam filtering and blacklist protection                |
| `chapitre_10/`     | Advanced filtering with SpamAssassin integration                     |
| `chapitre_11/`     | Antivirus setup with Amavis and ClamAV for email scanning            |
| `chapitre_12/`     | Protecting mail server with self-hosted VPN and network restrictions |
| `chapitre_13/`     | Preventing blacklisting and improving IP/domain reputation           |
| `chapitre_14/`     | (Optional) Postscreen configuration to block spam bots               |
| `chapitre_15/`     | Automated warm-up of IP and domain reputation                        |
| `lang/`            | Multilingual language files for script output (`fr.sh`, `en.sh`)     |
| `LICENSE`          | Project license (MIT)                                                |
| `README.md`        | This file – Global English overview                                  |
| `README.fr.md`     | Global project overview in French                                    |


Each `chapitre_XX/` folder includes:

- `backup/` → automated or manual backups  
- `documentation/` → chapter-specific README files (fr/en)  
- `export/` → exported keys or data (e.g. DKIM TXT)  
- `logs/` → script logs and debug outputs  
- `maintenance/` → revert/rollback scripts  
- `script/` → installation and configuration scripts

---

## 🔄 Revert Support

♻️ **Rollback-ready**:  
Each critical configuration script includes a matching `revert_*.sh` script to safely undo all changes (services, keys, config files).

Example:

```bash
/chapitre_04/maintenance/revert_Dkim_Agent_Chap4.sh

---
🔄 Backup & Restore Strategy (multi-level)
Each chapter may include:

backup/ folder → automatic or manual backup scripts, exported config or DKIM keys

maintenance/ folder → revert/uninstall scripts (e.g. revert_Dkim_Agent_Chap4.sh)

logs/ folder → log files for debugging or auditing

🔐 Final backup strategy will be consolidated in a dedicated section
after all 15 chapters are completed, including:

Full system backup (mail, DB, DNS, SSL)

Automated rsync/NAS backup jobs

Restore guide for production failures or migrations

You’ll find this in chapitre_15/ once the full setup is complete.

---
## 🌍 Language Support

The scripts support both French and English with a prompt at launch:

```bash
🌐 Choose your language / Choisissez votre langue :
fr (Français) / en (English)
