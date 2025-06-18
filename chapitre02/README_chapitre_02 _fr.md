# 📘 Serveur Mail 2025 – Chapitre 02  
## Installation de Postfix et Dovecot avec TLS (Let's Encrypt)

---

## 🧭 Objectif du chapitre

Ce chapitre décrit l'installation complète d'un serveur de messagerie de base basé sur **Postfix** (pour l'envoi des e-mails) et **Dovecot** (pour la réception via IMAP/POP3), avec un chiffrement **TLS Let's Encrypt** activé dès le départ. Le tout est pensé pour un usage **professionnel** sur une machine Ubuntu (22.04 ou 24.04), avec des explications claires, des fichiers `.bak` créés avant chaque modification, et des messages multilingues.

---

## 📋 Étapes détaillées

### 1️⃣ Vérification du pare-feu UFW

Le script vérifie si UFW est actif. Si oui, il autorise les ports nécessaires (25, 465, 587, 993, 443, etc.) afin que les services mail et web fonctionnent correctement. Une étape simple mais essentielle pour éviter tout blocage réseau.

---

### 2️⃣ Installation d'Apache et de Certbot

Apache est installé en tant que serveur HTTP local, utile pour la validation TLS. Le plugin Certbot dédié à Apache est également installé pour simplifier l’obtention de certificats TLS avec Let's Encrypt. Cela prépare l’environnement à la création d’un certificat sécurisé.

---

### 3️⃣ Obtention du certificat TLS

Certbot est utilisé pour générer un certificat TLS valide à partir du FQDN saisi. L’email Certbot est demandé pour être contacté en cas de problème. Le certificat est installé à `/etc/letsencrypt/live/domain.tld/` et sera utilisé par Dovecot (et plus tard PostfixAdmin, Roundcube…).

---

### 4️⃣ Installation et configuration de Postfix

Postfix est installé avec ses dépendances. Le fichier `main.cf` est configuré avec :
- le nom de domaine (mydomain)
- le nom FQDN du serveur (myhostname)
- l’activation du format `Maildir/` pour la boîte mail
- le protocole réseau limité à IPv4

Le fichier `master.cf` est modifié pour activer les ports **587 (submission)** et **465 (smtps)** pour les clients.

---

### 5️⃣ Installation de Dovecot

Le serveur Dovecot est installé avec les paquets suivants :
- `dovecot-core` : noyau du serveur
- `dovecot-imapd` : prise en charge du protocole IMAP
- `dovecot-pop3d` : support POP3 (optionnel)

Cela permet de lire les mails à travers un client mail (Thunderbird, Outlook, etc.).

---

### 6️⃣ Activation des protocoles IMAP/POP3

Le fichier `dovecot.conf` est modifié pour activer explicitement les protocoles nécessaires :
```bash
protocols = imap pop3
```

7️⃣ Passage au format Maildir
Le fichier 10-mail.conf est modifié pour que Dovecot stocke les mails dans ~/Maildir (et non mbox par défaut). Le groupe mail est associé à Dovecot pour qu’il puisse accéder aux boîtes des utilisateurs.

8️⃣ Livraison du courrier via LMTP
Postfix est configuré pour remettre les mails à Dovecot via LMTP (un protocole interne SMTP-like), ce qui permet une compatibilité totale avec Maildir, les plugins Sieve, et une meilleure gestion des erreurs.

9️⃣ Authentification SASL (SMTP AUTH)
Le fichier 10-auth.conf est configuré pour :

désactiver l’authentification en clair sans TLS

définir le format de nom d’utilisateur en %n (sans le domaine)

activer les mécanismes plain login pour les clients mail

🔟 Configuration TLS dans Dovecot
Le fichier 10-ssl.conf est modifié pour :

exiger le chiffrement (ssl = required)

charger les certificats Let's Encrypt

forcer les ciphers du serveur

désactiver TLS 1.0/1.1 pour plus de sécurité

1️⃣1️⃣ Désactivation du provider FIPS (Ubuntu 22.04)

Ubuntu 22.04 active par défaut le provider FIPS via OpenSSL 3. Ce provider est incompatible avec Dovecot. On commente donc la ligne suivante dans /etc/ssl/openssl.cnf :

#providers = provider_sect

1️⃣2️⃣ Socket d’authentification Dovecot pour Postfix
On configure le socket /var/spool/postfix/private/auth dans le fichier 10-master.conf, afin que Postfix puisse s’authentifier auprès de Dovecot.

1️⃣3️⃣ Renouvellement automatique du certificat TLS
Un cron job quotidien est ajouté pour exécuter certbot renew et redémarrer les services concernés (Postfix, Dovecot, Apache). Cela garantit une sécurité continue sans intervention manuelle.

1️⃣4️⃣ Vérification du renouvellement avec --dry-run
On teste le renouvellement du certificat TLS en mode simulation (--dry-run) pour vérifier que tout fonctionne sans erreur. Très utile pour détecter un souci de cron ou de permission.

1️⃣5️⃣ Redémarrage automatique de Dovecot
Un fichier restart.conf est créé pour indiquer à systemd de relancer Dovecot automatiquement en cas de crash :

[Service]
Restart=always
RestartSec=5s

1️⃣6️⃣ Redémarrage final des services
Le script redémarre Postfix et Dovecot pour appliquer toutes les modifications (sockets, TLS, auth, etc.). Un message de succès est affiché.

## 🗂️ Fichiers de configuration modifiés

/etc/postfix/main.cf
/etc/postfix/master.cf
/etc/dovecot/dovecot.conf
/etc/dovecot/conf.d/10-mail.conf
/etc/dovecot/conf.d/10-auth.conf
/etc/dovecot/conf.d/10-ssl.conf
/etc/dovecot/conf.d/10-master.conf
/etc/systemd/system/dovecot.service.d/restart.conf
/etc/ssl/openssl.cnf

## 📦 Fichiers générés et sauvegardes
Tous les fichiers modifiés sont sauvegardés avec un suffixe .bak_DATE avant modification.

Les fichiers temporaires et logs sont stockés dans /opt/serv_mail/Chapitre_2/install/ et /logs/.

Les scripts sont compatibles bash, et chaque message est affiché selon la langue sélectionnée (fr.sh / en.sh).

## 🧱 Arborescence recommandée

/opt/serv_mail/
├── Chapitre_1/
├── Chapitre_2/
│   ├── install/
│   └── README_fr.md
│   ├── maintenance/
│   └── README_fr.md
│   ├── logs/
│   └── README_fr.md
├── lang/
│   ├── fr.sh
│   └── en.sh

✍️ Auteur
Pontarlier-Informatique – Osnetworking
📅 Dernière mise à jour : juin 2025















