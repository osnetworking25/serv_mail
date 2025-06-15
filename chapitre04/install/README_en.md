# 🇬🇧 README_en.md – Chapter 4: SPF & DKIM

## 📘 Purpose
This chapter configures SPF and DKIM to improve the deliverability of emails sent through Postfix.

## ⚙️ Requirements
- System: Ubuntu Server 22.04 recommended
- Root access (sudo)
- Required packages: `postfix`, `opendkim`, `opendkim-tools`, `postfix-policyd-spf-python`, `dig`

## ▶️ Example execution

```bash
sudo bash install_Dkim_Agent_Chap4.sh
```

## 🔢 Automated Steps

| Step | Action                 | Description                                                    |
|------|------------------------|----------------------------------------------------------------|
| 1    | SPF                    | Prompt to create a DNS TXT record                             |
| 2    | SPF Agent              | Install postfix-policyd-spf-python                            |
| 3    | DKIM                   | Install, configure and generate DKIM keys                     |
| 4    | Tables                 | Create signing.table, key.table, and trusted.hosts files      |
| 5    | Key Pair               | Generate public/private key pair for the domain               |
| 6    | DNS                    | Extract public key and prepare DNS TXT entry                  |
| 7    | DKIM Test              | Run dig and opendkim-testkey to validate key setup            |
| 8    | OpenDKIM Socket        | Link OpenDKIM and Postfix via UNIX socket                     |
| 9    | Final Test             | Send test email to Gmail / Mail-tester                        |

## 📂 File Structure

```
/opt/serv_mail/Chapitre_4/
├── script/
│   └── install_Dkim_Agent_Chap4.sh
├── maintenance/
│   └── revert_Dkim_Agent_Chap4.sh
├── export/
│   └── domain.tld/
│       ├── default.txt
│       ├── txt_dns_default_dkim.txt
│       └── logs/
├── backup/
├── documentation/
│   ├── tuto_LB_site_officiel_Chap4_fr.md
│   └── tuto_LB_site_officiel_Chap4_en.md
├── README_fr.md
└── README_en.md
```

## 🧑‍💻 Author
Pontarlier-Informatique / osnetworking  
https://github.com/osnetworking25

## 🪪 License
MIT (planned)

---

📝 This project is licensed under the [MIT License](../LICENSE).
© 2025 osnetworking / pontarlier-informatique
