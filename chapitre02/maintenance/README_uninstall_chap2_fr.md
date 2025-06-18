# 🧹 Script de désinstallation – Chapitre 2 : Postfix & Dovecot

Ce script Bash permet d’annuler **toutes les modifications apportées au système durant le Chapitre 2**, qui portait sur l’installation de **Postfix avec TLS** et **Dovecot avec Maildir**.

Il permet de revenir à un état identique à la **fin du Chapitre 1**, sans supprimer la base de PostfixAdmin ni les fichiers du Chapitre 1.

---

## 📦 Nom du fichier

```bash
uninstall_chap2.sh
```
## 🎯 Objectif du script
Ce script vise à :

Restaurer tous les fichiers de configuration modifiés par le Chapitre 2 à partir des sauvegardes .original

Supprimer les services installés dans ce chapitre : Dovecot, Apache, Certbot

Réinitialiser la configuration TLS et le service Dovecot comme s’il n’avait jamais été installé

Retirer le redémarrage automatique de Dovecot

Rétablir le fichier crontab root s’il a été modifié

Redémarrer les services pour assurer un état propre

## 🔁 Étapes effectuées par le script
Chargement du fichier de langue fr.sh ou en.sh selon votre choix

Définition de la variable DOMAIN et du chemin de sauvegarde BACKUP_DIR

Restauration des fichiers de configuration :

/etc/dovecot/dovecot.conf

/etc/dovecot/conf.d/10-*.conf (mail, auth, ssl, master)

/etc/postfix/main.cf

/etc/postfix/master.cf

/etc/ssl/openssl.cnf

Restauration du fichier crontab de root (si la sauvegarde existe)

Suppression du fichier de redémarrage automatique restart.conf de Dovecot

Suppression du vhost Apache utilisé pour le certificat TLS + suppression de Certbot et Apache

Désinstallation complète de Dovecot et ses modules (imap, pop3, lmtp)

Redémarrage des services Postfix et Dovecot (dans un état propre)

Affichage d’un message final de succès

## 📂 Prérequis
Les fichiers .original doivent exister dans le dossier :

/opt/serv_mail/chapitre02/backup/${DOMAIN}



## ⚠️ Avertissements importants

Ce script effectue une restauration des fichiers de configuration système **basée sur les sauvegardes `.original` créées lors de l'installation du Chapitre 2**. Il vise à revenir à un état stable du système, identique à la fin du Chapitre 1, juste avant l'introduction de Dovecot et du chiffrement TLS avec Postfix.

À ce stade de la documentation (Chapitre 2), **aucun compte virtuel ni boîte aux lettres n’ont encore été créés** via PostfixAdmin. Le script ne modifie donc en aucun cas la base de données MySQL/MariaDB de PostfixAdmin, et ne supprime aucun domaine ni utilisateur car ceux-ci **n'existent pas encore**.

Cependant, il est **fortement recommandé** de vérifier manuellement **l’ensemble des fichiers suivants après l'exécution du script** pour garantir un retour propre :

- `/etc/postfix/main.cf` → doit contenir uniquement la configuration du Chapitre 1 (sans TLS, ni milters, ni dovecot LDA)
- `/etc/postfix/master.cf` → idem, sans mention de dovecot ou submission modifié
- `/etc/dovecot/` → les dossiers et fichiers doivent être absents ou restaurés dans leur état par défaut
- `/etc/apache2/sites-available/` → aucun fichier `$DOMAIN.conf` ne doit rester
- `/etc/systemd/system/dovecot.service.d/restart.conf` → ce fichier doit être supprimé
- `/etc/ssl/openssl.cnf` → doit avoir été restauré si modifié
- `/var/spool/cron/crontabs/root` → doit refléter le contenu sauvegardé (ou être restauré manuellement)

Le script ne supprime **ni les services Postfix ni les configurations du Chapitre 1**. Il ne vide pas la base de données PostfixAdmin, ne supprime pas les scripts ou documents du projet, et n’a aucune incidence sur les autres chapitres déjà appliqués.

Enfin, ce script **ne couvre pas les cas particuliers ou personnalisations manuelles** que vous auriez pu apporter vous-même à la configuration TLS, aux fichiers Apache, au comportement de Dovecot ou aux certificats. En cas de doute ou de modification personnalisée, **vous devez restaurer manuellement** les fichiers concernés depuis vos propres sauvegardes ou à partir d’un état propre du Chapitre 1.

---

🟢 Si vous avez suivi tous les chapitres à la lettre jusqu'ici, l’exécution de ce script suffit à ramener votre système dans un état propre, identique à celui à la fin du Chapitre 1 : Postfix installé, mais sans TLS, sans Dovecot, sans Apache, et prêt pour les étapes suivantes.


## 📘 Support multilingue
Les messages sont affichés selon le fichier de langue :

/opt/serv_mail/lang/fr.sh
/opt/serv_mail/lang/en.sh

## 🧑 Auteur
pontarlier-informatique – osnetworking

## 🛠 Testé avec
Ubuntu Server 22.04 LTS

Postfix 3.6.4

Dovecot 2.3

Apache 2.4

Certbot (snap ou apt)

