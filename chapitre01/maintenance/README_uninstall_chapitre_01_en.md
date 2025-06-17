# 🧹 Chapter 1 – Uninstalling Basic Postfix Configuration

This script cleanly removes the initial Postfix configuration set up during **Chapter 1** of the `serv_mail` project.

---

## 🧱 Script Structure

The script `uninstall_postfix_base_chap1.sh` performs the following actions:

1. ✅ Checks whether Postfix is installed and offers to remove it
2. 💾 Backs up the configuration files `main.cf` and `aliases`
3. 🗑️ Cleans up `/etc/hosts`, `main.cf`, and `aliases`
4. 📁 Keeps the `logs/` and `backup/` directories created during Chapter 1
5. ⚠️ Does not alter system permissions or files beyond those explicitly listed

---

## 🚨 Warnings

- This script is **destructive**: it deletes or modifies system configuration files.
- Locally stored emails may be lost if Postfix is removed.
- Backups located in `/opt/serv_mail/chapitre_01/backup/` and logs under `/logs/` are **not deleted automatically**.
- Use only in a test environment or when planning a full reinstallation.

---

## ▶️ Running the Script

```bash
sudo bash /opt/serv_mail/chapitre_01/maintenance/uninstall_postfix_base_chap1.sh
```
You will be prompted to:

Select your language (Français or English)

Confirm the removal of Postfix if it is installed


## ⚠️ Important

This script is destructive and should only be used if you intend to fully roll back the actions from Chapter 1.

## 📂 Recommended Location

/opt/serv_mail/chapitre_01/maintenance/uninstall_postfix_base_chap1.sh

##  📘 Language Support

Multilingual support is included via:

```bash
/opt/serv_mail/lang/fr.sh
/opt/serv_mail/lang/en.sh
```

Messages and prompts are displayed according to the selected language.

## 🧑 Author

pontarlier-informatique – osnetworking

## 🛠 Tested with
Ubuntu 22.04 LTS

Postfix 3.6.4

Script version 1.1 – Chapter 1 uninstall process














