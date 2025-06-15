# 📘 Chapitre 1 – Installation de Postfix (base)

Ce script configure un serveur Postfix de base en suivant le guide LinuxBabe, avec des améliorations professionnelles pour un usage en production.

---

## 🎯 Objectif

Mettre en place un serveur de messagerie local avec Postfix sur Ubuntu, incluant :

- Nom d’hôte (FQDN)
- Configuration DNS minimale (MX, SPF, DMARC)
- Installation de Postfix
- Tests d’envoi de mail
- Sécurisation de la configuration (IPv4 only, alias, etc.)

---

## ⚙️ Prérequis

- Serveur Ubuntu 22.04 ou supérieur
- Accès root (sudo)
- Domaine fonctionnel avec gestion DNS (Gandi, OVH, Cloudflare, etc.)
- Ports 25, 587 et 465 ouverts (au moins le 25 sortant pour ce chapitre)

---

## 🧱 Arborescence

```bash
/opt/serv_mail/
├── chapitre01
│ ├── backup
│ ├── documentation
│ ├── export
│ ├── install
│     └──install_postfix_base_chap1.sh
│ ├── logs
│ ├── maintenance
│     └──uninstall_postfix_base_chap1.sh
│ ├── README.md
│ └── README_fr.md

```

---

## 🚀 Lancement du script

### 1. 📁 Vérifiez l’emplacement du script

```bash
sudo mkdir -p /opt/serv_mail/chapitre_01/
sudo cp install_postfix_base_chap1.sh /opt/serv_mail/chapitre_01/
```

### 2. ✅ Rendez-le exécutable

```bash
sudo chmod +x /opt/serv_mail/chapitre_01/install_postfix_base_chap1.sh
```

### 3. ▶️ Lancez le script

```bash
sudo /opt/serv_mail/chapitre_01/install_postfix_base_chap1.sh
```

Vous serez invité à saisir :

- Langue : 🇫🇷 ou 🇬🇧
- Nom de domaine principal (domain.tld)
- Adresse d’expéditeur (MAIL_FROM)
- Adresse de test (MAIL_DEST)
- Nom FQDN du serveur mail (mail.domain.tld)

---

## 🔍 Étapes automatisées

| Étape | Description |
|-------|-------------|
| 1     | Domaine principal |
| 2     | FQDN dans `/etc/hosts` |
| 3     | Configuration hostname |
| 4     | DNS : Rappel + vérifications |
| 5     | Update + installation Postfix |
| 6     | Vérification pare-feu UFW |
| 7     | Test port 25 sortant (telnet) |
| 8     | Test avec `sendmail` |
| 9     | Test avec `mail` (mailutils) |
| 10    | `message_size_limit` |
| 11    | Définition de `myhostname` |
| 12    | Aliases `postmaster:` et `root:` |
| 13    | Choix du protocole IPv4/IPv6 |
| 14    | Redémarrage de Postfix |
| 15    | Sauvegardes .bak |

---

## 🗂️ Fichiers générés

- **Logs :** `/opt/serv_mail/chapitre_01/logs/install_postfix_base_chap1.log`
- **Sauvegardes :**
  - `/etc/postfix/main.cf.bak`
  - `/etc/aliases.bak`

---
## 🧩 Étapes suivantes

Poursuivre avec le **Chapitre 2 : Configuration Dovecot + Maildir** dès que la réception est testée et que Postfix fonctionne correctement en émission.

---

## 🧑‍💼 Auteurs

- **Auteur :** pontarlier-informatique
- **Projet :** Osnetworking
- **Date :** 14/06/2025

---

## 🌐 Référence

- [Guide Osnetworking – Chapitre 1]lien
