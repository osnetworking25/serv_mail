# 🇫🇷 README_fr.md – Chapitre 4 : SPF & DKIM

## 📘 Objectif
Ce chapitre configure SPF et DKIM pour renforcer la délivrabilité des e-mails envoyés via Postfix.

## ⚙️ Prérequis
- Système : Ubuntu Server 22.04 recommandé
- Accès root (sudo)
- Paquets requis : `postfix`, `opendkim`, `opendkim-tools`, `postfix-policyd-spf-python`, `dig`

## ▶️ Exemple d'exécution

```bash
sudo bash install_Dkim_Agent_Chap4.sh
```

## 🔢 Étapes automatisées

| Étape | Action                 | Description                                                  |
|-------|------------------------|--------------------------------------------------------------|
| 1     | SPF                    | Demande de création d’un enregistrement DNS                 |
| 2     | Agent SPF              | Installation de postfix-policyd-spf-python                  |
| 3     | DKIM                   | Installation, configuration, génération de clé              |
| 4     | Tables                 | Création des fichiers signing.table, key.table, trusted.hosts |
| 5     | Clés                   | Génération des paires de clés par domaine                   |
| 6     | DNS                    | Extraction de la clé publique + enregistrement DNS          |
| 7     | Vérification DKIM      | Test avec dig et opendkim-testkey                           |
| 8     | Socket OpenDKIM        | Connexion entre Postfix et OpenDKIM                         |
| 9     | Test final             | Envoi de mails vers Gmail / Mail-tester                     |

## 📂 Arborescence

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

## 🧑‍💻 Auteur
Pontarlier-Informatique / osnetworking  
https://github.com/osnetworking25

## 🪪 Licence
MIT (prévue)

---

📝 Ce projet est publié sous licence [MIT](../LICENSE).
© 2025 osnetworking / pontarlier-informatique
