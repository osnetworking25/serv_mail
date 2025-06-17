# 📦 Backup Script – Chapter 1

This script performs a **complete backup** of the essential files modified during **Chapter 1** of the mail server installation (Postfix base, hostname, DNS, etc.).

---

## 📁 Files Included in the Backup

- `/etc/hosts`
- `/etc/hostname`
- `/etc/resolv.conf`
- `/etc/postfix/` (entire directory)
- `/etc/mailname`
- `/etc/postfix/main.cf`
- `/etc/aliases`

---

# 🧱 Directory Structure

```bash
/opt/serv_mail/
├── chapitre01
│ ├── backup
│     └──backup_postfix_base_chap1.sh
│ ├── documentation
│ ├── export
│ ├── install
```

## 📍 Backup Location

Compressed archive files are saved in:
/opt/serv_mail/chapitre_01/backup/<your_domain>/backup_mail_chap1_YYYY-MM-DD_HHhMM.tar.gz


If an error occurs, a log file will be generated at:
/opt/serv_mail/chapitre_01/logs/backup_errors.log

## 🧑‍💻 Usage
Make the script executable:

```bash
chmod +x /opt/serv_mail/chapitre_01/backup/backup_postfix_base_chap1.sh
```

Run the script as superuser:

```bash
sudo /opt/serv_mail/chapitre_01/backup/backup_postfix_base_chap1.sh
```

ou will be prompted to:

Select your language (Français or English)

Enter your main domain name (e.g. domain.tld)

## 📌 Requirements
Must be run as superuser (sudo)

The following language files must exist:

```bash
/opt/serv_mail/lang/fr.sh
/opt/serv_mail/lang/en.sh
```

The following directories must exist (created automatically if missing):

```bash
/opt/serv_mail/chapitre_01/backup/
/opt/serv_mail/chapitre_01/logs/
```

Recommended script location:

```bash
/opt/serv_mail/chapitre_01/backup/
```

## 📤 Author

pontarlier-informatique – osnetworking
Version: 1.1 – 2025-06-17
