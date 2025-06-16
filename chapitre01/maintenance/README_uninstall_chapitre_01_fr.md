# 🧹 Chapitre 1 – Désinstallation de la configuration Postfix de base

Ce script permet de supprimer proprement la configuration initiale de Postfix réalisée dans le cadre du **Chapitre 1** du projet `serv_mail`.

---

## 🧱 Structure du script

Le script `uninstall_postfix_base_chap1.sh` réalise les actions suivantes :

1. ✅ Vérifie que Postfix est installé
2. ❌ Supprime Postfix et ses dépendances
3. 🗑️ Supprime les fichiers de configuration créés
4. 📁 Vide les répertoires de logs et de sauvegarde créés dans le chapitre
5. 🔐 Réinitialise les permissions éventuellement modifiées

---

## 🚨 Précautions

- Ce script est irréversible. Sauvegardez les fichiers si besoin avant de l’exécuter.
- Les mails stockés localement seront supprimés.
- À utiliser uniquement dans un environnement de test ou avant une réinstallation complète.

---

## ▶️ Lancer le script

```bash
sudo bash uninstall_postfix_base_chap1.sh
```

## ⚠️ Attention
Ce script est **destructif** et ne doit être utilisé que si vous avez l'intention de revenir complètement sur le chapitre 1.

## 📂 Emplacement recommandé

```bash
sudo bash /opt/serv_mail/chapitre_01/maintenance/uninstall_chapitre1.sh
```

## 📘 Support linguistique
Prise en charge multilingue via `/opt/serv_mail/lang/fr.sh` and `en.sh`. Les invites et les messages s'affichent en fonction de la langue sélectionnée.

## 🧑 Autheur
pontarlier-informatique – osnetworking

## 🛠 Testé avec
- Ubuntu 22.04 LTS
- Postfix 3.6.4

---
> Script version 1.0 – for Chapter 1 uninstall process.