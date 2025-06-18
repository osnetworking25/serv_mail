# 📘 Chapitre 02 – Installation de Postfix et Dovecot

Ce chapitre vous guide à travers l’installation d’un serveur de messagerie sécurisé sur Ubuntu, en suivant les bonnes pratiques du guide LinuxBabe.

---

## 🧾 Étapes réalisées dans ce script

1. 🔒 Vérification du pare-feu UFW et ouverture des ports nécessaires
2. 📥 Installation de Certbot et du serveur Apache
3. 🌐 Création du virtualhost Apache + certificat Let's Encrypt
4. 📤 Installation de Postfix + activation des ports 465/587
5. 📥 Installation de Dovecot (IMAP, POP3)
6. 💾 Activation du format Maildir dans Dovecot
7. 📬 Configuration de la livraison des mails via Dovecot LMTP
8. 🔐 Configuration de l’authentification SASL (Postfix ↔︎ Dovecot)
9. 🧑‍💻 Configuration des mécanismes d’authentification Dovecot
10. 🔐 Configuration TLS de Dovecot avec certificats Let's Encrypt
11. 🛡️ Désactivation du provider FIPS d’OpenSSL (Ubuntu 22.04)
12. 📡 Activation du socket SASL Dovecot pour Postfix
13. ♻️ Auto-renouvellement du certificat TLS via Certbot (cron)
14. 🔍 Vérification du renouvellement avec `--dry-run`
15. 🔁 Redémarrage automatique de Dovecot via systemd
16. 🔄 Redémarrage des services Postfix et Dovecot


---

## 📁 Fichiers impliqués

- `install/install_Postfix_et_Dovecot_chap2.sh` → Script principal d’installation
- `lang/fr.sh` → Fichier de langue française
- `lang/en.sh` → Fichier de langue anglaise

---

## 📌 Remarques

- Tous les messages sont dynamiques et multilingues
- Chaque étape est clairement isolée avec sauvegarde des fichiers critiques (`.bak`)
- Le certificat TLS est généré via Apache et Certbot en HTTP-01
- Le test IMAP utilise OpenSSL pour vérifier le port 993 (Dovecot)

---

## 👨‍💻 Auteur

**Pontarlier-Informatique** – _osnetworking_
