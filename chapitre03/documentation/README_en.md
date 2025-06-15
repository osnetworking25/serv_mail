# 📘 Chapter 4 – DKIM & SPF Configuration for Postfix (LinuxBabe)

This folder contains all scripts, logs, and export files related to setting up **SPF & DKIM** in line with the tutorial:

📚 https://www.linuxbabe.com/mail-server/setting-up-dkim-and-spf

## 📂 Structure

```
/opt/script/Chapitre_4/
├── install_Dkim_Agent_Chap4.sh       # Main script to configure SPF/DKIM (interactive)
├── README_fr.md                      # Documentation (French)
├── README_en.md                      # Documentation (English)
├── export/                           # Exported data (DNS records, public keys)
│   └── domain.tld/                   # One subfolder per domain
│       ├── default.txt               # DKIM public key raw
│       ├── txt_dns_default_dkim.txt # Cleaned version for DNS
│       └── key-check.log             # Log from opendkim-testkey
├── logs/                             # Runtime logs, test reports
│   └── dkim_test.log                 # Log from DKIM test
├── maintenance/                      # Revert, test, cleanup scripts
│   └── revert_Dkim_Agent_Chap4.sh   # Script to undo the configuration
├── script_backup/                    # Optional backups or older script versions
└── script_file/                      # Temporary intermediate files (if needed)
```

## 📋 Notes

- `export/` is created automatically by the main script, one folder per domain (e.g. `osnetworking.com`)
- All DKIM data and DNS strings are safely stored there for reuse and backup
- `maintenance/` contains utility scripts for reverting or testing

## 🔐 Security

The private key `default.private` is never stored here. It stays under:
```
/etc/opendkim/keys/domain.tld/default.private
```

Rights are checked (640), and ownership is set to `opendkim:opendkim`.

## 🇫🇷 Version française ?

See the file `README_fr.md`.