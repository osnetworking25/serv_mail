# 🧹 Chapitre 1 – Désinstallation de la configuration Postfix de base

Ce script permet de supprimer proprement la configuration initiale de Postfix réalisée dans le cadre du **Chapitre 1** du projet `serv_mail`.

---

## 🧱 Structure du script

Le script `uninstall_postfix_base_chap1.sh` réalise les actions suivantes :

1. ✅ Vérifie que Postfix est installé (et propose sa suppression)
2. 💾 Sauvegarde les fichiers de configuration `main.cf` et `aliases`
3. 🗑️ Nettoie les fichiers `/etc/hosts`, `main.cf` et `aliases`
4. 📁 Conserve les répertoires `logs/` et `backup/` créés lors du chapitre 1
5. ⚠️ Ne modifie pas les permissions système ni les fichiers en dehors de ceux explicitement listés

---

## 🚨 Précautions

- Ce script est **destructif** : il supprime ou nettoie certains fichiers de configuration système.
- Les mails stockés localement peuvent être perdus si Postfix est supprimé.
- Les sauvegardes précédemment effectuées dans `/opt/serv_mail/chapitre_01/backup/` et les logs dans `/logs/` **ne sont pas supprimés automatiquement**.
- À utiliser uniquement dans un environnement de test ou avant une réinstallation complète.

---

## ▶️ Lancer le script

```bash
sudo bash /opt/serv_mail/chapitre_01/maintenance/uninstall_postfix_base_chap1.sh

```
Vous serez invité à :

Sélectionner votre langue (Français ou English)

Confirmer la suppression de Postfix si celui-ci est installé

## ⚠️ Attention
Ce script est **destructif** et ne doit être utilisé que si vous avez l'intention de revenir complètement sur le chapitre 1.

## 📂 Emplacement recommandé

```bash
sudo bash /opt/serv_mail/chapitre_01/maintenance/uninstall_chapitre1.sh
```

## 📘 Support linguistique
Prise en charge multilingue via `/opt/serv_mail/lang/fr.sh` and `en.sh`. Les invites et les messages s'affichent en fonction de la langue sélectionnée.

/opt/serv_mail/lang/fr.sh
/opt/serv_mail/lang/en.sh


## 🧑 Autheur
pontarlier-informatique – osnetworking

## 🛠 Testé avec
- Ubuntu 22.04 LTS
- Postfix 3.6.4

---
> Script version 1.0 – for Chapter 1 uninstall process.