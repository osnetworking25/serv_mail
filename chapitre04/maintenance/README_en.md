# 🔁 SPF & DKIM Revert Script – Chapter 4

This script `revert_Dkim_Agent_Chap4.sh` performs a full rollback of all SPF & DKIM configuration changes made in Chapter 4 of the email server setup guide.

Use this script to:

- Reset DKIM/SPF configuration
- Clean up in case of misconfiguration
- Prepare for a fresh reinstallation

---

## 📝 Steps performed by the script

1. **Language file loading** (`fr.sh` or `en.sh`)  
   All user messages are dynamically translated according to your selected language.

2. **Package removal**  
   Fully purges the following packages:  
   - `opendkim`  
   - `opendkim-tools`  
   - `postfix-policyd-spf-python`

3. **Configuration file deletion**  
   The following directories are removed:
   - `/etc/opendkim/`
   - `/etc/postfix/sql/`
   - `/etc/default/opendkim`
   - `/var/log/opendkim`

4. **Postfix configuration cleanup**  
   Removes the SPF/DKIM-related blocks from `main.cf` and `master.cf`, as well as all milter settings using `postconf -X`.

5. **Optional removal of `export/` and `backup/` folders**  
   The script asks the user whether to delete export/backup directories under `/opt/serv_mail/chapitre_04/`.

---

## 💡 Possible improvements

- Add safety checks before removing files.
- Implement automatic backup before deletion.
- Add `--force` or `--dry-run` options.
- Use an external `.env` file to centralize paths and settings.

---

## 📁 Recommended location

Script should be placed under:

