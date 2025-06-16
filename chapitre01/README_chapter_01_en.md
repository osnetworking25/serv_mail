# 📘 Chapter 1 – Basic Postfix Installation

This script sets up a basic Postfix mail server on Ubuntu, following best practices inspired by the LinuxBabe guide but adapted for professional, reproducible deployment.

---

## 🎯 Objective

Install a local SMTP server (Postfix) on Ubuntu, including:

- Fully qualified domain name (FQDN)
- Essential DNS records (MX, SPF, DMARC)
- Postfix base configuration
- Email delivery testing (local and external)
- Optional IPv4-only mode
- Security basics (aliases, mail size limit)

---

## ⚙️ Prerequisites

- Ubuntu 22.04+ server
- Root privileges (sudo)
- Registered domain name (with DNS access)
- Port 25 open for outbound traffic (mandatory for sending)

---

## 🧱 File Structure

```bash
/opt/serv_mail/
├── chapitre_01
│   ├── backup/
│   ├── documentation/
│   ├── export/
│   ├── install/
│   │   └── install_postfix_base_chap1.sh
│   ├── logs/
│   ├── maintenance/
│   │   └── uninstall_postfix_base_chap1.sh
│   ├── README.md
│   └── README_fr.md
```

---

## 🚀 How to Run the Script

### 1. 📁 Copy the script

```bash
sudo mkdir -p /opt/serv_mail/chapitre_01/
sudo cp install_postfix_base_chap1.sh /opt/serv_mail/chapitre_01/
```

### 2. ✅ Make it executable

```bash
sudo chmod +x /opt/serv_mail/chapitre_01/install_postfix_base_chap1.sh
```

### 3. ▶️ Launch it

```bash
sudo /opt/serv_mail/chapitre_01/install_postfix_base_chap1.sh
```

You will be prompted to enter:

- Interface language (French or English)
- Primary domain name (domain.tld)
- Sender email address
- Destination test email (your Gmail or personal email)
- Server FQDN (e.g. mail.domain.tld)

---

## ⚙️ Script Workflow (Automated Steps)

| Step | Description |
|------|-------------|
| 1    | Ask for domain name |
| 2    | Register FQDN in `/etc/hosts` |
| 3    | Set system hostname |
| 4    | Display and check DNS records |
| 5    | Install Postfix + verify version/port |
| 6    | Check if UFW is active |
| 7    | Outgoing port 25 connectivity test (telnet) |
| 8    | Send test email using `sendmail` |
| 9    | Send test email using `mailutils` |
| 10   | Configure `message_size_limit` |
| 11   | Set `myhostname` in main.cf |
| 12   | Configure email aliases (RFC 2142) |
| 13   | IPv4 / IPv6 protocol selection |
| 14   | Restart Postfix |
| 15   | Save `.bak` config files |

---

## 🗂️ Files Created or Updated

- Logs: `/opt/serv_mail/chapitre_01/logs/install_postfix_base_chap1.log`
- Backups:
  - `/etc/postfix/main.cf.bak`
  - `/etc/aliases.bak`

---

## 🧩 Next Steps

After verifying that emails are being sent and received properly, continue with:

👉 **Chapter 2 – Dovecot + Maildir Configuration**

---

## 👤 Author

- **Maintainer:** pontarlier-informatique  
- **Project:** Osnetworking  
- **Date:** 14/06/2025
