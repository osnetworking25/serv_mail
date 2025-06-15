# 📬 Mail Server 2025 – Complete Configuration (Ubuntu + Postfix + Dovecot + Roundcube + secuité)

> 🔒 Professional multi-domain mail infrastructure, based on [LinuxBabe's guide](https://www.linuxbabe.com)

---

## 🔧 Project Overview

This repository provides a **modular**, **interactive**, and **multilingual** structure to configure a production-ready mail server:

- **Postfix**, **Dovecot**, **MariaDB**
- **SPF**, **DKIM**, **DMARC**
- **PostfixAdmin**, **Roundcube**
- **Let's Encrypt SSL**, **Fail2Ban**, **Cron jobs**
- **Multi-domain support**, organized by **chapter**

> 💡 Each chapter is independent, documented, and can be safely **rolled back** via a `revert_*.sh` script.

🧰 Ideal for system administrators, self-hosters, and IT professionals.

---

## 📁 Repository Structure

```bash
/opt/serv_mail/
├── chapitre_01/           # Ubuntu Ubuntu installation and SSH configuration 
├── chapitre_02/           # Network setup and DNS configuration
├── chapitre_03/           # Postfix + Dovecot (IMAP) with TLS
├── chapitre_04/           # SPF & DKIM via OpenDKIM
├── chapitre_05/           # PostfixAdmin installation and setup
├── chapitre_06/           # Improving email deliverability (anti-spam)
├── chapitre_07/           # Roundcube Webmail + plugins
├── chapitre_08/           # Multi-domain mail server management
├── chapitre_09/           # Advanced anti-spam filtering with Postfix
├── chapitre_10/           # SpamAssassin filtering
├── chapitre_11/           # Amavis + ClamAV integration
├── chapitre_12/           # Server security with self-hosted VPN
├── chapitre_13/           # Mail reputation and blacklist management
├── chapitre_14/           # Postscreen (SMTP bot filtering)
├── chapitre_15/           # Automatic IP/domain warm-up + backup
│
├── lang/                  # Dynamic language files
│   ├── fr.sh              # French messages
│   └── en.sh              # English messages
│
├── LICENSE                # MIT license
├── README.md              # Global presentation (English)
└── README.fr.md           # Global presentation (French)
```

---

## 📚 Chapter Breakdown

| Folder         | Chapter Contents                                                  |
|----------------|--------------------------------------------------------------------|
| `chapitre_01/` | Ubuntu installation and SSH configuration                          |
| `chapitre_02/` | Network settings and DNS records                                   |
| `chapitre_03/` | Postfix and Dovecot configuration                                  |
| `chapitre_04/` | SPF & DKIM setup using OpenDKIM                                   |
| `chapitre_05/` | PostfixAdmin setup and domain management                           |
| `chapitre_06/` | Deliverability improvements and spam protection                    |
| `chapitre_07/` | Roundcube Webmail customization and plugin integration             |
| `chapitre_08/` | Multi-domain support and virtual mailbox routing                   |
| `chapitre_09/` | Blocking spam with Postfix rules                                   |
| `chapitre_10/` | Adding SpamAssassin to filter incoming mail                        |
| `chapitre_11/` | Virus filtering with Amavis and ClamAV                             |
| `chapitre_12/` | Protecting mail server via self-hosted VPN                         |
| `chapitre_13/` | Improving IP/domain reputation, avoiding blacklists                |
| `chapitre_14/` | (Optional) Postscreen to block spambots                            |
| `chapitre_15/` | Warm-up automation + full backup strategy                          |
| `lang/`        | Language translation files (`fr.sh`, `en.sh`)                      |
| `LICENSE`      | MIT License                                                        |
| `README.md`    | English global documentation                                       |
| `README.fr.md` | French global documentation                                        |

---

## ♻️ Revert Support

Each important chapter includes a `revert_*.sh` script to safely undo changes:

- Deletes config files, keys, and packages
- Offers to preserve export/backup files with a confirmation prompt
- Fully supports multilingual prompts

✨ Enables safe testing and rollback per chapter, no risk to full setup.

---

## 🛡️ Backup Strategy

A full backup strategy will be included in `chapitre_15`:

- 📦 Full backup (mailboxes, databases, configs)
- 🔄 Restore automation
- 🔗 Synology NAS / Rsync / SFTP support
- 📋 Logging & validation

---

## 🌍 Language Support

At script launch, users are prompted to select a language:

```bash
🌐 Choose your language / Choisissez votre langue :
fr (Français) / en (English)
```

All script messages are automatically translated according to the selection (via `fr.sh` / `en.sh`).

---

## 🧑‍💻 Author

Pontarlier-Informatique / osnetworking  
🔗 https://github.com/osnetworking25

---

## 🪪 License

📝 This project is licensed under the MIT License.  
© 2025 osnetworking / pontarlier-informatique
