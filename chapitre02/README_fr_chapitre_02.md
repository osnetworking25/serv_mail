# 📘 Chapitre 2 – Installation et configuration de Postfix et Dovecot (TLS activé)

Ce script configure un serveur **Postfix** de base en suivant le guide **LinuxBabe**, avec des améliorations professionnelles pour un usage en production.


---

## 🎯 Objectif

L'objectif de ce chapitre est d'installer et de configurer un serveur de messagerie sécurisé avec **Postfix** pour la gestion des emails sortants (SMTP) et **Dovecot** pour la gestion des emails entrants (IMAP/POP3), avec **TLS** activé pour sécuriser les communications.


---

## ⚙️ Prérequis

Avant de commencer, assurez-vous que :

- Vous disposez d'un serveur **Ubuntu** (idéalement version 22.04 ou supérieure).
- Vous avez un **nom de domaine valide** (ex : `example.com`) et un certificat **SSL/TLS** valide.
- Vous avez les **droits sudo** pour exécuter les commandes d'installation et de configuration.


---

## 🧱 Arborescence

Voici la structure du projet **Chapitre 2** :

/opt/serv_mail/
├── chapitre_02
│   ├── backup/                    # Répertoire pour les sauvegardes du serveur mail
│   ├── documentation/             # Contient la documentation pour ce chapitre
│   │   ├── README.md              # Documentation générale (en anglais)
│   │   └── README_fr.md           # Documentation en français
│   ├── export/                    # Dossier pour exporter des configurations ou des logs
│   ├── install/                   # Contient les scripts d'installation
│   │   └── install_postfix_base_chap2.sh  # Script principal d'installation de Postfix et Dovecot
│   ├── logs/                      # Dossier pour les logs générés par le script d'installation
│   ├── maintenance/               # Répertoire pour les scripts de maintenance
│   │   └── uninstall_postfix_base_chap2.sh  # Script pour désinstaller ou nettoyer Postfix/Dovecot
│   ├── README.md                  # Fichier README principal (en anglais) expliquant le déroulement de l'installation
│   └── README_fr.md               # Fichier README en français expliquant le déroulement de l'installation

---
## 🚀 Lancement du script

### 1. 📁 Vérifiez l’emplacement du script

Le script doit être situé dans le répertoire `/opt/serv_mail/chapitre_02/`.

### 2. ✅ Rendez-le exécutable

```bash
chmod +x install_postfix_dovecot.sh
```

### 3. ▶️ Lancez le script

```
sudo ./install_postfix_dovecot.sh
```

Le script effectuera les actions suivantes :

Vérification et activation de UFW (pare-feu).
Installation et configuration de Postfix.
Installation et configuration de Dovecot.
Activation de TLS pour sécuriser les communications.
Test de la configuration SMTP (Postfix) et IMAP (Dovecot).

---

## 🔍 Étapes automatisées

Les étapes suivantes sont automatisées par le script :

Vérification et activation de UFW (pare-feu).

Installation de Postfix et configuration pour accepter les connexions sécurisées.

Installation de Dovecot et configuration pour Maildir et TLS.

Test de la configuration Postfix et IMAP via Dovecot.

Redémarrage des services Postfix et Dovecot.



---

## 🗂️ Fichiers générés

Une fois Chapitre 2 terminé, voici ce que vous pouvez faire :

Configurer un client de messagerie pour envoyer et recevoir des emails via Postfix et Dovecot.

Configurer PostfixAdmin ou un autre outil de gestion des comptes pour administrer les utilisateurs de messagerie.

Passer au Chapitre 3 pour la gestion avancée des utilisateurs et la mise en place de la gestion des boîtes aux lettres.



---
## 🧩 Étapes suivantes


### Explication :
- Le **titre principal** de ce fichier README est désormais bien structuré avec **Chapitre 2** et le sous-titre sur **Postfix et Dovecot**.
- Chaque section est bien définie pour guider l'utilisateur tout au long du processus, avec des instructions claires pour exécuter et utiliser le script.
- **Répertoires et fichiers** sont organisés avec des explications pour chaque dossier créé par le script.
- Les **étapes automatisées** sont bien détaillées pour expliquer ce que le script réalise.

### Conclusion :
Le **README.md** est bien structuré pour **Chapitre 2**. Si tu souhaites faire des ajouts ou ajuster certains éléments, n’hésite pas à me le dire. Tu es désormais prêt pour partager et exécuter ce script dans ton projet !

Si tu as besoin d'autres ajustements ou d'aide pour tester, fais-le moi savoir ! 😊


---

## 🧑‍💼 Auteurs

- **Auteur :** pontarlier-informatique
- **Projet :** Osnetworking
- **Date :** 14/06/2025

---

## 🌐 Référence

- [Guide Osnetworking – Chapitre 2]lien


### Explication :
- Le **titre principal** de ce fichier README est désormais bien structuré avec **Chapitre 2** et le sous-titre sur **Postfix et Dovecot**.
- Chaque section est bien définie pour guider l'utilisateur tout au long du processus, avec des instructions claires pour exécuter et utiliser le script.
- **Répertoires et fichiers** sont organisés avec des explications pour chaque dossier créé par le script.
- Les **étapes automatisées** sont bien détaillées pour expliquer ce que le script réalise.

### Conclusion :
Le **README.md** est bien structuré pour **Chapitre 2**. Si tu souhaites faire des ajouts ou ajuster certains éléments, n’hésite pas à me le dire. Tu es désormais prêt pour partager et exécuter ce script dans ton projet !

Si vous avez besoin d'autres ajustements ou d'aide pour tester, fais-le moi savoir ! 😊
