# 📬 Serveur Mail 2025 – Configuration complète (Ubuntu + Postfix + Dovecot)

> 🔒 Infrastructure mail professionnelle multi-domaine, basée sur le guide [LinuxBabe](https://www.linuxbabe.com)

---

## 🔧 Présentation du projet

Ce dépôt fournit une configuration complète et modulaire d’un **serveur mail auto-hébergé**, incluant :

- **Postfix**, **Dovecot**, **OpenDKIM**, **PostfixAdmin**, **Roundcube**
- Support **multi-domaine**, protocoles sécurisés (**SPF**, **DKIM**, **DMARC**, **TLS**)
- Scripts interactifs multilingues (**français / anglais**)
- Fonctionnalités avancées : plugins, SSL, Fail2Ban, proxy HAProxy, warm-up IP
- Organisation claire par **chapitre autonome**

> 💡 Chaque chapitre est indépendant, documenté, et peut être **annulé** via un script `revert_*.sh`.

---

## 📁 Structure du dépôt

```bash
/opt/serv_mail/
├── chapitre_01/           # Base Ubuntu + configuration SSH
├── chapitre_02/           # Réseau, DNS et nom d'hôte
├── chapitre_03/           # Postfix + Dovecot (IMAP) avec TLS
├── chapitre_04/           # SPF & DKIM via OpenDKIM
├── chapitre_05/           # Installation de PostfixAdmin
├── chapitre_06/           # Amélioration de la délivrabilité (anti-spam)
├── chapitre_07/           # Webmail Roundcube + plugins
├── chapitre_08/           # Gestion de plusieurs domaines mail
├── chapitre_09/           # Anti-spam avancé avec Postfix
├── chapitre_10/           # Filtrage par SpamAssassin
├── chapitre_11/           # Intégration Amavis + ClamAV
├── chapitre_12/           # Sécurisation du serveur (VPN auto-hébergé)
├── chapitre_13/           # Réputation mail et blacklist
├── chapitre_14/           # Postscreen (filtrage robots SMTP)
├── chapitre_15/           # Warm-up IP + sauvegarde complète
│
├── lang/                  # Fichiers de langue dynamiques
│   ├── fr.sh              # Messages en français
│   └── en.sh              # Messages en anglais
│
├── LICENSE                # Licence du projet (MIT)
├── README.md              # Présentation globale (en anglais)
└── README.fr.md           # Présentation globale (français)



Détail des chapitres

Dossier	Contenu du chapitre
chapitre_01/	Installation d’Ubuntu et configuration SSH
chapitre_02/	Réglages réseau et configuration DNS
chapitre_03/	Postfix et Dovecot : installation et configuration
chapitre_04/	Configuration de SPF & DKIM (OpenDKIM)
chapitre_05/	Installation et configuration de PostfixAdmin
chapitre_06/	Optimiser la délivrabilité et éviter les spams
chapitre_07/	Webmail Roundcube, plugins et personnalisation
chapitre_08/	Gestion de plusieurs domaines dans PostfixAdmin
chapitre_09/	Blocage des spams avec Postfix
chapitre_10/	Mise en place de SpamAssassin
chapitre_11/	Intégration d’Amavis et ClamAV pour l’antivirus
chapitre_12/	Sécuriser le serveur avec un VPN auto-hébergé
chapitre_13/	Contourner les blacklists et améliorer sa réputation
chapitre_14/	Postscreen (optionnel) : bloquer les spambots
chapitre_15/	Amélioration automatique de la réputation IP et warm-up domaine
lang/	Fichiers de traduction multilingues (fr.sh, en.sh)
LICENSE	Licence du projet (MIT)
README.md	Présentation globale (anglais)
README.fr.md	Présentation globale (français)


🌐 Choisissez votre langue / Choose your language :
fr (Français) / en (English)

♻️ Fonction de restauration
Chaque script critique possède un script de restauration associé (revert_*.sh) pour revenir en arrière en toute sécurité :

Supprime les fichiers de configuration, les clés, les paquets

Préserve les exports ou backups si vous le souhaitez (avec confirmation)

Chargement dynamique des langues : le script est bilingue

✨ Cela permet d'expérimenter ou de tester sans risque, chapitre par chapitre.

🛡️ Sauvegarde & stratégie finale
Une stratégie de sauvegarde multi-niveaux sera ajoutée dans le chapitre_15, incluant :

📦 Sauvegarde complète : mails, base de données, configurations

🔄 Restauration automatisée

🔗 Intégration avec NAS Synology ou autres cibles Rsync/SFTP

📋 Journalisation et contrôle post-restauration

🌍 Prise en charge des langues
Tous les scripts affichent un prompt initial pour choisir la langue :

bash
Copier
Modifier
🌐 Choisissez votre langue / Choose your language :
fr (Français) / en (English)
Les messages sont automatiquement traduits selon votre choix (fr.sh ou en.sh).


## 🧑‍💻 Auteur
Pontarlier-Informatique / osnetworking  
https://github.com/osnetworking25

## 🪪 Licence
MIT (prévue)

---

📝 Ce projet est publié sous licence [MIT](../LICENSE).
© 2025 osnetworking / pontarlier-informatique