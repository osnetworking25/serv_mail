# 📘 Chapitre 4 – Configuration SPF & DKIM pour Postfix (LinuxBabe)

Ce dossier contient tous les scripts, journaux et fichiers exportés liés à la configuration de **SPF & DKIM** conformément au tutoriel :

📚 https://www.linuxbabe.com/mail-server/setting-up-dkim-and-spf

## 📂 Arborescence

```
/opt/script/Chapitre_4/
├── install_Dkim_Agent_Chap4.sh       # Script principal de configuration SPF/DKIM (interactif)
├── README_fr.md                      # Documentation (français)
├── README_en.md                      # Documentation (anglais)
├── export/                           # Données exportées (enregistrements DNS, clés publiques)
│   └── domain.tld/                   # Un sous-dossier par domaine
│       ├── default.txt               # Clé publique DKIM brute
│       ├── txt_dns_default_dkim.txt # Version nettoyée pour DNS
│       └── key-check.log             # Log du test DKIM
├── logs/                             # Journaux d’exécution, rapports de test
│   └── dkim_test.log                 # Log du test DKIM
├── maintenance/                      # Scripts de purge, test, revert
│   └── revert_Dkim_Agent_Chap4.sh   # Script de suppression de la configuration
├── script_backup/                    # Sauvegardes optionnelles ou anciennes versions
└── script_file/                      # Fichiers intermédiaires temporaires (si besoin)
```

## 📋 Notes

- `export/` est créé automatiquement par le script principal, un dossier par domaine (ex. `osnetworking.com`)
- Toutes les données DKIM et chaînes DNS sont stockées ici pour sauvegarde et réutilisation
- Le dossier `maintenance/` contient les scripts de réversibilité et de vérification

## 🔐 Sécurité

La clé privée `default.private` **n’est jamais stockée ici**. Elle reste dans :
```
/etc/opendkim/keys/domain.tld/default.private
```

Les permissions (640) et le propriétaire `opendkim:opendkim` sont vérifiés automatiquement.

## 🇬🇧 English version ?

See file `README_en.md`.