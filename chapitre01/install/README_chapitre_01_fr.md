# 📘 Chapitre 1 – Installation et configuration de Postfix (base)

Ce chapitre installe et configure **Postfix** pour les fonctionnalités de base d'un serveur de messagerie, en suivant le guide **LinuxBabe**, avec des améliorations professionnelles supplémentaires pour une utilisation en production.

---

## 🎯 Objectif

L'objectif est de mettre en place un serveur **Postfix** fonctionnel pour l’envoi d’e-mails (SMTP), avec un **nom de domaine personnalisé**, une configuration propre, et des outils de maintenance associés.

---

## ⚙️ Prérequis

- Un **nom de domaine valide** (ex : `example.com`)
- Un **serveur Ubuntu** (22.04 recommandé)
- Un **certificat SSL/TLS** (Let's Encrypt ou autre)
- Les **droits sudo/root**
- Une résolution DNS correcte (A / MX / SPF / DKIM recommandés)

---

## 🧱 Structure des répertoires

```bash
/opt/serv_mail/
├── chapitre_01
│   ├── install/
│   │   └── install_postfix_base_chap1.sh     # Script d’installation principal
│   ├── backup/
│   │   └── backup_postfix_base_chap1.sh      # Script de sauvegarde
│   ├── maintenance/
│   │   └── uninstall_postfix_base_chap1.sh   # Script de désinstallation
│   ├── logs/                                 # Logs d’installation et de sauvegarde
│   ├── export/                               # Fichiers exportés (clé, DNS, etc.)
│   ├── documentation/
│   │   ├── README_chapitre_01_fr.md
│   │   └── README_chapitre_01_en.md
│   └── README_fr.md / README.md              # Documentation simplifiée

```
---

📁 Vérifier l’emplacement
Placez install_postfix_base_chap1.sh dans /opt/serv_mail/chapitre_01/install/

## ✅ Le rendre exécutable

```bash
chmod +x install_postfix_base_chap1.sh
```

## ▶️ Lancer l’installation

```bash
sudo ./install_postfix_base_chap1.sh

## 📦 Sauvegarde de la configuration
Une fois le serveur installé, vous pouvez sauvegarder les fichiers critiques :

```bash
sudo /opt/serv_mail/chapitre_01/backup/backup_postfix_base_chap1.sh
```

Ce script sauvegarde notamment :

/etc/hosts

/etc/hostname

/etc/resolv.conf

/etc/postfix/

/etc/mailname

/etc/aliases

Les fichiers sont enregistrés dans :

```bash
/opt/serv_mail/chapitre_01/backup/<domaine>/backup_mail_chap1_<date>.tar.gz

## 🧹 Désinstallation (remise à zéro)
En cas de besoin (retest, rollback, purge), exécutez le script de désinstallation :

```bash
sudo /opt/serv_mail/chapitre_01/maintenance/uninstall_postfix_base_chap1.sh
```

Il propose :

Une sauvegarde avant suppression

Le nettoyage du fichier /etc/hosts, main.cf et aliases

La suppression facultative de Postfix

Une désinstallation multilingue et interactive

## 🗂️ Fichiers modifiés

/etc/postfix/main.cf

/etc/aliases

/etc/hosts

/etc/hostname

/etc/resolv.conf

## 🔐 Étapes suivantes

Test SMTP : envoyer un mail depuis la ligne de commande

Ajouter Dovecot pour la réception (Chapitre 2)

Ajouter une interface de gestion comme PostfixAdmin (Chapitre 3)

Sécuriser avec DKIM, SPF, DMARC (Chapitre 4)



## 🧑‍💼 Auteur

pontarlier-informatique
Projet Osnetworking
Dernière mise à jour : 17/06/2025

Guide basé sur LinuxBabe, avec adaptation complète, logs, structure et maintenance

## 🌐 Références
Guide Osnetworking – Chapitre 1