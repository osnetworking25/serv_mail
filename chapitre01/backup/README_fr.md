# 📦 Script de sauvegarde – Chapitre 1

Ce script effectue une **sauvegarde complète** des fichiers essentiels du **Chapitre 1** de l'installation du serveur mail (Postfix de base, hostname, DNS, etc.).

---

## 📁 Fichiers sauvegardés

- `/etc/hosts`
- `/etc/hostname`
- `/etc/resolv.conf`
- `/etc/postfix/` (dossier complet)
- `/etc/mailname`
- `/etc/postfix/main.cf`
- `/etc/aliases`

---

# 🧱 Arborescence

```bash
/opt/serv_mail/
├── chapitre01
│ ├── backup
│     └──backup_postfix_base_chap1.sh
│ ├── documentation
│ ├── export
│ ├── install
```

## 📍 Emplacement de la sauvegarde

Les archives compressées sont enregistrées dans :

/opt/serv_mail/chapitre_01/backup/<nom_du_domaine>/backup_mail_chap1_YYYY-MM-DD_HHhMM.tar.gz

Un fichier de log est généré en cas d’erreur :

---

## 🧑‍💻 Utilisation

Lancer le script en tant que super-utilisateur :

```bash
sudo bash /opt/serv_mail/chapitre_01/backup/backup_postfix_base_chap1.sh
```

Vous serez invité à sélectionner la langue et à entrer le nom de domaine principal utilisé lors de l’installation (ex. : domain.tld).

## 📌 Prérequis

Le script doit être lancé en super-utilisateur (sudo)

Les fichiers de langue suivants doivent être présents :

/opt/serv_mail/lang/fr.sh

/opt/serv_mail/lang/en.sh

Les dossiers suivants doivent exister (créés automatiquement si absents) :

/opt/serv_mail/chapitre_01/backup/

/opt/serv_mail/chapitre_01/logs/


Avant exécution, assurez-vous que le script est exécutable :

```bash
chmod +x /opt/serv_mail/chapitre_01/backup/backup_postfix_base_chap1.sh
```



Le chemin d'exécution recommandé est :
/opt/serv_mail/chapitre_01/backup/

## 📤 Auteur
pontarlier-informatique – osnetworking
Version : 1.1 – 2025-06-17